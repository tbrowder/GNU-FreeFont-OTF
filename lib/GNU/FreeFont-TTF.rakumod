use OO::Monitors;

use MacOS::NativeLib "*";
use PDF::Lite;
use PDF::API6;
use PDF::Class;
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :&load-font;
use PDF::Content;
use PDF::Content::FontObj;

use Font::FreeType;

unit monitor GNU::FreeFont-OTF;

use GNU::FreeFont-OTF::FontList;
use GNU::FreeFont-OTF::FPaths;

has %.loaded-fonts;
has %.font-file-paths;

submethod TWEAK {
    my $debug = 0;
    %!font-file-paths = get-font-file-paths-hash :$debug;
}

method get-font(
    $name,
    :$debug,
    --> PDF::Content::FontObj
) {

    if 1 or $debug {
        say "DEBUG: Input \$name: '$name'";
        say "       \$codes-rx  : '$codes-rx'";
        say "       \$aliases   : '$aliases-rx'";
       # exit;
    }

    my $code;  #  member of $codes-rx;
    my $alias; #  member of $aliases-rx;

    # examples of valid names:
    #   codes
    #     t,  cb
    #   aliases
    #     se, mb, 1..12

    my $n = $name;
    if %codes-hash{$n}:exists {
        $code = %codes-hash{$n};
        say "name '$n' is a code: '$code'" if $debug;
    }
    elsif %aliases-hash{$n}:exists {
        $alias = %aliases-hash{$n};
        say "name '$n' is an alias: '$alias'" if $debug;
        # important: get the code from the aliases hash
        $code = %FontAliases{$alias};
    }
    else {
        say qq:to/HERE/;
        FATAL: Input \$name '$name' is not recognized.
               Exiting...
        HERE
        exit(1);
    }

    # if the font is already loaded return it
    return self.loaded-fonts{$code} if self.loaded-fonts{$code}:exists;

    # else
    # load the font, then return it 
    my $font-file = self.font-file-paths{$code};
    my $font = PDF::Font::Loader.load-font: :file($font-file);
    self.loaded-fonts{$code} = $font; #PDF::Font::Loader.load-font: :file($font-file);
    #return $ff.loaded-fonts{$code};
}
