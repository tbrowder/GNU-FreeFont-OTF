unit module GNU::FreeFont-OTF::FontList;

our %Fonts is export = %(
    # These are the fonts from GNU FreeFont
    #   with their primary codes (from their Adobe heritage)
    FreeSerif            => "t",                              # 1
    FreeSerif-Bold       => "tb",                             # 2
    FreeSerif-Italic     => "ti",  # also to                  # 3
    FreeSerif-BoldItalic => "tbi", # also tbo, tob, tib       # 4

    FreeSans             => "h",                              # 5
    FreeSans-Bold        => "hb",                             # 6
    FreeSans-Oblique     => "ho",  # also hi                  # 7
    FreeSans-BoldOblique => "hbo", # also hbi, hob, hib       # 8

    FreeMono             => "c",                              # 9
    FreeMono-Bold        => "cb",                             # 10
    FreeMono-Oblique     => "co",  # also ci                  # 11
    FreeMono-BoldOblique => "cbo", # also cbi, cob, cib       # 12
);

# invert the hash and have short names (aliases) as keys
our %FontAliases is export = %Fonts.invert;

# add some extra keys called "aliases" # Time-Roman/FreeSerif
%FontAliases<se>   = "FreeSerif";            # 1
%FontAliases{1}    = "FreeSerif";            # 1

%FontAliases<seb>  = "FreeSerif-Bold";       # 2
%FontAliases{2}    = "FreeSerif-Bold";       # 2

%FontAliases<to>   = "FreeSerif-Italic";     # 3
%FontAliases{3}    = "FreeSerif-Italic";     # 3

%FontAliases<seo>  = "FreeSerif-Italic";
%FontAliases<sei>  = "FreeSerif-Italic";

%FontAliases<tbo>  = "FreeSerif-BoldItalic"; # 4
%FontAliases{4}    = "FreeSerif-BoldItalic"; # 4

%FontAliases<tob>  = "FreeSerif-BoldItalic";
%FontAliases<tib>  = "FreeSerif-BoldItalic";
%FontAliases<sebi> = "FreeSerif-BoldItalic";
%FontAliases<sebo> = "FreeSerif-BoldItalic";
%FontAliases<seob> = "FreeSerif-BoldItalic";
%FontAliases<seib> = "FreeSerif-BoldItalic";

# Helvetica/FreeSans
%FontAliases<sa>   = "FreeSans";             # 5
%FontAliases{5}    = "FreeSans";             # 5

%FontAliases<sab>  = "FreeSans-Bold";        # 6
%FontAliases{6}    = "FreeSans-Bold";        # 6

%FontAliases<hi>   = "FreeSans-Oblique";     # 7
%FontAliases{7}    = "FreeSans-Oblique";     # 7

%FontAliases<sai>  = "FreeSans-Oblique";
%FontAliases<sao>  = "FreeSans-Oblique";

%FontAliases<hbi>  = "FreeSans-BoldOblique"; # 8
%FontAliases{8}    = "FreeSans-BoldOblique"; # 8

%FontAliases<hob>  = "FreeSans-BoldOblique";
%FontAliases<hib>  = "FreeSans-BoldOblique";
%FontAliases<sabi> = "FreeSans-BoldOblique";
%FontAliases<sabo> = "FreeSans-BoldOblique";
%FontAliases<saob> = "FreeSans-BoldOblique";
%FontAliases<saib> = "FreeSans-BoldOblique";

# Courier/FreeMono
%FontAliases<m>   = "FreeMono";              # 9
%FontAliases{9}   = "FreeMono";              # 9

%FontAliases<mb>  = "FreeMono-Bold";         # 10
%FontAliases{10}  = "FreeMono-Bold";         # 10

%FontAliases<ci>  = "FreeMono-Oblique";      # 11
%FontAliases{11}  = "FreeMono-Oblique";      # 11

%FontAliases<mo>  = "FreeMono-Oblique";
%FontAliases<mi>  = "FreeMono-Oblique";

%FontAliases<cbi> = "FreeMono-BoldOblique";  # 12
%FontAliases{12}  = "FreeMono-BoldOblique";  # 12

%FontAliases<cob> = "FreeMono-BoldOblique";
%FontAliases<cib> = "FreeMono-BoldOblique";
%FontAliases<mbi> = "FreeMono-BoldOblique";
%FontAliases<mib> = "FreeMono-BoldOblique";
%FontAliases<mob> = "FreeMono-BoldOblique";
%FontAliases<mbo> = "FreeMono-BoldOblique";

# create some sets to match against
our $codes-rx   is export = %Fonts.values.join("|");

my @clist;
for %Fonts.values -> $v {
    @clist.push: $v;
}
my %cchash;
for @clist {
    %cchash{$_} = True;
}

our %codes-hash is export = %cchash; # set @clist; #(%Fonts.values).List;
our @codes-list is export = @clist;  # set @clist; #(%Fonts.values).List;

# remove codes from aliases
for %Fonts.kv -> $k, $code {
    if %FontAliases{$code}:exists {
        %FontAliases{$code}:delete;
    }
}

our $aliases-rx is export = %FontAliases.keys.join("|");

my @alist;
for %FontAliases.keys -> $v {
    @alist.push: $v;
}
my %aahash;
for @alist {
    %aahash{$_} = True;
}

our %aliases-hash is export = %aahash; #set @alist; # (%FontAliases.keys).List;
our @aliases-list is export = @alist;  # set @clist; #(%Fonts.values).List;

