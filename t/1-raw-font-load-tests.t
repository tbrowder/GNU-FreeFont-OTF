use OO::Monitors;

use Test;

my $debug = 1;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

# testing the file path getter:
use GNU::FreeFont-OTF::FontPaths;
my %fonts = get-font-file-paths-hash;

my ($fpath, $fpath2, $fpath3, $fpath4);
my ($font, $font2, $font3, $font4);
$fpath  = %fonts<t>;
$fpath2 = %fonts<sa>;
$fpath3 = %fonts<1>;
$fpath4 = %fonts{1};
isa-ok $fpath, IO::Path;
isa-ok $fpath2, IO::Path;
isa-ok $fpath3, IO::Path;
isa-ok $fpath4, IO::Path;

# use the valid paths to get a loaded font
$font  = PDF::Font::Loader.load-font: :file($fpath);
$font2 = PDF::Font::Loader.load-font: :file($fpath2);
$font3 = PDF::Font::Loader.load-font: :file($fpath3);
$font4 = PDF::Font::Loader.load-font: :file($fpath4);

isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;
isa-ok $font3, PDF::Content::FontObj;
isa-ok $font4, PDF::Content::FontObj;

say "DEBUG: got valid font paths and loaded fonts";

done-testing;
