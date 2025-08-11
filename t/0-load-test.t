use Test;

my @modules = <
    GNU::FreeFont-TTF
    GNU::FreeFont-TTF::Subs
    GNU::FreeFont-TTF::FontPaths
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
