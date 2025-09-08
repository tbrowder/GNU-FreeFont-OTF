use v6.d;
use Test;

plan 3;

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

lives-ok { pdf-language-samples($font-path, $outfile) }, 'generated PDF without exceptions';

ok $outfile.IO.f && $outfile.IO.s > 0, "output file exists and is non-empty";
lives-ok { pdf-language-samples($font-path, $outdir.add('lang-samples-test-nk.pdf').Str, :kerning(False)) }, 'generated PDF with kerning disabled';

# sanity: file extension
ok $outfile.ends-with('.pdf'), 'has .pdf extension';
