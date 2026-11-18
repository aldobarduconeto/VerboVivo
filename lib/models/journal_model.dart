class VerseHighlight {
  const VerseHighlight({
    required this.chapterReference,
    required this.verseNumber,
    required this.reference,
    required this.text,
    required this.colorKey,
    this.note,
    required this.createdAt,
  });

  final String chapterReference; // e.g. "Salmos 23"
  final int verseNumber;         // e.g. 1
  final String reference;        // e.g. "Salmos 23:1"
  final String text;
  final String colorKey;         // 'gold', 'green', 'blue', 'rose'
  final String? note;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'chapterReference': chapterReference,
        'verseNumber': verseNumber,
        'reference': reference,
        'text': text,
        'colorKey': colorKey,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory VerseHighlight.fromJson(Map<String, dynamic> json) => VerseHighlight(
        chapterReference: json['chapterReference'] as String,
        verseNumber: json['verseNumber'] as int,
        reference: json['reference'] as String,
        text: json['text'] as String,
        colorKey: json['colorKey'] as String,
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class PrayerItem {
  const PrayerItem({
    required this.id,
    required this.title,
    required this.description,
    this.scriptureReference,
    required this.createdAt,
    this.answeredAt,
    this.isAnswered = false,
  });

  final String id;
  final String title;
  final String description;
  final String? scriptureReference;
  final DateTime createdAt;
  final DateTime? answeredAt;
  final bool isAnswered;

  PrayerItem copyWith({
    String? title,
    String? description,
    String? scriptureReference,
    bool? isAnswered,
    DateTime? answeredAt,
  }) {
    return PrayerItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      scriptureReference: scriptureReference ?? this.scriptureReference,
      createdAt: createdAt,
      answeredAt: answeredAt ?? this.answeredAt,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'scriptureReference': scriptureReference,
        'createdAt': createdAt.toIso8601String(),
        'answeredAt': answeredAt?.toIso8601String(),
        'isAnswered': isAnswered,
      };

  factory PrayerItem.fromJson(Map<String, dynamic> json) => PrayerItem(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        scriptureReference: json['scriptureReference'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        answeredAt: json['answeredAt'] != null
            ? DateTime.parse(json['answeredAt'] as String)
            : null,
        isAnswered: (json['isAnswered'] as bool?) ?? false,
      );
}
