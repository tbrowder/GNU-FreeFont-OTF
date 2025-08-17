use OO::Monitors;

use Test;

my $debug = 1;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

use GNU::FreeFont-OTF;
use GNU::FreeFont-OTF::FontPaths;

my ($fpath, $fpath2);
my ($font, $font2, $code);

my $ff = GNU::FreeFont-OTF.new;
isa-ok $ff, GNU::FreeFont-OTF, "good GNU::FreeFont object";

my %h = $ff.font-file-paths;
isa-ok %h, Hash, "good Hash of font paths";

my @k  = %h.keys.sort;
my $nk = @k.elems;
is $nk, 72, "must have $nk elements";
isa-ok %h{@k.head}, IO::Path, "valid path";

isa-ok $ff.font-file-paths{@k.head}.IO, IO::Path, "valid path";
$code = "t";
isa-ok $ff.font-file-paths{$code}.IO, IO::Path, "valid path";

$font = $ff.get-font: "t";
is $font.font-name, "FreeSerif", "FontObj knows its name";

my $file = $ff.get-font-path: "hob";
$font = load-font :$file;
isa-ok $font, PDF::Content::FontObj;

$font = $ff.get-font: 1;
isa-ok $font, PDF::Content::FontObj;

$code = "Free Serif";
$font = $ff.get-font: $code;
isa-ok $font, PDF::Content::FontObj;

done-testing;

=finish

# test the sharing of the same font
if not $debug {
    is $font, $font2;
}
else {
    say "WARNING: This test MUST pass in order to publish";
}


=finish

isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;

# test the sharing of the same font
if not $debug {
    is $font, $font2;
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

$font   = $ff.fonts<h>;
$font2  = $ff.fonts<se>;
isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;

# test the sharing of the same font
if not $debug {
    is $font, $font2;
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

$font  = $ff.fonts<c>;
$font2 = $ff.fonts<m>;
isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;

# test the sharing of the same font
if not $debug {
    is $font, $font2;
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

done-testing;
