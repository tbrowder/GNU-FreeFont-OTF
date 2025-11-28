#!/usr/bin/env raku

use lib 'lib';

use GNU::FreeFont-OTF::Vars; # :pdf-language-samples;
my $lang-list = "";
for %default-samples.keys.sort -> $k {
    my $lang = %default-samples{$k}<lang>;
    say "=item $k - $lang";
    $lang-list ~= "$k - $lang\n";
}
say "lang-list:";
print $lang-list;
