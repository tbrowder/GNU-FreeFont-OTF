use Test;

use PDF::Lite;
use PDF::Content::Page;

use GNU::FreeFont-TTF;
use GNU::FreeFont-TTF::FontPaths;
use GNU::FreeFont-TTF::Classes;
use GNU::FreeFont-TTF::Subs;

my $debug = 0;

if not $debug {
    lives-ok {
        print-font-sample :$debug;
    }
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

done-testing;
