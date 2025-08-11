use Test;

my @modules = <
    GNU::FreeFont-TTF
    GNU::FreeFont-TTF::FontList
    GNU::FreeFont-TTF::Classes
    GNU::FreeFont-TTF::Subs
    GNU::FreeFont-TTF::Vars
    GNU::FreeFont-TTF::FPaths
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
