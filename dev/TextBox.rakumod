unit module GNU::FreeFont-OTF::TextBox;

use PDF::Content::Text::Box;

# from published module Name::Tags
subset Loc of UInt where 0 <= $_ < 12;
sub put-text(
    # based on my PostScript function /puttext
    $x is copy, $y is copy, # box corner reference point
    :$text!,
    :$page!,
    :$font-ref!, # the loaded font

    # defaults
    :$font-size = 12,
    # position of the enclosed text bbox in relation to the current point
Loc :$position = 0, #  where {0 <= $_ < 12},
    # optional constraints
    :$width,
    :$height,
    :$debug,
    ) is export {

    my $font = $font-ref;
    my PDF::Content::Text::Box $bbox;

    #==========================================
    # Determine text bbox size
    if $width and $height {
        # get constrained box size from PDF::Content
        #   define the applicable set of params affected
        if $position (cont) <0 1 2 3 4 5 6 7 8 9 10 11>.Set {
        }
        $bbox .= new: :$text, :$font, :$font-size, :$width, :$height;
    }
    elsif $height {
        # get constrained box size from PDF::Content
        #   define the applicable set of params affected
        if $position (cont) <0 1 2 3 4 5 6 7 8 9 10 11>.Set {
        }
        $bbox .= new: :$text, :$font, :$font-size, :$height;
    }
    elsif $width {
        # get constrained box size from PDF::Content
        #   define the applicable set of params affected
        if $position (cont) <0 1 2 3 4 5 6 7 8 9 10 11>.Set {
        }
        $bbox .= new: :$text, :$font, :$font-size, :$width;
    }
    else {
        # get natural box size from PDF::Content
        #   define the applicable set of params affected
        if $position (cont) <0 1 2 3 4 5 6 7 8 9 10 11>.Set {
        }
        $bbox .= new: :$text, :$font, :$font-size;
    }

    # Determine location of the text box based on calculated bbox above

    # query the bbox
    my $bwidth  = $bbox.content-width;
    my $bheight = $bbox.content-height;
    my $bllx;
    my $blly;

=begin comment
    $page.graphics: {
        my $tx = $cx;
        my $ty = $cy + ($height * 0.5) - $line1Y;
        .transform: :translate($tx, $ty); # where $x/$y is the desired reference point
        .FillColor = color White; #rgb(0, 0, 0); # color Black
        .font = %fonts<hb>, #.core-font('HelveticaBold'),
                 $line1size; # the size
        .print: $gb, :align<center>, :valign<center>;
    }
=end comment

} # put-text
