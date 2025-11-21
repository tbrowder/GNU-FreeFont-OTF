unit module GNU::FreeFont::CodeCharts;

use v6.d;

use HTTP::UserAgent;
use PDF::Lite;
use PDF::Content::Page :PageSizes;
use PDF::Font::Loader :load-font;

#======================================================================
# Configuration
#======================================================================

my constant $base-url = 'https://www.gnu.org/software/freefont/ranges/';

# Grid layout: 16 columns × 8 rows = 128 codepoints per page
my constant Int GRID-COLS      = 16;
my constant Int GRID-ROWS      = 8;
my constant Int CELLS-PER-PAGE = GRID-COLS * GRID-ROWS;

# TOC layout: rough number of entries per page
my constant Int TOC-LINES-PER-PAGE = 40;

# Margins and header/footer (points)
my constant num MARGIN-LEFT   = 36;  # 0.5"
my constant num MARGIN-RIGHT  = 36;
my constant num MARGIN-TOP    = 36;
my constant num MARGIN-BOTTOM = 36;

my constant num HEADER-HEIGHT = 28;
my constant num FOOTER-HEIGHT = 24;

#======================================================================
# Data structures
#======================================================================

class FFBlock {
    has Str $.script;
    has Str $.name;
    has Int $.start-int;
    has Int $.end-int;
    has Str $.start-hex;
    has Str $.end-hex;
    has Str $.url;

    has Int $.start-page is rw;
    has Int $.pages      is rw;
}

class TOCEntry {
    has Str $.script;
    has Str $.block;
    has Str $.start-hex;
    has Str $.end-hex;
    has Int $.page;
}

#======================================================================
# HTTP helpers
#======================================================================

sub fetch(Str $url, HTTP::UserAgent $ua --> Str) {
    my $res = $ua.get($url);

    if $res.is-error {
        die "GET failed for $url: {$res.status-line}";
    }

    return $res.decoded-content;
}

#======================================================================
# Parse GNU FreeFont ranges -> @FFBlock
#======================================================================

sub script-name-from-url(Str $url --> Str) {
    my Str $tail = $url.subst($base-url, '');
    $tail = $tail.subst(/ '.html' $ /, '');
    return $tail;
}

