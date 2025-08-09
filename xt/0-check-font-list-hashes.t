use Test;

use GNU::FreeFont-OTF::FontList;

my $debug = 1;

# check for correct keys
# primary codes:
# the hash must contain all these keys as VALUES and no more
my @pcodes = <
    t ti tb tbi   
    h ho hb hbo 
    c co cb cbo
>;

my %fi = %Fonts.invert; # codes (values) become keys
my @fc;
my @fn1; 
for @pcodes -> $code {
    if %fi{$code}:exists {
        # good, save it
        @fc.push: $code;   
        # also save the font name
        @fn1.push: %fi{$code};
    }
    else {
        say "ERROR: primary code '$code' not found" if $debug;
    }
}
# set comparison
cmp-ok Set(@pcodes), 'cmp', Set(@fc), "primary code sets are equal";

# now test the aliases
# aliases should NOT have any of the primary codes as values
# alias keys MUST be a member of the %Fonts keys (which are the 
#   recognized font faces)
 
my %Fo = %Fonts;       # font-name => code
my %Fa = %FontAliases; # alias     => font-name
my @fa = [];
my @fn2 = [];
for %Fa.kv -> $alias, $fname {
   @fn2.push: $fname;
   @fa.push: $alias;
}

# set comparisons
# font face name sets
cmp-ok Set(@fn1), 'cmp', Set(@fn2), "font face name sets are equal";

# font face name codes and aliases MUST NOT OVERLAP
my $sa = Set(@pcodes);
my $sb = Set(@fa);

is-deeply $sa (&) $sb, Set.new, "codes and aliases do NOT overlap"; 

# test the codes and aliases hashes
my @test-names = 'ti', 'o', 't', 1, 'mb', 12, 13;
my $tnames = @test-names.join(" ");
say "Using test names: '$tnames'";
my $s;
for @test-names -> $n {
    if %codes-hash{$n}:exists {
        $s = %codes-hash{$n};
        say "name '$n' is a code: '$s'";
    }
    elsif %aliases-hash{$n}:exists {
        $s = %aliases-hash{$n};
        say "name '$n' is an alias: '$s'";
    }
    else {
        say "name '$n' was NOT found in either hash";
    }
}

done-testing;

