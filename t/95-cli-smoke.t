use Test;

my $out = "/tmp/test.pdf";
# Smoke test: run the CLI with --no-kern
my $cmd = "raku -I. ./bin/make-gnu-ff-samples ofile=$out !kerning";

my $ok = shell($cmd).exitcode == 0 && $out.IO.f && $out.IO.s > 0;
ok $ok, 'CLI generated a PDF (smoke test)';

done-testing;
