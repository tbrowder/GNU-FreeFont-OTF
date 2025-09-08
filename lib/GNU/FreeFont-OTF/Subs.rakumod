unit module GNU::FreeFont-OTF::Subs;

use GNU::FreeFont-OTF::Vars;

#| Write a portrait PDF showing all language samples using a selected GNU FreeFont face.
#| $font-ref may be:
#|   * Int: 1=FreeSerif, 2=FreeSans, 3=FreeMono
#|   * Str: a family name (e.g., "FreeSans") or a path to a .ttf/.otf file
#| Options:
#|   * :page-size<Letter|A4> (default A4)
#| Renders pages in the given portrait size with ~0.75in margins and adds "n of m" page numbers bottom-right.
#| Returns the created file path as IO::Path.
sub pdf-language-samples($font-ref, Str:D $outfile, :$page-size = 'A4' , :$kerning = True --> IO::Path) is export {
    use PDF::Lite;
    use PDF::Font::Loader :load-font;
    use PDF::Content::Page :PageSizes;   # A4, Letter available
    use PDF::Content::Color :rgb;

    # --- Resolve the font the caller wants ---
    my %num-to-family = 1 => 'FreeSerif', 2 => 'FreeSans', 3 => 'FreeMono';

    my $loaded-font = do given $font-ref {
        when Int {
            my $fam = %num-to-family{$font-ref} // 'FreeSerif';
            try { load-font :family($fam) } // die "Could not find GNU FreeFont family ‘$fam’. Is it installed?";
        }
        when Str {
            my $s = $_.IO;
            if $s.e && $s.f {         # looks like a path to a font file
                load-font :file($s.absolute);
            }
            else {
                try { load-font :family($_) } // die "Could not find font family ‘$_’. Is it installed?";
            }
        }
        default { die "Unsupported font reference type: { .^name }" }
    };

    # Introspect a face title as best we can; fallback to reference/filename.
    sub face-title($font, $ref) {
        for <full-name family subfamily style name ps-name postscript-name> -> $m {
            my $v = try $font."$m"();
            return $v if $v.defined && $v ne "" ;
        }
        if $ref ~~ Int { %num-to-family{$ref} // "GNU FreeFont" }
        elsif $ref ~~ Str {
            my $io = $ref.IO;
            $io.f ?? $io.basename !! $ref
        }
        else { "GNU FreeFont" }
    }
    my $face-title = face-title($loaded-font, $font-ref);

    # A bold core-font for headings (portable even if GNU FreeFont is missing)
    my $head-core = PDF::Lite.new.core-font(:family<Helvetica>, :weight<bold>);  # face only

    # --- Make a new PDF (portrait page-size) ---
    my PDF::Lite $pdf .= new;
    my $size = $page-size.lc eq 'letter' ?? Letter !! A4;
    $pdf.media-box = $size;  # chosen size
    my PDF::Lite::Page $page = $pdf.add-page;
    my @pages = $pdf.pages;  # capture page list

    # --- Page metrics ---
    my num $margin = 54;                 # 0.75in
    my num $x      = $margin;
    my num $y      = $page.media-box[3] - $margin; # top margin from page height
    my num $col-w  = $page.media-box[2] - 2*$margin;

    # --- Title ---
    $page.text: -> $txt {
        $txt.font = $head-core, 18;
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
            $t.font = $head-core, 12;
            $t.text-position = $x, $y;
            $t.say: "GNU FreeFont — {$face-title}", :align<left>;
        }
        $y -= 20;
    }

    # --- Body: each entry in %default-samples is a (language => text) pair ---
    my %samples := try %default-samples
        orelse die "This routine expects %%default-samples to be defined in GNU::FreeFont::Subs";

    for %samples.sort(*.key) -> $k, $sample {
        # Header label for the language
        if $y < $margin + 60 { new-page }
        $page.text: -> $t {
            $t.font = $head-core, 12;
            $t.text-position = $x, $y;
            $t.say: $k;
        }
        $y -= 16;

        # The sample text set in the chosen font (wrap within the content width)
        my @box;
        $page.text: -> $t {
            $t.font = $loaded-font, 12;
            $t.text-position = $x, $y;
            @box = $t.say: $sample, :width($col-w), :align<left>, :kern($kerning);
        }
        # Move below the block with a little breathing room.
        my $block-h = @box[3] - @box[1];       # y1 - y0
        $y -= $block-h + 12;
    }

    # --- Footers: add "n of m" and a generator mark on every page ---
    my $total = +@pages;
    my $w = $page.media-box[2];
    my $h = $page.media-box[3];
    my $right-x = $w - $margin;                 # right margin x
    for @pages.kv -> $i, $pg {
        my $num = $i + 1;
        $pg.text: -> $t {
            $t.font = $pdf.core-font(:family<Helvetica>), 9;
            $t.FillColor = rgb(.5, .5, .5);
            # Left footer mark
            $t.text-position = $margin, $margin - 10;
            $t.say: "Generated by GNU::FreeFont";
            # Right-aligned page number
            $t.text-position = $right-x, $margin - 10;
            $t.say: "Page {$num} of {$total}", :align<right>;
        }
    }

    # --- Write the file ---
    $pdf.save-as: $outfile;
    return $outfile.IO;
}
