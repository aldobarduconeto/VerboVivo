class BibleChapter {
  const BibleChapter(
    this.reference,
    this.translation,
    this.verses, {
    this.bookName,
    this.chapterNumber,
    this.totalChapters,
  });

  final String reference;
  final String translation;
  final List<BibleVerse> verses;
  final String? bookName;
  final int? chapterNumber;
  final int? totalChapters;
}

class BibleVerse {
  const BibleVerse(this.number, this.text);
  final int number;
  final String text;
}

class BibleBookInfo {
  const BibleBookInfo({
    required this.id,
    required this.name,
    required this.chapters,
    required this.englishSlug,
    required this.aliases,
  });

  final int id; // 1 to 66
  final String name;
  final int chapters;
  final String englishSlug;
  final List<String> aliases;
}
