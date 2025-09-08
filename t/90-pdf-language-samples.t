use v6.d;
use Test;


# Resolve repo root from this test file’s location, then the script path:
my $repo-root = $*PROGRAM.absolute.IO.dirname;      # …/repo/t -> …/repo
my $sample = $repo-root.IO.add("pdf-freefont-samples.raku").absolute;

ok $sample.IO.e, "Found pdf-freefont-samples.raku at $sample"
    or bail-out "Cannot locate pdf-freefont-samples.raku";

#=finish
plan 6;

# Ensure module compiles
use GNU::FreeFont-OTF::Subs; # :pdf-language-samples;
use GNU::FreeFont-OTF::Vars; # :pdf-language-samples;

ok &pdf-language-samples.defined, 'pdf-language-samples is exported';

# Try to locate a FreeFont face. If missing, skip the rest gracefully.
my @candidates = (
    '/usr/share/fonts/opentype/freefont/FreeSerif.otf',
    '/usr/share/fonts/opentype/freefont/FreeSans.otf',
    '/usr/share/fonts/opentype/freefont/FreeMono.otf',
    '/usr/local/share/fonts/freefont/FreeSerif.otf',
).grep(*.IO.f);

if !@candidates {
    skip-rest "GNU::FreeFont-OTF not installed on this CI host; skipping PDF generation test";
    exit;
}

my $font-path = @candidates[0];
my $outdir = 't/out'.IO; $outdir.mkdir unless $outdir.d;
my $outfile = $outdir.add('lang-samples-test.pdf').Str;

lives-ok {
    pdf-language-samples($font-path, $outfile)
}, 'generated PDF without exceptions';

ok $outfile.IO.f && $outfile.IO.s > 0, "output file exists and is non-empty";
lives-ok {
    pdf-language-samples($font-path, $outdir.add('lang-samples-test-nk.pdf').Str, :kerning(False))
}, 'generated PDF with kerning disabled';

# sanity: file extension
ok $outfile.ends-with('.pdf'), 'has .pdf extension';