sub parse-ranges(HTTP::UserAgent $ua --> Array[FFBlock]) {
    my Str $index-html = fetch($base-url, $ua);

    my @page-urls;
    my %seen-url;

    # 1. Collect .html range pages from index
    for $index-html.lines -> $line {
        if $line ~~ / 'href="' $<path>=( <-["]>+ ) '"' / {
            my Str $path = ~$<path>;

            next unless $path.ends-with('.html');

            my Str $url;
            if $path.starts-with('http') {
                $url = $path;
            }
            else {
                $url = $base-url ~ $path;
            }

            next if %seen-url{$url}:exists;
            %seen-url{$url} = True;
            @page-urls.push: $url;
        }
    }

    my @blocks;

    # 2. For each page, pull out headings like:
    #    ### Basic Latin (less control characters) 0020-007E
    for @page-urls -> $url {
        my Str $html        = fetch($url, $ua);
        my Str $script-name = script-name-from-url($url);

        for $html.lines -> $line {
            if $line ~~ /^\s* '### ' $<name>=(.+?) \s+ $<start>=[<xdigit>+] '-' $<end>=[<xdigit>+] / {
                my Str $block-name = ~$<name>.trim;
                my Str $start-hex  = ~$<start>.uc;
                my Str $end-hex    = ~$<end>.uc;

                my Int $start-int = :16($start-hex);
                my Int $end-int   = :16($end-hex);

                my FFBlock $block .= new(
                    script    => $script-name,
                    name      => $block-name,
                    start-int => $start-int,
                    end-int   => $end-int,
                    start-hex => $start-hex,
                    end-hex   => $end-hex,
                    url       => $url,
                );
                @blocks.push: $block;
            }
        }
    }

    return @blocks;
}

#======================================================================
# Layout calculation: TOC & per-block pages
#======================================================================

sub compute-layout(
    @blocks,
    Int $toc-lines-per-page,
    Int $cells-per-page,
    Int $cover-pages = 1
    --> Hash
) is export(:layout) {

    my Int $block-count = @blocks.elems;

    my Int $toc-pages = ($block-count + $toc-lines-per-page - 1)
        div $toc-lines-per-page;

    my Int $first-content-page = $cover-pages + $toc-pages + 1;

    my Int $current-page = $first-content-page;
    my @toc-entries;

    for @blocks -> $block {
        my Int $count = $block.end-int - $block.start-int + 1;
        my Int $pages = ($count + $cells-per-page - 1) div $cells-per-page;

        $block.start-page = $current-page;
        $block.pages      = $pages;

        my TOCEntry $entry .= new(
            script    => $block.script,
            block     => $block.name,
            start-hex => $block.start-hex,
            end-hex   => $block.end-hex,
            page      => $current-page,
        );
        @toc-entries.push: $entry;

        $current-page = $current-page + $pages;
    }

    my Int $total-pages = $current-page - 1;

    return {
        toc-pages          => $toc-pages,
        first-content-page => $first-content-page,
        total-pages        => $total-pages,
        toc-entries        => @toc-entries,
    };
}

#======================================================================
# Drawing helpers
#======================================================================

sub draw-page-footer(
    PDF::Lite::Page $page,
    PDF::Content::FontObj $font,
    Int $page-number,
    Int $total-pages
) {
    my @box        = $page.media-box;
    my num $width  = @box[2];
    my num $x      = $width - MARGIN-RIGHT;
    my num $y      = MARGIN-BOTTOM / 2;

    my Str $label  = "Page {$page-number} of {$total-pages}";

    $page.text: {
        .font = $font, 8;
        .say: $label, :position[$x, $y], :align<right>;
    }
}

sub draw-cover-page(
    PDF::Lite::Page $page,
    PDF::Content::FontObj $title-font,
    PDF::Content::FontObj $body-font,
    Int $total-pages
) {
    my @box       = $page.media-box;
    my num $w     = @box[2];
    my num $h     = @box[3];

    my num $center-x = $w / 2;
    my num $center-y = $h / 2;

    $page.text: {
        .font = $title-font, 24;
        .say: 'GNU FreeFont Unicode Coverage',
            :position[$center-x, $center-y + 40],
            :align<center>;

        .font = $body-font, 12;
        .say: 'Code charts generated from GNU FreeFont ranges',
            :position[$center-x, $center-y + 10],
            :align<center>;
        .say: 'Source: https://www.gnu.org/software/freefont/ranges/',
            :position[$center-x, $center-y - 10],
            :align<center>;
        .say: "Total pages (incl. cover & TOC): {$total-pages}",
            :position[$center-x, $center-y - 30],
            :align<center>;
    }
}

sub draw-toc(
    PDF::Lite $pdf,
    @entries,
    PDF::Content::FontObj $body-font,
    Int $toc-pages,
    Int $total-pages
) {
    my Int $entry-index = 0;

    for 1 .. $toc-pages -> $toc-page-no {
        my PDF::Lite::Page $page = $pdf.add-page;

        my @box      = $page.media-box;
        my num $w    = @box[2];
        my num $h    = @box[3];

        my num $top-y = $h - MARGIN-TOP;

        $page.text: {
            .font = $body-font, 16;
            .say: 'Table of Contents',
                :position[$w / 2, $top-y],
                :align<center>;

            my num $line-y = $top-y - 24;
            .font = $body-font, 10;

            for 1 .. TOC-LINES-PER-PAGE -> $line {
                last if $entry-index >= @entries.elems;

                my TOCEntry $e = @entries[$entry-index];

                my Str $label = "{$e.script} – {$e.block} ({$e.start-hex}-{$e.end-hex})";
                my Str $page-str = $e.page.Str;

                .say: $label, :position[MARGIN-LEFT, $line-y];

                .say: $page-str,
                    :position[$w - MARGIN-RIGHT, $line-y],
                    :align<right>;

                $line-y = $line-y - 12;
                $entry-index = $entry-index + 1;
            }
        }

        draw-page-footer($page, $body-font, $toc-page-no + 1, $total-pages);
    }
}

sub draw-block-page(
    PDF::Lite $pdf,
    FFBlock $block,
    PDF::Content::FontObj $body-font,
    Int $page-number,
    Int $total-pages,
    Int $page-index-for-block,
    Int $cells-per-page
) {
    my PDF::Lite::Page $page = $pdf.add-page;

    my @box        = $page.media-box;
    my num $width  = @box[2];
    my num $height = @box[3];

    my num $grid-left   = MARGIN-LEFT;
    my num $grid-right  = $width - MARGIN-RIGHT;
    my num $grid-bottom = MARGIN-BOTTOM + FOOTER-HEIGHT;
    my num $grid-top    = $height - MARGIN-TOP - HEADER-HEIGHT;

    my num $grid-width  = $grid-right - $grid-left;
    my num $grid-height = $grid-top - $grid-bottom;

    my num $cell-width  = $grid-width / GRID-COLS;
    my num $cell-height = $grid-height / GRID-ROWS;

    # Header with block info
    $page.text: {
        .font = $body-font, 12;
        my Str $title = "{$block.name} ({$block.start-hex}-{$block.end-hex})";
        .say: $title,
            :position[$width / 2, $height - MARGIN-TOP],
            :align<center>;

        .font = $body-font, 10;
        my Str $script-label = "Script: {$block.script}   Source: {$block.url}";
        .say: $script-label,
            :position[MARGIN-LEFT, $height - MARGIN-TOP - 14];
    }

    # Determine which codepoints go on this page
    my Int $block-size   = $block.end-int - $block.start-int + 1;
    my Int $first-index  = $page-index-for-block * $cells-per-page;
    my Int $last-index   = $first-index + $cells-per-page - 1;
    if $last-index >= $block-size {
        $last-index = $block-size - 1;
    }

    # Draw grid
    $page.graphics: {
        # outer rectangle
        .Rectangle($grid-left, $grid-bottom, $grid-width, $grid-height);
        .paint: :stroke;

        # verticals
        my num $x = $grid-left;
        for 1 .. GRID-COLS - 1 -> $col {
            $x = $x + $cell-width;
            .MoveTo($x, $grid-bottom);
            .LineTo($x, $grid-top);
        }

        # horizontals
        my num $y = $grid-bottom;
        for 1 .. GRID-ROWS - 1 -> $row {
            $y = $y + $cell-height;
            .MoveTo($grid-left,  $y);
            .LineTo($grid-right, $y);
        }

        .Stroke;
    }

    # Draw glyphs and labels
    $page.text: {
        for $first-index .. $last-index -> $i {
            my Int $cp = $block.start-int + $i;

            my Int $cell-index = $i - $first-index;
            my Int $row        = $cell-index div GRID-COLS;
            my Int $col        = $cell-index %  GRID-COLS;

            my num $x0 = $grid-left + $col * $cell-width;
            my num $y0 = $grid-bottom + (GRID-ROWS - 1 - $row) * $cell-height;

            my Str $hex;
            if $cp <= 0xFFFF {
                $hex = $cp.fmt('%04X');
            }
            else {
                $hex = $cp.fmt('%06X');
            }

            .font = $body-font, 7;
            my Str $label = "U+{$hex}";
            .say: $label,
                :position[$x0 + 2, $y0 + $cell-height - 10];

            my Str $glyph = $cp.chr;
            .font = $body-font, 16;
            .say: $glyph,
                :position[$x0 + $cell-width / 2, $y0 + $cell-height / 2],
                :align<center>;
        }
    }

    draw-page-footer($page, $body-font, $page-number, $total-pages);
}

#======================================================================
# Public API
#======================================================================

sub generate-codecharts(
    Str :$output    = 'FreeFont-CodeCharts.pdf',
    Str :$page-size = 'Letter',
    Str :$font-file!,
    HTTP::UserAgent :$ua
) is export {
    my HTTP::UserAgent $client;

    if $ua.defined {
        $client = $ua;
    }
    else {
        $client .= new;
    }

    my @blocks = parse-ranges($client);

    if @blocks.elems == 0 {
        die "No blocks parsed from FreeFont ranges.";
    }

    my %layout = compute-layout(
        @blocks,
        TOC-LINES-PER-PAGE,
        CELLS-PER-PAGE,
        1,
    );

    my Int $toc-pages          = %layout<toc-pages>;
    my Int $first-content-page = %layout<first-content-page>;
    my Int $total-pages        = %layout<total-pages>;
    my @toc-entries            = %layout<toc-entries>;

    my PDF::Lite $pdf .= new;

    my $media-box;
    if $page-size.lc eq 'a4' {
        $media-box = A4;
    }
    else {
        $media-box = Letter;
    }
    $pdf.media-box = $media-box;

    my PDF::Content::FontObj $ff-font = load-font: :file($font-file);

    # Cover page
    my PDF::Lite::Page $cover-page = $pdf.add-page;
    draw-cover-page($cover-page, $ff-font, $ff-font, $total-pages);
    draw-page-footer($cover-page, $ff-font, 1, $total-pages);

    # TOC pages
    if $toc-pages > 0 {
        draw-toc($pdf, @toc-entries, $ff-font, $toc-pages, $total-pages);
    }

    # Block pages
    my Int $current-page = $first-content-page;

    for @blocks -> $block {
        for 0 .. $block.pages - 1 -> $page-index-for-block {
            draw-block-page(
                $pdf,
                $block,
                $ff-font,
                $current-page,
                $total-pages,
                $page-index-for-block,
                CELLS-PER-PAGE,
            );
            $current-page = $current-page + 1;
        }
    }

    $pdf.save-as: $output;
}
