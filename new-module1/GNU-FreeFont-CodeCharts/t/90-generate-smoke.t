use v6.d;
use Test;

use lib 'lib';
use GNU::FreeFont::CodeCharts :generate-codecharts;

my $run-live = %*ENV<FF_CODECHARTS_RUN_LIVE> // '';

if !$run-live {
    plan 1;
    skip 'Live PDF generation test skipped (set FF_CODECHARTS_RUN_LIVE=1 to enable)', 1;
    done-testing;
    exit;
}

plan 1;

my Str $font-file = %*ENV<FF_CODECHARTS_FONT> // 'FreeSerif.otf';

lives-ok {
    generate-codecharts(
        output    => 'test-codecharts.pdf',
        page-size => 'Letter',
        font-file => $font-file,
    );
}, 'generate-codecharts lives and produces a PDF';

done-testing;
