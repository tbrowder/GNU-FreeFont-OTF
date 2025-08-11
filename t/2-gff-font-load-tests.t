use OO::Monitors;

use Test;

my $debug = 1;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::FontList;
use GNU::FreeFont-TTF::FPaths;

my ($fpath, $fpath2);
my ($font, $font2);

my $ff = GNU::FreeFont-TTF.new;
isa-ok $ff, GNU::FreeFont-TTF, "good GNU::FreeFont object";

my %h = $ff.font-file-paths;
isa-ok %h, Hash, "good Hash of font paths";

my @k  = %h.keys.sort;
my $nk = @k.elems;
is $nk, 24, "must have $nk elements";
isa-ok %h{@k.head}, IO::Path, "valid path";

isa-ok $ff.font-file-paths{@k.head}, IO::Path, "valid path";

#done-testing;
#=finish

$font = $ff.get-font: "t";
isa-ok $font, PDF::Content::FontObj;

#$font = $ff.get-font: 1;

if 0 and $debug {
    say "File paths hash contents ($nk elements):";
    for @k -> $k {
        my $v = %h{$k};
        say "  key: ", $k;
        say "    value: ", $v;
    }
}

done-testing;

=finish

my %fpaths = get-font-file-paths-hash;
my ($fpath, $fpath2);
my ($font, $font2);
$fpath  = %fpaths<t>;
$fpath2 = %fpaths<sa>;
isa-ok $fpath, IO::Path;
isa-ok $fpath2, IO::Path;

$font  = PDF::Font::Loader.load-font: :file($fpath);
$font2 = PDF::Font::Loader.load-font: :file($fpath2);
isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;


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
