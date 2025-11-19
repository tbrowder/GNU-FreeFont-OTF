use v6;
use Test;

# Walk up from CWD until we find repo root
sub find-up(
    Str $start, 
    :$name!, 
    :$also = [],
) {
    my $dir = $start.IO;
    loop {
        my $hit = ($dir.add($name), |$also.map({ $dir.add($_) })).first(*.e);
        return $hit if $hit.defined;

        my $parent = $dir.dirname.IO;
        last if $parent.Str eq $dir.Str; # stop at FS root
        $dir = $parent;
    }
    Nil
}

plan 4;

my $script-name = 'pdf-freefont-samples.raku';
my $script = find-up(
    $*CWD.Str,
    :name($script-name),
    :also(["bin/$script-name", 'META6.json'])
);

if $script.defined && $script.basename eq 'META6.json' {
    my $root = $script.dirname.IO;
    my $direct = $root.add($script-name);
    my $bin    = $root.add("bin/$script-name");
    $script = $direct.e ?? $direct
            !! $bin.e    ?? $bin
            !! Nil;
}

ok $script.defined, "Located repository anchor for $script-name";
if !$script.defined {
    skip "Could not find $script-name starting from CWD={$*CWD}", 3;
    done-testing;
    exit;
}

ok $script.e, "Found generator script at: {$script}";

# Temp workspace so we don't clutter repo
my $tmpdir = $*TMPDIR.add('gnu-freefont-otf-tests');
$tmpdir.mkdir unless $tmpdir.d;

my $outfile = $tmpdir.add('freefont-samples.pdf');
try { $outfile.unlink if $outfile.e; CATCH { } }

my $root   = $script.dirname.IO;
my $libdir = $root.add('lib');

diag "Running in {$tmpdir} with lib={$libdir}";

my @cmd = $*EXECUTABLE, '-I', $libdir.Str, $script.Str;
my $proc = run |@cmd, :cwd($tmpdir);
ok $proc.exitcode == 0, "Generator exited with code 0";

ok $outfile.e, "Output PDF exists at: {$outfile}";

my $min-size = 10_000; # bytes
ok $outfile.s > $min-size, "Output PDF size {$outfile.s} > {$min-size}";

done-testing;
