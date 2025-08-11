use OO::Monitors;

unit monitor GNU::FreeFont-TTF;

use MacOS::NativeLib "*";
use PDF::Lite;
use PDF::API6;
use PDF::Class;
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :&load-font;
use PDF::Content;
use PDF::Content::FontObj;

use Font::FreeType;

#use GNU::FreeFont-TTF::FontList;
use GNU::FreeFont-TTF::FontPaths;

#has %.loaded-fonts;
has %.font-file-paths;
has @.codes-list;

submethod TWEAK {
    my $debug = 0;
    %!font-file-paths = get-font-file-paths-hash :$debug;
    @!codes-list = %!font-file-paths.keys;

    if 0 {
        for %!font-file-paths.keys -> $k {
            my $path = %!font-file-paths{$k};
            say "DEBUG: key: '$k', path: '$path'";
        }
        say "DEBUG: exit in TWEAK";
        exit(1);
    }
}

method get-font(
    $code is copy,
    --> PDF::Content::FontObj
) {
    # Note: "$code" may be the name with spaces
    $code ~~ s:g/\h//;

    # use the code to get a file path
    my $path = self.get-font-path: $code;
    # use the path to load the font
    my $font = self.get-font-object: $path;
}

method get-font-path(
    $code,
    --> IO::Path
    ) {
    my $path = self.font-file-paths{$code} // "(none)";
    if $path eq "(none)" {
        say qq:to/HERE/;
        FATAL: File code '$code' not recognized.
               Exiting...
        HERE
        exit(1);
    }
    $path;
}

method get-font-object(
    IO::Path $file,
    :$debug,
    --> PDF::Content::FontObj
) {

    # load the font, then return it
    my $font  = PDF::Font::Loader.load-font: :$file;

#   self.loaded-fonts{$code} = $font; #ad-font: :file($font-file);
    $font;
}
