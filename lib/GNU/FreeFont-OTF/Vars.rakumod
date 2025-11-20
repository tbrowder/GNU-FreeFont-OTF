unit module GNU::FreeFont-OTF::Vars;

our %lang-names is export = %(
    English              => "en",
    Dutch                => "nl",
    German               => "de";
    Spanish              => "es",
    French               => "fr",
    Indonesian           => "id",
    Italian              => "it",
    'Norwegian (Bokmål)' => "nb",
    'Norwegian (Nyorsk)' => "nn",
    Polish               => "pl",
    Romanian             => "ro",
    Russian              => "ru",
    Ukranian             => "uk",
);

our %default-samples is export = %(
    # keyed by two-character ISO language code
    #     key => {
    #         lang => "",
    #         text => "",
    #         font => "",
    #     }
    nl => {
        lang => 'Dutch',
        text => 'Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Walther spillede pålofon.',
        font => "",
    },
    en => {
        lang => 'English',
        text => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789 Oo Fi fi fii Wa',
    },
    fr => {
        lang => 'French',
        text => 'Voix ambiguë d’un cœur qui, au zéphyr, préfère les jattes de kiwis.',
        font => "",
    },
    de => {
        lang => 'German',
        text => 'Zwölf Boxkämpfer jagen Viktor quer über den großen Sylter Deich.',
        font => "",
    },
    id => {
        lang => 'Indonesian',
        text => 'Saya lihat foto Hamengkubuwono XV bersama enam zebra purba cantik yang jatuh dari Al Quranmu.',
        font => "",
    },
    it => {
        lang => 'Italian',
        text => 'Ma la volpe, col suo balzo, ha raggiunto il quieto Fido.',
        font => "",
    },
    nb => {
        lang => 'Norwegian (Bokmål)',
        text => 'Vår sære Zulu fra badeøya spilte jo whist og quickstep',
        font => "",
    },
    nn => {
        lang => 'Norwegian (Nyorsk)',
        text => "Høvdingen såg på dei små fugleungane då ætta åt ein ås.",
        font => "",
    },
    pl => {
        lang => 'Polish',
        text => 'Pchnąć w tę łódź jeża lub ośm skrzyń fig.',
        font => "",
    },
    ro => {
        lang => 'Romanian',
        text => 'Agera vulpe maronie sare peste câinele cel leneş.',
        font => "",
    },
    ru => {
        lang => 'Russian',
        text => 'Съешь ещё этих мягких французских булок да выпей же чаю.',
        font => "",
    },
    es => {
        lang => 'Spanish',
        text => 'El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón detrás del palenque de paja.',
        font => "",
    },
    uk => {
        lang => 'Ukranian',
        text => 'Чуєш їх, доцю, га? Кумедна ж ти, прощайся без ґольфів!',
        font => "",
    },
);
