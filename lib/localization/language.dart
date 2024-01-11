class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "🇺🇸", "ENGLISH", "en"),
      Language(2, "🇳🇱", "NEDERLANDS", "nl"),
      Language(3, "🇪🇸", "SPANISH", "es"),
      Language(4, "🇩🇪", "GERMAN‎", "de"),
      Language(5, "🇫🇷", "FRENCH", "fr"),


    ];
  }
}