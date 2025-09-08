#!/usr/bin/env raku
use v6.d;

use GNU::FreeFont-OTF::Subs; # :pdf-language-samples;
use GNU::FreeFont-OTF::Vars; # :pdf-language-samples;

sub MAIN(
    Str:D $outfile = 'freefont-samples.pdf',
    Int :$font = 1,         # 1=FreeSerif, 2=FreeSans, 3=FreeMono
    :$page-size = 'A4',
    Bool :$kern = True
) {
    pdf-language-samples($font, $outfile, :$page-size, :kerning($kern));
    say "Wrote $outfile";
}
