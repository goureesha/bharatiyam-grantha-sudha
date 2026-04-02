/// Data model for a Vedic Book / Grantha
class Grantha {
  final String id;
  final String kannadaName;
  final String devanagariName;
  final String englishName;
  final String description;
  final String author;
  final String category; // e.g. 'ಸ್ತೋತ್ರ', 'ಉಪನಿಷದ್', 'ಪುರಾಣ', 'ಶಾಸ್ತ್ರ'
  final String icon; // emoji icon
  final int shlokaCount;
  final List<Adhyaya> adhyayas;

  const Grantha({
    required this.id,
    required this.kannadaName,
    required this.devanagariName,
    required this.englishName,
    required this.description,
    required this.author,
    required this.category,
    required this.icon,
    required this.shlokaCount,
    required this.adhyayas,
  });
}

/// Data model for a Chapter / Adhyaya
class Adhyaya {
  final String id;
  final int number;
  final String kannadaName;
  final String devanagariName;
  final String englishName;
  final List<Shloka> shlokas;

  const Adhyaya({
    required this.id,
    required this.number,
    required this.kannadaName,
    required this.devanagariName,
    required this.englishName,
    required this.shlokas,
  });
}

/// Data model for a single Shloka verse
class Shloka {
  final String id;
  final int number;
  final String kannadaText;      // Shloka in Kannada script
  final String devanagariText;   // Shloka in Devanagari script
  final String? kannadaMeaning;  // Meaning/translation in Kannada
  final String? englishMeaning;  // Optional English meaning

  const Shloka({
    required this.id,
    required this.number,
    required this.kannadaText,
    required this.devanagariText,
    this.kannadaMeaning,
    this.englishMeaning,
  });
}

/// Categories for organizing books
enum GranthaCategory {
  stotra,      // ಸ್ತೋತ್ರ — Devotional hymns
  upanishad,   // ಉಪನಿಷದ್ — Philosophical texts
  purana,      // ಪುರಾಣ — Mythological texts
  shastra,     // ಶಾಸ್ತ್ರ — Scientific/technical texts
  kavya,       // ಕಾವ್ಯ — Poetry
  sutra,       // ಸೂತ್ರ — Aphorisms
}

const Map<GranthaCategory, String> categoryNames = {
  GranthaCategory.stotra:    'ಸ್ತೋತ್ರ',
  GranthaCategory.upanishad: 'ಉಪನಿಷದ್',
  GranthaCategory.purana:    'ಪುರಾಣ',
  GranthaCategory.shastra:   'ಶಾಸ್ತ್ರ',
  GranthaCategory.kavya:     'ಕಾವ್ಯ',
  GranthaCategory.sutra:     'ಸೂತ್ರ',
};
