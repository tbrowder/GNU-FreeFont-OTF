use Test;

use PDF::Lite;
use PDF::Content::Page;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::FontPaths;
use GNU::FreeFont-TTF::Subs;

my $debug = 0;

my $ofil = "test5.pdf";

if not $debug {
    lives-ok {
        print-font-sample $ofil, :$debug;
    }
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

done-testing;
