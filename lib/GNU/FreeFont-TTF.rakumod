use OO::Monitors;

use Test;

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

use GNU::FreeFont-TTF::FontList;
use GNU::FreeFont-TTF::FPaths;

has %.loaded-fonts;
has %.font-file-paths;

submethod TWEAK {
    my $debug = 0;
    %!font-file-paths = get-font-file-paths-hash :$debug;
    if 0 {
        for %!font-file-paths.keys -> $k {
            my $path = %!font-file-paths{$k};
            say "DEBUG: key: '$k', path: '$path'";
        }
        say "DEBUG: exit in TWEAK";
        exit(1);
    }
}

=begin comment
# temp hack
    method get-font($code) {
    my $path = %!font-file-paths{$code};
    my $font  = PDF::Font::Loader.load-font: :file($path);
    return $font;
}
=end comment

=begin comment
use OO::Monitors;

use Test;

my $debug = 1;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

# testing the file path getter:
use GNU::FreeFont-TTF::FPaths;
my %fpaths = get-font-file-paths-hash;

my ($fpath, $fpath2);
my ($font, $font2);
$fpath  = %fpaths<t>;
$fpath2 = %fpaths<sa>;
isa-ok $fpath, IO::Path;
isa-ok $fpath2, IO::Path;

# use the valid paths to get a loaded font
$font  = PDF::Font::Loader.load-font: :file($fpath);
$font2 = PDF::Font::Loader.load-font: :file($fpath2);
isa-ok $font, PDF::Content::FontObj;
isa-ok $font2, PDF::Content::FontObj;

say "DEBUG: got valid font paths and loaded fonts";

done-testing;
=end comment

#=finish

method get-font-path(
    $code,
    --> IO::Path
    ) {
    %Fonts{$code};
}

method get-font(
    $name,
    :$debug,
    --> PDF::Content::FontObj
) {

    unless $name.defined and $name ~~ /\S/ {
        say qq:to/HERE/;
        FATAL:  Font \$name is either empty or undefined.
                Exiting...
        HERE
        exit(1);
    }

    if $debug {
        say "DEBUG: Input \$name: '$name'";
        say "       \$codes-rx  : '$codes-rx'";
        say "       \$aliases   : '$aliases-rx'";
        exit;
    }

    my $code;  #  member of $codes-rx;
    my $alias; #  member of $aliases-rx;

    # examples of valid names:
    #   codes
    #     t,  cb
    #   aliases
    #     se, mb, 1..12

    if 1 or $debug {
        say "DEBUG: codes list";
        for @codes-list -> $code {
            say "  code: '$code'";
            # get the font path
            my $path = self.font-file-paths{$code};
            #say "     path: '$path'";
            my $font = PDF::Font::Loader.load-font: :file($path);
            isa-ok $font, PDF::Content::FontObj, "a valid font object";
        };

        say "DEBUG: aliases list";
        for @aliases-list -> $alias {
            say "  alias: '$alias'"; #      '$_'" for @aliases-list;
        }

        #say "Ending test and exiting"; exit;
    }

    my $n = $name;
    #if %codes-hash{$n}:exists {
    if ($n ~~ any(@codes-list)).so {
        $code = %codes-hash{$n};
        say "name '$n' is a code: '$code'" if 1 or $debug;
    }
    elsif ($n ~~ any(@aliases-list)).so {
    #elsif %aliases-hash{$n}:exists {
        $alias = %aliases-hash{$n};
        say "name '$n' is an alias: '$alias'" if 1 or $debug;
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
    unless $code.defined and $code ~~ /\S/ {
        say qq:to/HERE/;
        FATAL:  Font \$code is either empty or undefined.
                Exiting...
        HERE
        exit(1);
    }

    my PDF::Content::FontObj $font;
    if self.loaded-fonts{$code}:exists {
        return self.loaded-fonts{$code};
    }

    # else
    # load the font, then return it
    my $font-file = self.get-file-path: $code; # font-file-paths{$code};
    note "DEBUG: Font file path: '$font-file'";
    note "       Exiting"; 
    exit(1);
    isa-ok, $font-file, IO::Path;

    say "DEBUG: Font file path: '$font-file'";
    say "       Exiting"; exit;

$font  = PDF::Font::Loader.load-font: :file($font-file);

    self.loaded-fonts{$code} = $font; #ad-font: :file($font-file);
    $font;
}
