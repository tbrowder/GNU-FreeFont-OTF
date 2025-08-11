use OO::Monitors;

unit module GNU::FreeFont-TTF::Subs;

use PDF::Lite;
use PDF::Content::Page :PageSizes;

use GNU::FreeFont-TTF;

sub print-font-sample(
    :$debug
) is export {

    my $ff = GNU::FreeFont-TTF.new;

    my $f = $ff.get-font: 1;

    my $fname = $f.font-name;
}
