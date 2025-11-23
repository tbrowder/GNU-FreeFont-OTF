use Test;

use GNU::FreeFont-OTF;
use GNU::FreeFont-OTF::Subs;

plan 3;

my $ofil = "GNU-FreeFont-OTF-samples.pdf";

# Temp workspace so we don't clutter repo
my $tdnam = "gnu-ff";
my $tmpdir = "$*TMPDIR/$tdnam";

mkdir $tmpdir unless $tmpdir.IO.d;

my $outfile = "$tmpdir/$ofil";

try { $outfile.IO.unlink if $outfile.IO.e; CATCH { } }

lives-ok {

    my $font-ref = "Free Serif";
    do-pdf-language-samples $font-ref, :ofile($outfile);

    is $outfile.IO.r, True, "outfile $outfile exists";

}, "test the routine...";
 
my $min-size = 10_000; # bytes
ok $outfile.IO.s > $min-size, "Output PDF size {$outfile.IO.s} > {$min-size}";

