unit module GNU::FreeFont-OTF::Subs;

use PDF::Lite;
use PDF::Font::Loader :load-font;
use PDF::Content::Page :PageSizes;   # A4, Letter available
use PDF::Content::Color :rgb;

use GNU::FreeFont-OTF::Vars;
use GNU::FreeFont-OTF::FontPaths;

our $default-font-size is export = 11;
sub help() is export {
print q:to/HERE/;
   Writes a portrait PDF showing all language samples using a selected GNU FreeFont
     face and size.

   $font-ref may be:
     * Int: A reference number from the code tables (1..12)
     * Str: a code from the code tables
     * Str: a family name (e.g., "Free Sans")
     * Str: a path to an .otf (or .ttf) file

   With the 'print' input the default output PDF file will be:
       GNU-FreeFont-OTF-samples.pdf
   Otherwise you may choose another path by entering it as:
       ofile=/path/to/file

   Options:
     * :page-size<Letter|A4> (default: Letter)
     * :kerning<True|False>  (default: True)
     * :font-size(Int > 0)   (default: $default-font-size)
     * :lang(Lang code)      (default: False)

   Renders pages in the given portrait size with ~0.75in margins and adds
     "n of m" page numbers bottom-right.

   Returns the created file path as IO::Path.
HERE
} # end of sub help

sub resolve-font-ref(
    $font-ref is copy,
    :$debug,
    --> IO::Path
) is export {

    my %fonts = get-font-file-paths-hash;
    unless %fonts.defined {
        die "Could not find font hash '%fonts'. Is it installed?";
    }

    # convert inputs to valid font refs
    my $font-path = "";
    my $fr = $font-ref;

    # any hyphens or spaces or both?
    my $sep;
    my ($has-hyphens, $has-spaces) = 0, 0;
    if $fr ~~ / '-' / {
        ++$has-hyphens;
        $sep = '-';
        $fr ~~ s:g/'-'+/-/; # rm  xtra hyphens
    }
    if $fr ~~ / \h / {
        ++$has-spaces;
        $sep = ' ';
        $fr ~~ s:g/\h+//; # rm spaces
    }
    if $has-hyphens and $has-spaces {
        # remove the spaces
        $fr ~~ s:g/\h+//; # rm all spaces
        $sep = '-';
    }

    # sanity check
    unless $fr.defined and ($fr ~~ /\S/) {
        die "FATAL: \$fr is not usable";
    }

    if $has-hyphens {
        # assume it's mostly correct except ensure pieces are capitalized properly
        my @parts = $fr.split($sep);
        unless @parts.elems == 2 { die "unknown font alias '$fr'"; }
        $fr = "";
        for @parts.kv -> $i, $p is copy {
            $p .= tc;
            if $i {
                $fr ~= $p ~ '-';
            }
            else {
                $fr ~= $p;
            }
        }
    }

    # sanity check
    unless $fr.defined and ($fr ~~ /\S/) {
        die "FATAL: \$fr is not usable";
    }

    $font-ref = $fr;

    if $debug {
        say "DEBUG: calculated \$fr: $fr";
    }

    with $font-ref {
        my $r = $_;
        when $r ~~ 1..12 {
            $font-path = %fonts{$r};
        }
        default {
            $font-path = %fonts{$r};
        }
    }

    unless $font-path.defined and $font-path.IO.r {
        die qq:to/HERE/;
        FATAL: Could not find a GNU FreeFont file
        with font reference '$font-ref'.
        Is your desired font installed?

        If so, please file an issue describing:
            + the exact font reference you used
            + the font you expected to find
            + the font path on your server
            + your operating system and version
        HERE
    }

    $font-path;

} # end of sub resolve-font-ref

# some default settings for the rest of the module
# removed from its original place
# put in Vars later
# A bold core-font for headings (portable even if GNU FreeFont is missing)
#   face only
my $head-core = PDF::Lite.new.core-font(:family<Helvetica>, :weight<bold>);
my $head-sub  = PDF::Lite.new.core-font(:family<Helvetica>); # default: regular
# Note: font-size is only for the body text
# other sizes may need to be modified after seeing real output:
my $head-core-size = 16;

