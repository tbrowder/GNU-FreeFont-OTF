use OO::Monitors;

use Test;

my $debug = 0;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::FontPaths;
#use GNU::FreeFont-TTF::Subs;

my $ofil = "test9.pdf";

#if not $debug {
    lives-ok {
        print-font-sample $ofil, :$debug;
    }
#}
#else {
#    say "WARNING: This test MUST pass in order to publish";
#}

done-testing;
