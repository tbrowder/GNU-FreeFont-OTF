use Test;

use PDF::Lite;
use PDF::Content::Page;

use GNU::FreeFont-OTF;
use GNU::FreeFont-OTF::FontList;
use GNU::FreeFont-OTF::Classes;
use GNU::FreeFont-OTF::Subs;

my $debug = 1;

if not $debug {
    lives-ok {
        print-font-sample :$debug;
    }
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

done-testing;
