unit module GNU::FreeFont-TTF::FPaths;

use MacOS::NativeLib "*";

use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;

use QueryOS;

my $os = OS.new;

# /usr/share/fonts/truetype/freefont/
my $Ld = "/usr/share/fonts/truetype/freefont";
my $Md = "/opt/homebrew/Caskroom/font-freefont/20120503/freefont-20120503";
my $Wd = "/usr/share/fonts/truetype/freefont";

sub get-font-file-paths-hash(:$debug --> Hash) is export {
    my $fontdir;
    if $os.is-linux {
        $fontdir = $Ld;
    }
    elsif $os.is-macos {
        $fontdir = $Md;
    }
    elsif $os.is-windows {
        $fontdir = $Wd;
    }
    else {
        die "FATAL: Unable to determine your operating system (OS)";
    }

    # from the GNU FreeFont collection
    # only TrueType fonts wanted

    # Use codes reflecting the Adobe parentage of its class PostScript fonts
    # I grew up with in the PS days:
    #
    # Times-Roman
    my $fft   = "$fontdir/FreeSerif.ttf".IO;
    my $fftb  = "$fontdir/FreeSerifBold.ttf".IO;
    my $ffti  = "$fontdir/FreeSerifItalic.ttf".IO;
    my $fftbi = "$fontdir/FreeSerifBoldItalic.ttf".IO;

    # Helvetica
    my $ffh   = "$fontdir/FreeSans.ttf".IO;
    my $ffhb  = "$fontdir/FreeSansBold.ttf".IO;
    my $ffho  = "$fontdir/FreeSansOblique.ttf".IO;
    my $ffhbo = "$fontdir/FreeSansBoldOblique.ttf".IO;

    # Courier
    my $ffc   = "$fontdir/FreeMono.ttf".IO;
    my $ffcb  = "$fontdir/FreeMonoBold.ttf".IO;
    my $ffco  = "$fontdir/FreeMonoOblique.ttf".IO;
    my $ffcbo = "$fontdir/FreeMonoBoldOblique.ttf".IO;

    my %fonts;
    # get paths, don't load

    # Times-Roman
    %fonts<t>   = $fft;   # deb 12, :subset;
    %fonts<tb>  = $fftb;  # deb 12, :subset;
    %fonts<ti>  = $ffti;  # deb 12, :subset;
    %fonts<tbi> = $fftbi; # deb 12, :subset;

    # Helvetica
    %fonts<h>   = $ffh;   # deb 12, :subset;
    %fonts<hb>  = $ffhb;  # deb 12, :subset;
    %fonts<ho>  = $ffho;  # deb 12, :subset;
    %fonts<hbo> = $ffhbo; # deb 12, :subset;

    # Courier
    %fonts<c>   = $ffc;   # deb 12, :subset;
    %fonts<cb>  = $ffcb;  # deb 12, :subset;
    %fonts<co>  = $ffco;  # deb 12, :subset;
    %fonts<cbo> = $ffcbo; # deb 12, :subset;

    # "aliases" for the real names
    %fonts<se>   = %fonts<t>;
    %fonts<seb>  = %fonts<tb>;
    %fonts<sei>  = %fonts<ti>;
    %fonts<sebi> = %fonts<tbi>;

    %fonts<sa>   = %fonts<h>;
    %fonts<sab>  = %fonts<hb>;
    %fonts<sao>  = %fonts<ho>;
    %fonts<sabo> = %fonts<hbo>;

    %fonts<m>    = %fonts<c>;
    %fonts<mb>   = %fonts<cb>;
    %fonts<mo>   = %fonts<co>;
    %fonts<mbo>  = %fonts<cbo>;

    # TODO: put ALL of the aliases here
    #       ...
# add some extra keys called "aliases" # Time-Roman/FreeSerif
%fonts<se>   = %fonts "FreeSerif";            # 1
%fonts{1}    = %fonts "FreeSerif";            # 1

%fonts<seb>  = %fonts "FreeSerif-Bold";       # 2
%fonts{2}    = %fonts "FreeSerif-Bold";       # 2

%fonts<to>   = %fonts "FreeSerif-Italic";     # 3
%fonts{3}    = %fonts "FreeSerif-Italic";     # 3
%fonts<seo>  = %fonts "FreeSerif-Italic";
%fonts<sei>  = %fonts "FreeSerif-Italic";

%fonts<tbo>  = "FreeSerif-BoldItalic"; # 4
%fonts{4}    = "FreeSerif-BoldItalic"; # 4
%fonts<tob>  = "FreeSerif-BoldItalic";
%fonts<tib>  = "FreeSerif-BoldItalic";
%fonts<sebi> = "FreeSerif-BoldItalic";
%fonts<sebo> = "FreeSerif-BoldItalic";
%fonts<seob> = "FreeSerif-BoldItalic";
%fonts<seib> = "FreeSerif-BoldItalic";

# Helvetica/FreeSans
%fonts<sa>   = "FreeSans";             # 5
%fonts{5}    = "FreeSans";             # 5

%fonts<sab>  = "FreeSans-Bold";        # 6
%fonts{6}    = "FreeSans-Bold";        # 6

%fonts<hi>   = "FreeSans-Oblique";     # 7
%fonts{7}    = "FreeSans-Oblique";     # 7
%fonts<sai>  = "FreeSans-Oblique";
%fonts<sao>  = "FreeSans-Oblique";

%fonts<hbi>  = "FreeSans-BoldOblique"; # 8
%fonts{8}    = "FreeSans-BoldOblique"; # 8
%fonts<hob>  = "FreeSans-BoldOblique";
%fonts<hib>  = "FreeSans-BoldOblique";
%fonts<sabi> = "FreeSans-BoldOblique";
%fonts<sabo> = "FreeSans-BoldOblique";
%fonts<saob> = "FreeSans-BoldOblique";
%fonts<saib> = "FreeSans-BoldOblique";

# Courier/FreeMono
%fonts<m>   = "FreeMono";              # 9
%fonts{9}   = "FreeMono";              # 9

%fonts<mb>  = "FreeMono-Bold";         # 10
%fonts{10}  = "FreeMono-Bold";         # 10

%fonts<ci>  = "FreeMono-Oblique";      # 11
%fonts{11}  = "FreeMono-Oblique";      # 11
%fonts<mo>  = "FreeMono-Oblique";
%fonts<mi>  = "FreeMono-Oblique";

%fonts<cbi> = "FreeMono-BoldOblique";  # 12
%fonts{12}  = "FreeMono-BoldOblique";  # 12
%fonts<cob> = "FreeMono-BoldOblique";
%fonts<cib> = "FreeMono-BoldOblique";
%fonts<mbi> = "FreeMono-BoldOblique";
%fonts<mib> = "FreeMono-BoldOblique";
%fonts<mob> = "FreeMono-BoldOblique";
%fonts<mbo> = "FreeMono-BoldOblique";

    # the final hassh:
    %fonts; # hash of font file paths
