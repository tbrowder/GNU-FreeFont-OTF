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

my ($font-path, $font-path2, $font-path3, $font-path4);
my ($font, $font2, $font3, $font4);
$font-path  = %fonts<t>;
$font-path2 = %fonts<sa>;
$font-path3 = %fonts<1>;
$font-path4 = %fonts{1};
isa-ok $font-path, IO::Path;
isa-ok $font-path2, IO::Path;
isa-ok $font-path3, IO::Path;
isa-ok $font-path4, IO::Path;

# use the valid paths to get a loaded font
$font  = PDF::Font::Loader.load-font: :file($font-path);
$font2 = PDF::Font::Loader.load-font: :file($font-path2);
$font3 = PDF::Font::Loader.load-font: :file($font-path3);
$font4 = PDF::Font::Loader.load-font: :file($font-path4);

isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;
isa-ok $font3, PDF::Content::FontObj;
isa-ok $font4, PDF::Content::FontObj;

say "DEBUG: got valid font paths and loaded fonts";

done-testing;
