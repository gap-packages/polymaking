# Evaluate polymake properties and write them to a JSON file for polymaking.
#
# usage: pm.pl [OPTIONS] RESULTFILE OBJFILE KEYWORD...
#        pm.pl [OPTIONS] RESULTFILE --version
#
# The result is a JSON object with the keys "version", "values" (keyword ->
# serialized value), "errors" (keyword -> message) and, if the object could not
# be loaded at all, "fatal". Writing it to a file rather than to stdout keeps it
# clear of anything polymake prints.

my ($errfile, $quiet, @prefer);
while (@ARGV && $ARGV[0] =~ /^--/ && $ARGV[0] ne '--version') {
  my $opt = shift(@ARGV);
  last if $opt eq '--';
  if    ($opt eq '--stderr') { $errfile = shift(@ARGV) }
  elsif ($opt eq '--quiet')  { $quiet = 1 }
  elsif ($opt eq '--prefer') { push @prefer, shift(@ARGV) }
  else  { die "pm.pl: unknown option $opt\n" }
}

# Reassociating the glob also catches err_print/warn_print, which write to
# $Polymake::console, and polymake's own fatal error handler.
if (defined $errfile) {
  open(STDERR, '>', $errfile) or die "cannot redirect stderr to $errfile: $!\n";
  STDERR->autoflush;
}

# Must happen before load(), which consults Verbose::files.
if ($quiet) {
  $Polymake::User::Verbose::credits = 0;
  $Polymake::User::Verbose::files   = 0;
}

my $out  = shift(@ARGV);
my $file = shift(@ARGV);
my %r = (version => "$Polymake::Version", values => {}, errors => {});

if (defined($file) && $file ne '--version') {
  my $obj = eval { load($file) };
  if ($@) {
    $r{fatal} = "$@";
  } else {
    # Not Polymake::User::prefer_now: under --script $Polymake::User::application
    # is a stub whose preferences are unset. Mode::create rather than the usual
    # Mode::strict, so polymake does not consider its settings changed and
    # rewrite them when a config path is in use.
    $obj->type->application->prefs
        ->add_preference($_, Polymake::Core::Preference::Mode::create)
      for @prefer;

    for my $kw (@ARGV) {
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
