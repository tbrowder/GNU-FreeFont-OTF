use Test;

my $script = './bin/make-gnu-ff-samples';

# See output: GNU-FreeFont-OTF-samples.pdf
my $ofil = "GNU-FreeFont-OTF-samples.pdf";

# Temp workspace so we don't clutter repo
my $tdnam = "gnu-ff";
my $tmpdir = "$*TMPDIR/$tdnam";

#my $root   = $*CWD; #script.IO.parent;
#my $libdir = $root.add('lib');
my $libdir = "./lib"; 

mkdir $tmpdir unless $tmpdir.IO.d;

my $outfile = "$tmpdir/$ofil";
#my $ls-alt-handle = open $outfile, :w;

try { $outfile.unlink if $outfile.IO.e; CATCH { } }

lives-ok {

    my $file will leave { .close } = open $outfile, :w;
    my @cmd = '-I', "./$libdir", $script, "ofile=$outfile"; # , :out($outfile);
    my $proc = run |@cmd, :out($outfile); #, :cwd($tmpdir);
    my $res = $proc.exitcode; # == 0, "Generator exited with code 0";
    say "exitcode = $res";
    
    my $content = $outfile.IO.slurp;

}, "run the binary...";
 
done-testing;

=finish
begin comment
#   diag "Running in {$tmpdir} with lib={$libdir}";
#my @cmd = '-I', $libdir.Str, $script.Str, "ofile=$outfile";

my @cmd = '-I', "./$libdir", $script, "ofile=$outfile";
#my @cmd = $script, "ofile=$outfile";
my $proc = run |@cmd; #, :cwd($tmpdir);

#   is $outfile, "/tmp/gnu-ff/GNU-FreeFont-OTF-samples.pdf";
#   ok $proc.exitcode == 0, "Generator exited with code 0";
#   ok $outfile.IO.e, "Output PDF exists at: {$outfile}";

}, "run the binary...";



=finish

my $min-size = 10_000; # bytes
#ok $outfile.size > $min-size, "Output PDF size {$outfile.s} > {$min-size}";


done-testing;
