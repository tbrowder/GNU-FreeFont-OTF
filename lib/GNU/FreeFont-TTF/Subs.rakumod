unit module GNU::FreeFont-TTF::Subs;

use PDF::Lite;
use PDF::Content::Page :PageSizes;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::Classes;
use GNU::FreeFont-TTF::FontList;

sub print-font-sample(
    :$debug
) is export {

    my $ff = GNU::FreeFont-TTF.new;

    my $f = $ff.get-font: 1;
    my $fn = $f.name;

    say "DEBUG: Face name: $fn";
}
