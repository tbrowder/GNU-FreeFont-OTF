unit module GNU::FreeFont-TTF::Classes;

=begin comment
use PDF::Content::FontObj;
use PDF::Font::Loader;

class SimpleFont is export {
    has PDF::Content::FontObj;
    method get-font($path) {
    
    }
}

unit module GNU::FreeFont-TTF::Classes;

use GNU::FreeFont-TTF::FontList;

monitor GFF is export {
    has $.id = 'gff';

    # Method 'get-font' returns a PDF::Content::FontObj object.
    # If the object already exists, that is returned;
    # otherwise, one is instantiated, added to the
    # collection of class objects, and then returned.
    method get-font(
        $name,
        :$debug,
        --> PDF::Content::FontObj
    ) {

        if $debug {
            say "DEBUG: Input \$name: '$name'";
            exit;
        }

        my $code;  #  =  $codes-rx;
        my $alias; #  = $aliases-rx;

        # examples of valid names:
        #   codes
        #     t,  cb
        #   aliases
        #     se, mb
        #     1..12
        if $name ~~ /$codes-rx/ {
            $code = $name;
        }
        elsif $name ~~ /$aliases-rx/ {
            $alias = $name;
        }
        else {
            say qq:to/HERE/;
            FATAL: Input \$name '$name' is not recognized.
                   Exiting...
            HERE
            exit(1);
        }
    }
}
=end comment
