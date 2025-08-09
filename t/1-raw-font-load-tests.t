use OO::Monitors;

use Test;

my $debug = 1;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
#use PDF::Lite;

# testing the file path getter:
use GNU::FreeFont-OTF::FPaths;
my %fpaths = get-font-file-paths-hash;

my ($fpath, $fpath2);
my ($font, $font2);
$fpath  = %fpaths<t>;
$fpath2 = %fpaths<sa>;
isa-ok $fpath, IO::Path;
isa-ok $fpath2, IO::Path;

# use the valid paths to get a loaded font
$font  = PDF::Font::Loader.load-font: :file($fpath);
$font2 = PDF::Font::Loader.load-font: :file($fpath2);
isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;

say "DEBUG: got valid font paths and loaded fonts";

done-testing;
