#!/usr/bin/env raku

use File::Find;

my (@f, @ttf);
my $dir = ".".IO;

if ".precomp".IO.d {
    shell "rm -rf .precomp";
}
if "lib/.precomp".IO.d {
    shell "rm -rf lib/.precomp";
}

my @f = find :$dir, :type<file>, :exclude(".git");
say "Files:";
say "  $_" for @f;


