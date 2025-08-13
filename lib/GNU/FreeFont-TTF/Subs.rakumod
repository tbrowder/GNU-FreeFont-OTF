use OO::Monitors;

unit module GNU::FreeFont-TTF::Subs;

use PDF::Lite;
use PDF::Content::Page :PageSizes;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::FontPaths;

sub print-font-sample(
    $ofil = "test5.pdf",
    :$debug
) is export {

    my $ff = GNU::FreeFont-TTF.new;
    my $f = $ff.get-font: 1;
    my $fname = $f.font-name;
    my PDF::Lite $pdf .= new;
    my $page = $pdf.add-page;
    $page.graphics: {
    }
    $pdf.save-as: $ofil;
}
