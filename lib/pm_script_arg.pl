# This is a compatibility hack for polymake 4.1
# See https://polymake.org/doku.php/user_guide/tutorials/release/4.1/legacy

my $file = shift(@ARGV);

sub give_from {
  my ($c, $arg) = @_;
  if ($arg =~ /-$/) {
    warn "Escaping error. Argument $arg ist probably not intended.";
  }
  $arg =~ s/->/./g;

  return $c->give($arg);
}

my $c=load($file);
my @rtn = ();
foreach my $arg (@ARGV) {
  my $given = give_from($c, $arg);
  push(@rtn, "$arg\n$given\n");
}
print join("\n", @rtn);

