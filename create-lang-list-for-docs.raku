#!/usr/bin/env raku

use lib 'lib';

use GNU::FreeFont-OTF::Vars; # :pdf-language-samples;

my @list;
for %default-samples.keys.sort -> $k {
    my $lang = %default-samples{$k}<lang>;
    say "=item $k - $lang";
}
