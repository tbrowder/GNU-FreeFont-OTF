unit module GNU::FreeFont-TTF::FontPaths;

use MacOS::NativeLib "*";

use QueryOS;

my $os = OS.new;

# The font directory for each system:

# Linux
# /usr/share/fonts/truetype/freefont/
my $Ld = "/usr/share/fonts/truetype/freefont";

# on MacOs, use another font for .ttf
my $Md = "/opt/homebrew/Caskroom/font-freefont/20120503/freefont-20120503";

# on Windows, use another font for ttf
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
    %fonts<se>   = %fonts<t>; # "FreeSerif";            # 1
    %fonts{1}    = %fonts<t>; # "FreeSerif";            # 1

    %fonts<seb>  = %fonts<tb>; # "FreeSerif-Bold";       # 2
    %fonts{2}    = %fonts<tb>; # "FreeSerif-Bold";       # 2

    %fonts<to>   = %fonts<ti>; # "FreeSerif-Italic";     # 3
    %fonts{3}    = %fonts<ti>; # "FreeSerif-Italic";     # 3
    %fonts<seo>  = %fonts<ti>; # "FreeSerif-Italic";
    %fonts<sei>  = %fonts<ti>; # "FreeSerif-Italic";

    %fonts<tbo>  = %fonts<tbi>; #"FreeSerif-BoldItalic"; # 4
    %fonts{4}    = %fonts<tbi>; #"FreeSerif-BoldItalic"; # 4
    %fonts<tob>  = %fonts<tbi>; #"FreeSerif-BoldItalic";
    %fonts<tib>  = %fonts<tbi>; #"FreeSerif-BoldItalic";
    %fonts<sebi> = %fonts<tbi>; #"FreeSerif-BoldItalic";
    %fonts<sebo> = %fonts<tbi>; #"FreeSerif-BoldItalic"%fonts<>; #;
    %fonts<seob> = %fonts<tbi>; #"FreeSerif-BoldItalic";
    %fonts<seib> = %fonts<tbi>; #"FreeSerif-BoldItalic";

    # Helvetica/FreeSans
    %fonts<sa>   = %fonts<h>; #"FreeSans";             # 5
    %fonts{5}    = %fonts<h>; #"FreeSans";             # 5

    %fonts<sab>  = %fonts<hb>; #"FreeSans-Bold";        # 6
    %fonts{6}    = %fonts<hb>; #"FreeSans-Bold";        # 6

    %fonts<hi>   = %fonts<ho>; #"FreeSans-Oblique";     # 7
    %fonts{7}    = %fonts<ho>; #"FreeSans-Oblique";     # 7
    %fonts<sai>  = %fonts<ho>; #"FreeSans-Oblique";
    %fonts<sao>  = %fonts<ho>; #"FreeSans-Oblique";

    %fonts<hbi>  = %fonts<hbo>; #"FreeSans-BoldOblique"; # 8
    %fonts{8}    = %fonts<hbo>; #"FreeSans-BoldOblique"; # 8
    %fonts<hob>  = %fonts<hbo>; #"FreeSans-BoldOblique";
    %fonts<hib>  = %fonts<hbo>; #"FreeSans-BoldOblique";
    %fonts<sabi> = %fonts<hbo>; #"FreeSans-BoldOblique";
    %fonts<sabo> = %fonts<hbo>; #"FreeSans-BoldOblique";
    %fonts<saob> = %fonts<hbo>; #"FreeSans-BoldOblique";
    %fonts<saib> = %fonts<hbo>; #"FreeSans-BoldOblique";

    # Courier/FreeMono
    %fonts<m>   = %fonts<c>; #"FreeMono";              # 9
    %fonts{9}   = %fonts<c>; #"FreeMono";              # 9

    %fonts<mb>  = %fonts<cb>; #"FreeMono-Bold";         # 10
    %fonts{10}  = %fonts<cb>; #"FreeMono-Bold";         # 10

    %fonts<ci>  = %fonts<co>; #"FreeMono-Oblique";      # 11
    %fonts{11}  = %fonts<co>; #"FreeMono-Oblique";      # 11
    %fonts<mo>  = %fonts<co>; #"FreeMono-Oblique";
    %fonts<mi>  = %fonts<co>; #"FreeMono-Oblique";

    %fonts<cbi> = %fonts<cbo>; #"FreeMono-BoldOblique";  # 12
    %fonts{12}  = %fonts<cbo>; #"FreeMono-BoldOblique";  # 12
    %fonts<cob> = %fonts<cbo>; #"FreeMono-BoldOblique";
    %fonts<cib> = %fonts<cbo>; #"FreeMono-BoldOblique";
    %fonts<mbi> = %fonts<cbo>; #"FreeMono-BoldOblique";
    %fonts<mib> = %fonts<cbo>; #"FreeMono-BoldOblique";
    %fonts<mob> = %fonts<cbo>; #"FreeMono-BoldOblique";
    %fonts<mbo> = %fonts<cbo>; #"FreeMono-BoldOblique";

    # now add the actual names to the hash
    # These are the fonts from GNU FreeFont
    #   with their primary codes (from their Adobe heritage)
    %fonts<FreeSerif>            = %fonts<t>;                              # 1
    %fonts<FreeSerif-Bold>       = %fonts<tb>;                             # 2
    %fonts<FreeSerif-Italic>     = %fonts<ti>;  # also to                  # 3
    %fonts<FreeSerif-BoldItalic> = %fonts<tb>;  # also tbo, tob, tib       # 4
    %fonts<FreeSans>             = %fonts<h>;                              # 5
    %fonts<FreeSans-Bold>        = %fonts<hb>;                             # 6
    %fonts<FreeSans-Oblique>     = %fonts<ho>;  # also hi                  # 7
    %fonts<FreeSans-BoldOblique> = %fonts<hbo>; # also hbi, hob, hib       # 8
    %fonts<FreeMono>             = %fonts<c>;                              # 9
    %fonts<FreeMono-Bold>        = %fonts<cb>;                             # 10
    %fonts<FreeMono-Oblique>     = %fonts<co>;  # also ci                  # 11
    %fonts<FreeMono-BoldOblique> = %fonts<cbo>; # also cbi, cob, cib       # 12


    # the final hassh:
    %fonts; # hash of font file paths
}


