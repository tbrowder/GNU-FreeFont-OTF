use Test;

my @modules = [
    'GNU::FreeFont-OTF',
    'GNU::FreeFont-OTF::Subs',
    'GNU::FreeFont-OTF::FontPaths',
    'GNU::FreeFont-OTF::Vars',
];

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