sub do-pdf-language-samples(
    $font-ref is copy,
    :$ofile is copy,
    # default options if NOT explicitly entered
    :$font-size = $default-font-size,
    :$page-size = 'Letter',
    :$kerning   = True,
    :$lang      = False, # or one lang code
    :$all       = False, # show all features
    :$debug,
    --> IO::Path
    ) is export {

    # unless the output file is defined, make it reflect the other input values
    unless $ofile.defined and $ofile ~~ /\S/ {
        # start with this and modify as needed:
        my $base = "GNU-FreeFont-OTF";

        my $n1 = $page-size.contains("a4", :i) ?? "A4" !! "";
        my $n2 = $kerning ?? "kern" !! "nokern";
        my $n3 = $lang ?? $lang !! "";
        my $n4 = $all  ?? "all" !! "";
        $ofile = "$base-$n1-$n2-$n3-$n4";
        # remove duplicate hyphens
        $ofile ~~ s:g/'-'+/-/;
        # remove any ending hyphen
        $ofile ~~ s:g/'-'+ $//;
        # a standard ending:
        $ofile ~= "-samples.pdf";
    }

    unless $font-ref.defined and ($font-ref ~~ /\S/) {
        $font-ref = "Free Serif";
        # but that restricts the output choices
        if $all or $lang {
            say "NOTE: You have selected a font ($font-ref) by default.";
            say "      Please file an issue if this was not intended.";
        }
    }

    my $font-path = resolve-font-ref $font-ref;

=begin comment
    # moved up and out of this block
    # Note: font-size is only for the body text
    # other sizes may need to be modified after seeing real output:
    my $head-core-size = 16;
=end comment

    my $loaded-font = try { load-font :file($font-path) } //
            die "Could not find GNU FreeFont file ‘$font-path’. Is it installed?";

    # the default page name is derived from the font file name
    my $face-title = $font-path.IO.basename;
    if $face-title ~~ /'.'/ {
        $face-title ~~ s/'.' .* $//;
    }

    if $debug {
        say "DEBUG: input font ref: $font-ref";
    }

=begin comment
    # moved up and out of this block
    # A bold core-font for headings (portable even if GNU FreeFont is missing)
    #   face only
    my $head-core = PDF::Lite.new.core-font(:family<Helvetica>, :weight<bold>);
    my $head-sub  = PDF::Lite.new.core-font(:family<Helvetica>); # default: regular
=end comment

    # --- Make a new PDF (portrait page-size) ---
    my PDF::Lite $pdf .= new;
    my $size = $page-size.lc eq 'letter' ?? Letter !! A4;
    $pdf.media-box = $size;  # chosen size
    my PDF::Lite::Page $page = $pdf.add-page;
    my @pages = $pdf.pages;  # capture page list

    # --- Page metrics ---
    my Numeric $margin = 54;                 # 0.75in
    my Numeric $x      = $margin;
    my Numeric $y      = $page.media-box[3] - $margin; # top margin from page height
    my Numeric $col-w  = $page.media-box[2] - 2*$margin;
    my Numeric $rmx    = $page.media-box[2] - $margin;
    my Numeric $ctrx   = $x + 0.5 * $col-w;

    # --- Page Title ---
    my ($ptitle, $ptitle2);
    $page.text: -> $txt {
        $txt.font = $head-core, $head-core-size; # 16;
        $txt.text-position = $ctrx, $y;
        $ptitle  = "GNU FreeFont – Language Samples — {$face-title}";
        if $kerning {
            $ptitle2 = "(Font size $font-size, with kerning)";
        }
        else {
            $ptitle2 = "(Font size $font-size, no kerning)";
        }
        $txt.print: $ptitle, :align<center>;

        $y -= 18;   # add some vertical space after the title
        $txt.text-position = $ctrx, $y;
        $txt.font = $head-sub, $head-core-size - 2; # 16;
        $txt.say:   $ptitle2, :align<center>;
    }
    $y -= 26;   # add some vertical space after the title block

#=begin comment
    # Helper to start a fresh page when we run out of space
    # TODO if possible, make it an independent sub at the module top level
    # the replacement is named: do-new-page
    sub new-page(
        # :$pdf!,
        # :$margin!,     # all edge margins are the same for now
        # :$face-title!,
        # :$font-size!,
        :$debug,
        # --> List # ($page, $y)
    ) {
        $page = $pdf.add-page;
        # refresh pages is done by the caller
#       @pages = $pdf.pages;  # refresh list
        my $x  = $margin;
        my $cx = $page.media-box[2] / 2;
        $y     = $page.media-box[3] - $margin;
        # repeat running head (optional)
        $page.text: -> $t {
            $t.font = $head-core, $font-size;
            $t.text-position = $cx, $y;
            my $title = "GNU FreeFont — {$face-title}";
            $t.say: $title, :align<center>;
            if $debug {
                say "DEBUG (in sub new-page) title: $title, y = $y";
            }
        }
        $y -= 20;
    }
#=end comment

    # --- Body: each entry in %default-samples is a (language => text) pair ---
    my %samples := try %default-samples
        orelse die q:to/HERE/;
        FATAL: This routine expects %default-samples to be defined in
            GNU::FreeFont::Subs
        HERE

    my %names;
    for %samples.keys -> $iso-key {
        my $name = %samples{$iso-key}<lang>;
        %names{$name} = $iso-key;
    }

    my @nkeys = %names.keys.sort;
    # force a large number of samples for testing the new-page sub
    if $debug {
        my @t = @nkeys;
        my $max = @t.elems / 2;
        while @t {
            @nkeys.push: @t.pop;
            last if @t.elems > $max
        }
        @nkeys .= sort;
    }
    my $n = 2;

    # -- default one page with one pangram per language
    for @nkeys.kv -> $i, $name {
        my $k = %names{$name};
        say "DEBUG: showing pangram for \$k: $k, \$name: $name" 
            if $debug and $i < 2 * $n;
        # $k is the two-char ISO abbreviation of the language
        # $sample{$k}.text  is the text line

        my %h    = %samples{$k};
        my $lang = %h<lang>;
        my $text = %h<text>;
        say "DEBUG: \$lang: $lang" if 0 and $debug;
        say "DEBUG: \$text: $text" if 0 and $debug;
        # Header label for the language
        #   enough room?
        if $y < $margin + 60 { 
            # original sub used here
            if $debug < 2  {
                new-page(:$debug); 
            }

            #=begin comment
            else {
                note "DEBUG: attempting using the new sub do-new-page...";
                # new sub used here
                my ($arg1, $arg2) = do-new-page(
                    :$pdf,
                    :$margin,     # all edge margins are the same for now
                    :$face-title,
                    :$font-size,
                    :$debug,
                    ); 
                $page = $arg1;
                $y    = $arg2;
            }
            #=end comment


            # now refresh pages here
            @pages = $pdf.pages;
        }
        $page.text: -> $t {
            $t.font = $head-core, $font-size; # head-core-size2
            $t.text-position = $x, $y;
            $t.print: "$lang", :align<left>;

            $t.font = $head-sub, $font-size; # head-core-size2
            #$t.text-position = $rmx - 36, $y;
            #$t.say:   "ISO ID: {$k.uc}", :align<left>;
            $t.say:   " ({$k.uc})"; # , :align<left>;
        }
        $y -= 16;

        # The sample text set in the chosen font (wrap within the
        # content width)
        my @box;
        $page.text: -> $t {
            $t.font = $loaded-font, $font-size; # sample-text-size
            $t.text-position = $x, $y;
            @box = $t.say: $text, :width($col-w), :align<left>, :kern($kerning);
        }
        # Move below the block with a little breathing room.
        my $block-h = @box[3] - @box[1];       # y1 - y0
        $y -= $block-h + 12;
    }

    # --- Footers: add "n of m" and a generator mark on every page ---
    my $total = @pages.elems;
    my $w = $page.media-box[2];
    my $h = $page.media-box[3];
    my $right-x = $w - $margin;                 # right margin x
    for @pages.kv -> $i, $pg {
        my $num = $i + 1;
        $pg.text: -> $t {
            $t.font = $pdf.core-font(:family<Helvetica>), 9; # page-number-size
            # Left footer mark
            $t.text-position = $margin, $margin - 10;
            $t.say: "Generated by GNU::FreeFont-OTF";
            # Right-aligned page number
            $t.text-position = $right-x, $margin - 10;
            $t.say: "Page {$num} of {$total}", :align<right>;
        }
    }

    # --- Write the file ---
    $pdf.save-as: $ofile;
    return $ofile.IO;

} # end sub do-*

