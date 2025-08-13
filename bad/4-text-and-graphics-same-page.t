# from David Warring, 2024-09-21
# modified by @tbrowder

my $debug = 1;
my $ofil = "test4.pdf";

use Test;

use PDF::API6;
use PDF::Content::Color :rgb;
use PDF::Content::FontObj;
use PDF::Lite;
use PDF::Font::Loader :load-font;;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::FontPaths;

my $ff = GNU::FreeFont-TTF.new;

my ($font, $font-size);

$font = $ff.get-font: "t"; 

my PDF::Lite $pdf .= new;
$pdf.media-box = [0, 0, 8.5*72, 11*72];
my PDF::Lite::Page $page = $pdf.add-page;

$page.graphics: {
#    my PDF::Content::FontObj $font = $pdf.core-font( :family<Helvetica> );
    #   my PDF::Lite::XObject $form = .xobject-form(:BBox[0, 0, 95, 25]);
    #   $form.graphics: {
    #       .FillColor = rgb(.8, .9, .9);
    #       .Rectangle: |$form<BBox>;
    #       .paint: :fill;

    .MoveTo: 300, 500;
    .LineTo: 500, 500;
    .CloseStroke;

    my $font-size = 20;
    #.font = $font;
    .font = $font, $font-size;

    #       .FillColor = rgb(1, .3, .3);  # reddish
    .print("Simple Form", :position[300, 600], :align<left>, :valign<top>);

    .print("Simple Form", :position[300, 500], :align<center>, :valign<center>);

    .MoveTo: 300, 300;
    .LineTo: 500, 300;
    .CloseStroke;

    #   }
    #   my PDF::Content::XObject $jpeg .= open: "t/images/jpeg.jpg";
    #   # sanity check of form vs image positioning
    #   my @p1 = .do($form, :position(10, 30), :width(80), :height(30), :valign<top>);

    #   my @p2 = .do($jpeg, :position(100, 30), :width(80), :height(30), :valign<top>);

    #   # This should form a grid
    #   .do($form, :position(10, 50), :width(80), :height(30), :valign<center>);
    #   .do($jpeg, :position(100, 50), :width(80), :height(30), :valign<center>);
    #   .do($form, :position(10, 70), :width(80), :height(30), :valign<bottom>);
    #   .do($jpeg, :position(100, 70), :width(80), :height(30), :valign<bottom>);
}

if $debug {
    $pdf.save-as: $ofil;
    say "DEBUG: See output pdf file: '$ofil'";
}

done-testing;
