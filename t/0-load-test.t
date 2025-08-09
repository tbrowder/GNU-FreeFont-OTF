use Test;

my @modules = <
    GNU::FreeFont-OTF
    GNU::FreeFont-OTF::FontList
    GNU::FreeFont-OTF::Classes
    GNU::FreeFont-OTF::Subs
    GNU::FreeFont-OTF::Vars
    GNU::FreeFont-OTF::FPaths
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
