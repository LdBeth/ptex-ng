#!/usr/bin/env perl
# $Id: nested-range-test.pl 76374 2025-09-21 21:26:28Z karl $
# Public domain.  Originally written 2011, Karl Berry.
# Check that makeindex doesn't create spurious output from nested ranges.
# See nested-range.tex and -bb.tex.

# srcdir = makeindexk (in the source tree)
BEGIN { chomp ($srcdir = $ENV{"srcdir"} || `cd \`dirname $0\`/.. && pwd`); }
require "$srcdir/../tests/common-test.pl";

exit (&main ());

sub main {
  my @test_args = ("./makeindex", "$srcdir/tests/nested-range.idx",
                       "-o", "nested-range.ind",
                       "-t", "nested-range.ilg");
  my $ret = &test_run (@test_args);
  if ($ret != 0) {
    warn "test_run failed ($ret): $! (cmd=@test_args)\n";
    die `pwd; ls -lt`;
  }
  
  my $bad = 0;
  local *IND;
  $IND = "nested-range.ind";
  
  # Seems that unpredictably the output file doesn't exist yet?
  if (! -e $IND) {
    warn `pwd; ls -lt`;
    sleep 1;
  }
  
  # The test fails if the output contains \(.
  open (IND) || die "open($IND) failed: $!";
  while (<IND>) {
    $bad = 1 if /\\\(/;
  }
  close (IND) || die "close($IND) failed: $!";
  
  return $bad;
}
