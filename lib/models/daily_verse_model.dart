class DailyVerse {
  const DailyVerse({
    required this.id,
    this.date,
    required this.reference,
    required this.verseText,
    required this.theme,
    required this.reflection,
    required this.chapterReference,
    required this.verseNumber,
  });

  final String id;
  final DateTime? date;
  final String reference;        // e.g. "Filipenses 4:13"
  final String verseText;
  final String theme;            // e.g. "Força & Confiança"
  final String reflection;
  final String chapterReference; // e.g. "Filipenses 4"
  final int verseNumber;         // e.g. 13
}
