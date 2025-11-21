use v6.d;
use Test;

use lib 'lib';
use GNU::FreeFont::CodeCharts :layout;

class DummyBlock {
    has Str $.script;
    has Str $.name;
    has Int $.start-int;
    has Int $.end-int;
    has Str $.start-hex;
    has Str $.end-hex;
    has Str $.url;

    has Int $.start-page is rw;
    has Int $.pages      is rw;
}

sub make-block(
    Str $script,
    Str $name,
    Int $start,
    Int $end
) {
    my Str $start-hex = $start.fmt('%04X');
    my Str $end-hex   = $end.fmt('%04X');

    return DummyBlock.new(
        :$script,
        :$name,
        start-int => $start,
        end-int   => $end,
        :$start-hex,
        :$end-hex,
        url       => 'https://example.invalid/',
    );
}

plan 5;

my @blocks;
@blocks.push: make-block('Latin', 'Block-1', 0x0000, 0x007F); # 128 chars
@blocks.push: make-block('Latin', 'Block-2', 0x0080, 0x00FF); # 128 chars

# With 128 cells per page, each block fits on exactly one page
my %layout = compute-layout(
    @blocks,
    40,   # TOC lines per page
    128,  # cells per page
    1,    # cover pages
);

is %layout<toc-pages>, 1, 'one TOC page for two blocks';

my Int $first-content = %layout<first-content-page>;
is $first-content, 1 + 1 + 1, 'first content page is cover + TOC + 1';

is @blocks[0].start-page, $first-content,
    'first block starts on first content page';
is @blocks[1].start-page, $first-content + 1,
    'second block starts on next page';

my Int $total-pages = %layout<total-pages>;
is $total-pages, 1   # cover
                  + 1   # TOC
                  + 2,  # two block pages
    'total pages include cover, TOC and all block pages';

done-testing;
