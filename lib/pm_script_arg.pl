# This is a compatibility hack for polymake 4.1
# See https://polymake.org/doku.php/user_guide/tutorials/release/4.1/legacy
# Copyright Joachim Zobel <jz-2017@heute-morgen.de>.
# Licensed under the same license as GAP polymaking.

my $file = shift(@ARGV);

my $rtn = 0;
$rtn = 1 if $#ARGV > 1;

sub give_from {
  my ($c, $arg) = @_;
  no strict 'refs';
  return $c->$arg;
}

my $c=load($file);
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

