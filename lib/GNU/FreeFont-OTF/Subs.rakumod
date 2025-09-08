use OO::Monitors;

unit module GNU::FreeFont-OTF::Subs;

use PDF::Lite;
use PDF::Content::Page :PageSizes;

use GNU::FreeFont-OTF;
use GNU::FreeFont-OTF::FontPaths;
use GNU::FreeFont-OTF::Vars;

sub print-font-sample(
    $ofil = "test5.pdf",
    :$fnum = 1,
    :$lang = "en",
    :$debug
) is export {

    my $ff = GNU::FreeFont-OTF.new;
    my $f = $ff.get-font: $fnum;
    my $fname = $f.font-name;
    my PDF::Lite $pdf .= new;
    my $page = $pdf.add-page;
    $page.graphics: {
    }
    $pdf.save-as: $ofil;
}
