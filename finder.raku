#!/usr/bin/env raku
use File::Find;
use Lines::Containing;

my $dir = ".";

my @f = find :$dir, :type<file>, :exclude('.git');
my @ttf;
for @f -> $f {
    next if $f ~~ /"finder.raku"/;
    if $f ~~ /:i (ttf) / {
        my $ttf = $f;
        @ttf.push: $ttf;
    }
}

say "Files names containing TTF:";
for @ttf -> $f {
    say "  $f"
}

# check file contents
@ttf = [];

for @f -> $f {
    next if $f ~~ /"finder.raku"/;
    my $add = 0;
    for $f.IO.lines -> $line is copy {
        if $line ~~ / ttf / {
            ++$add;
#           say $line;
        }
        elsif $line ~~ / TTF / {
            ++$add;
#           say $line;
        }
    }
    if $add {
        @ttf.push: $f;
    }
}

say "Files containing TTF:";
    say "  $_" for @ttf;
