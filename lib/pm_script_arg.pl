# This is a compatibility hack for polymake 4.1
# See https://polymake.org/doku.php/user_guide/tutorials/release/4.1/legacy
# Copyright Joachim Zobel <jz-2017@heute-morgen.de>.
# Licensed under the same license as GAP polymaking.

my ($errfile, $quiet, @prefer);
while (@ARGV && $ARGV[0] =~ /^--/) {
  my $opt = shift(@ARGV);
  last if $opt eq '--';
  if    ($opt eq '--stderr') { $errfile = shift(@ARGV) }
  elsif ($opt eq '--quiet')  { $quiet = 1 }
  elsif ($opt eq '--prefer') { push @prefer, shift(@ARGV) }
  else  { die "pm_script_arg.pl: unknown option $opt\n" }
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

my $file = shift(@ARGV);

my $rtn = 0;
$rtn = 1 if $#ARGV > 1;

sub give_from {
  my ($c, $arg) = @_;
  no strict 'refs';
  return $c->$arg;
}

my $c=load($file);

# Not Polymake::User::prefer_now: under --script $Polymake::User::application is
# a stub whose preferences are unset, so go through the object's own application.
# Mode::create rather than the usual Mode::strict, so that polymake does not
# consider its settings changed and rewrite them when a config path is in use.
$c->type->application->prefs->add_preference($_, Polymake::Core::Preference::Mode::create)
  for @prefer;
my @rtn = ();
foreach my $arg (@ARGV) {
  my @sargs = split(/\b\s+\b/, $arg);
  $rtn = 1 if $#sargs > 1;
  foreach my $sarg (@sargs) {
    my @ssargs = split('->', $sarg);
    my $given = $c;
    # We follow the arrows
    foreach my $ssarg (@ssargs) {
      $given = give_from($given, $ssarg);
    }
    # and return what the last one gave us
    push(@rtn, "$sarg\n$given\n");
  }
}
print join("\n", @rtn);

return $rtn;

