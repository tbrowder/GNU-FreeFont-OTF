use OO::Monitors;

use Test;

my $debug = 0;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

use GNU::FreeFont-OTF;
use GNU::FreeFont-OTF::FontPaths;
#use GNU::FreeFont-OTF::Subs;

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