sub put-page-title(
    $line1,   # center it
    $line2,   # center it
    :$lx!,    # xrefs to the active page space
    :$rx!,    # xrefs to the active page space
    :$ty!,    # yrefs to the active page space
    :$by!,    # yrefs to the active page space
    :$page!,  # a valid PDF page
) is export {
} # end of sub put-page-title

sub put-text-sample(
    $title,   # align left
    $text,    # align left
    :$lx!,    # xrefs to the active page space
    :$rx!,    # xrefs to the active page space
    :$ty!,    # yrefs to the active page space
    :$by!,    # yrefs to the active page space
    :$page!,  # a valid PDF page
) is export {
    my $w = $page.media-box[2];
    my $h = $page.media-box[3];
} # end of sub put-text-sample

sub do-new-page(
    :$pdf!,
    :$margin!,     # all edge margins are the same for now
    :$face-title!,
    :$font-size!,
    :$debug,
    --> List # ($page, $y)
) is export {
    my $page = $pdf.add-page;
    # refresh pages is to be done by the caller
    # @pages = $pdf.pages;  # refresh list
    my $x  = $margin;
    my $cx = $page.media-box[2] / 2;
    my $y  = $page.media-box[3] - $margin;
    # repeat running head (optional)
    $page.text: -> $t {
        $t.font = $head-core, $font-size;
        $t.text-position = $cx, $y;
        my $title = "GNU FreeFont — {$face-title}";
        $t.say: $title, :align<center>;
        if $debug {
            say "DEBUG (in sub new-page) title: $title, y = $y";
        }
    }
    $y -= 20;

    $page, $y;
} # end of sub do-new-page

