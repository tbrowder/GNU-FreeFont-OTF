use v6.d;
use Test;
plan 1;

# Smoke test: run the CLI with --no-kern
my $out = 't/out/cli-smoke.pdf'.IO;
$out.parent.mkdir;

my $cmd = "raku -I bin/make-freefont-samples.raku --font-ref=1 --out={$out.Str} --no-kern";
my $ok = shell($cmd).exitcode == 0 && $out.f && $out.s > 0;
ok $ok, 'CLI generated a PDF (smoke test)';
