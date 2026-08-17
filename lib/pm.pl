# Evaluate polymake properties and write them to a JSON file for polymaking.
#
# one shot:    pm.pl [OPTIONS] RESULTFILE OBJFILE KEYWORD...
#              pm.pl [OPTIONS] RESULTFILE --version
# persistent:  do "pm.pl"; then call polymaking_setup and polymaking_eval,
#              see POLYMAKING_StartServer in lib/environment.gi
#
# The result is a JSON object with the keys "version", "values" (keyword ->
# serialized value), "errors" (keyword -> message) and, if the object could not
# be loaded at all, "fatal". Writing it to a file rather than to stdout keeps it
# clear of anything polymake prints.

# Reassociating the glob also catches err_print/warn_print, which write to
# $Polymake::console, and polymake's own fatal error handler. Verbose must be
# set before any load(), which consults Verbose::files.
sub polymaking_setup {
  my ($errfile, $quiet) = @_;
  if (defined($errfile) && length($errfile)) {
    open(STDERR, '>', $errfile) or die "cannot redirect stderr to $errfile: $!\n";
    STDERR->autoflush;
  }
  if ($quiet) {
    $Polymake::User::Verbose::credits = 0;
    $Polymake::User::Verbose::files   = 0;
  }
}

# lexical, not a package variable: under --script polymake compiles this with
# its own namespace pragma, which rejects `our`.
my %polymaking_applied;

sub polymaking_eval {
  my ($out, $errfile, $file, $prefer, @keywords) = @_;
  my %r = (version => "$Polymake::Version", values => {}, errors => {});

  # Reopen rather than rely on the handle from polymaking_setup: the caller
  # starts each call from a clean file, and a persistent process would otherwise
  # go on writing to the old, unlinked one.
  polymaking_setup($errfile, 0) if defined($errfile) && length($errfile);

  if (defined($file) && length($file)) {
    my $obj = eval { Polymake::User::load($file) };
    if ($@) {
      $r{fatal} = "$@";
    } else {
      # Not Polymake::User::prefer_now: under --script
      # $Polymake::User::application is a stub whose preferences are unset.
      # Mode::create rather than the usual Mode::strict, so polymake does not
      # consider its settings changed and rewrite them when a config path is in
      # use. Once per application: in a persistent process, adding the same
      # preference again makes polymake complain that one is already in effect.
      my $app = $obj->type->application;
      for my $expr (@$prefer) {
        next if $polymaking_applied{$app->name}{$expr}++;
        $app->prefs->add_preference($expr, Polymake::Core::Preference::Mode::create);
      }

      for my $kw (@keywords) {
        my $v = eval { my $x = $obj; $x = $x->$_ for split /\./, $kw; $x };
        if ($@) {
          $r{errors}{$kw} = "$@";
        } elsif (!defined($v)) {
          $r{errors}{$kw} = "undefined";
        } else {
          my $s = eval { Polymake::Core::Serializer::serialize($v) };
          $@ ? ($r{errors}{$kw} = "$@") : ($r{values}{$kw} = $s);
        }
      }
    }
  }

  open(my $fh, '>', $out) or die "pm.pl: cannot write $out: $!\n";
  print $fh Polymake::encode_json(\%r);
  close($fh);
  return 1;
}

if (@ARGV) {
  my ($errfile, $quiet, @prefer);
  while (@ARGV && $ARGV[0] =~ /^--/ && $ARGV[0] ne '--version') {
    my $opt = shift(@ARGV);
    last if $opt eq '--';
    if    ($opt eq '--stderr') { $errfile = shift(@ARGV) }
    elsif ($opt eq '--quiet')  { $quiet = 1 }
    elsif ($opt eq '--prefer') { push @prefer, shift(@ARGV) }
    else  { die "pm.pl: unknown option $opt\n" }
  }
  polymaking_setup($errfile, $quiet);
  my $out  = shift(@ARGV);
  my $file = shift(@ARGV);
  $file = undef if defined($file) && $file eq '--version';
  polymaking_eval($out, undef, $file, \@prefer, @ARGV);
}

1;
