unit module GNU::FreeFont-OTF::Subs;

use GNU::FreeFont-OTF::Vars;
use GNU::FreeFont-OTF::FontPaths;

sub help() is export {
print q:to/HERE/;
   Writes a portrait PDF showing all language samples using a selected GNU FreeFont
     face and size.

   $font-ref may be:
     * Int: A reference number from the code tables (1..12)
     * Str: a code from the code tables
     * Str: a family name (e.g., "Free Sans") 
     * Str: a path to a .ttf/.otf file

   With the 'print' input the default output PDF file will be:
       GNU-FreeFont-OTF-samples.pdf
   Otherwise you may choose another path by entering it as:
       ofile=/path/to/file

   Options:
     * :page-size<Letter|A4> (default: Letter)
     * :kerning<True|False>  (default: True)
     * :font-size(Int > 0)   (default: 12)
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
        # assume its mostly correct except ensure pieces are capitalized properly
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

    if $font-path.defined {
        if $font-path.IO.r {
            $font-ref = $font-path;
        }
        else {
            die "Could not find GNU FreeFont file '$font-path'"; #family ‘$fam’. Is it installed?";
        }
    }

=begin comment
    my $loaded-font = try { load-font :file($font-path) } //
            die "Could not find GNU FreeFont file ‘$font-path’. Is it installed?";

    my $face-title = $font-path.IO.basename;
    if $face-title ~~ /'.'/ {
        $face-title ~~ s/'.' .* $//;
    }

    if $debug {
        say "DEBUG: input font ref: $font-ref";
    }

    # A bold core-font for headings (portable even if GNU FreeFont is missing)
    #   face only
    my $head-core = PDF::Lite.new.core-font(:family<Helvetica>, :weight<bold>);

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

    # --- Title ---
    $page.text: -> $txt {
        $txt.font = $head-core, $head-core-size; # 16;
        $txt.text-position = $x, $y;
        $txt.say: "GNU FreeFont – Language Samples — {$face-title}", :align<left>;
    }
    $y -= 26;   # space after the title

    # Helper to start a fresh page when we run out of space
    sub new-page() {
        $page = $pdf.add-page;
        @pages = $pdf.pages;  # refresh list
        $x    = $margin;
        $y    = $page.media-box[3] - $margin;
        # repeat running head (optional)
        $page.text: -> $t {
            $t.font = $head-core, 12; # $font-size; head-core-size2
            $t.text-position = $x, $y;
            $t.say: "GNU FreeFont — {$face-title}", :align<left>;
        }
        $y -= 20;
    }

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
    my $n = 2; 
    for @nkeys.kv -> $i, $name {
        my $k = %names{$name};
        say "DEBUG: \$k: $k, \$name: $name" if $debug and $i < $n;
=end comment

    $font-path;

} # end of sub resolve-font-ref

sub do-pdf-language-samples(
    $font-ref is copy,
    Str:D :$ofile!,
    # default options if NOT explicitly entered
    :$font-size = 11,
    :$page-size = 'Letter',
    :$kerning   = True,
    :$lang      = False,
    :$debug,
    --> IO::Path
    ) is export {

    use PDF::Lite;
    use PDF::Font::Loader :load-font;
    use PDF::Content::Page :PageSizes;   # A4, Letter available
    use PDF::Content::Color :rgb;

    unless $font-ref.defined and ($font-ref ~~ /\S/) {
        $font-ref = "Free Serif";
    }

    my $font-path = resolve-font-ref $font-ref;


    # Note: font-size is only for the body text
    # other sizes may need to be modified after seeing real output:
    my $head-core-size = 16;

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

    # A bold core-font for headings (portable even if GNU FreeFont is missing)
    #   face only
    my $head-core = PDF::Lite.new.core-font(:family<Helvetica>, :weight<bold>);

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

    # --- Page Title ---
    my ($ptitle, $ptitle2);
    $page.text: -> $txt {
        $txt.font = $head-core, $head-core-size; # 16;
        $txt.text-position = $x, $y;
        $ptitle  = "GNU FreeFont – Language Samples — {$face-title}";
        $ptitle2 = "(Font size $font-size)";
        $txt.print: $ptitle, :align<left>;

        $txt.font = $head-core, $head-core-size - 2; # 16;
        $txt.say:   $ptitle2, :align<right>;
    }
    $y -= 26;   # add some vertical space after the title

    # Helper to start a fresh page when we run out of space
    sub new-page() {
        $page = $pdf.add-page;
        @pages = $pdf.pages;  # refresh list
        $x    = $margin;
        $y    = $page.media-box[3] - $margin;
        # repeat running head (optional)
        $page.text: -> $t {
            $t.font = $head-core, 12; # $font-size; head-core-size2
            $t.text-position = $x, $y;
            $ptitle2 = "GNU FreeFont — {$face-title}";
            $t.say: $ptitle2, :align<left>;
        }
        $y -= 20;
    }

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
    my $n = 2; 
    for @nkeys.kv -> $i, $name {
        my $k = %names{$name};
        say "DEBUG: \$k: $k, \$name: $name" if $debug and $i < $n;
        # $k is the two-char ISO abbreviation of the language
        # $sample{$k}.text  is the text line

        my %h = %samples{$k};
        my $lang = %h<lang>;
        my $text = %h<text>;
        say "DEBUG: \$lang: $lang" if 0 and $debug;
        say "DEBUG: \$text: $text" if 0 and $debug;
        # Header label for the language
        if $y < $margin + 60 { new-page }
        $page.text: -> $t {
            $t.font = $head-core, $font-size; # head-core-size2
            $t.text-position = $x, $y;
            # original text: $t.say: "$lang       (ISO ID: {$k.uc}, Font size: {$font-size})";
            $t.print: "$lang", :align<left>;
            $t.say:   "ISO ID: {$k.uc}", :align<right>;
        }
        $y -= 16;

        # The sample text set in the chosen font (wrap within the
        # content width)
        my @box;
        $page.text: -> $t {
            $t.font = $loaded-font, 12; # sample-text-size
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
