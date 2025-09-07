use v6;
use Test;

# This test runs the repo's sample generator script and asserts that it
# produces a non-trivial PDF. It avoids hard-coding fonts or system paths
# and works on CI (Linux/macOS/Windows).
#
# Layout assumptions:
#   repo-root/
#     pdf-freefont-samples.raku
#     lib/
#     t/9-font-samples.t  <-- this file
#
# If the script moves, update $script accordingly.

my $repo-root = $*PROGRAM.parent.parent;          # t/..  -> repo root
my $script    = $repo-root.add('pdf-freefont-samples.raku');
my $libdir    = $repo-root.add('lib');            # ensure module is visible

if !$script.e {
    plan 1;
    skip "Sample generator not found at {$script}";
    done-testing;
    exit;
}

plan 4;

ok $script.e, "Found sample generator: {$script}";

# Put outputs in a temp subtree to avoid polluting the repo and to play nice with CI
my $tmpdir = $*TMPDIR.add('gnu-freefont-otf-tests');
$tmpdir.mkdir unless $tmpdir.d;

my $outfile = $tmpdir.add('freefont-samples.pdf');
try {
    $outfile.unlink if $outfile.e;
    CATCH { }
}

# Build the command:
# - Use the current Raku executable
# - Add repo lib/ so 'use GNU::FreeFont-OTF' resolves locally in CI
# - Run from $tmpdir so the script writes output here (it writes a predictable filename)
my @cmd = $*EXECUTABLE, '-I', $libdir.Str, $script.Str;

diag "Running: {@cmd.join(' ')}";

# Run the script with controlled cwd; capture exit code
my $proc = run |@cmd, :cwd($tmpdir);
ok $proc.exitcode == 0, "Generator exited with code 0";

# The generator writes 'freefont-samples.pdf' in the working directory.
ok $outfile.e, "Output PDF exists at: {$outfile}";

# Sanity check size so we know it's not an empty or tiny file
my $min-size = 10_000;  # bytes; adjust if you later shrink the sample
ok $outfile.s > $min-size, "Output PDF is non-trivial (> {$min-size} bytes); actual: {$outfile.s}";

done-testing;

=finish

use OO::Monitors;

use Test;

my $debug = 0;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

use GNU::FreeFont-OTF;
use GNU::FreeFont-OTF::FontPaths;
use GNU::FreeFont-OTF::Subs;

my $ofil = "test9.pdf";

if not $debug {
    lives-ok {
        print-font-samples.raku $ofil, :$debug;
    }
}
else {
    say "WARNING: This test MUST pass in order to publish";
}

done-testing;
