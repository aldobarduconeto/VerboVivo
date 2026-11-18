class DevotionalModel {
  const DevotionalModel({
    required this.id,
    required this.date,
    required this.title,
    required this.theme,
    required this.scriptureReference,
    required this.scriptureText,
    required this.reflection,
    required this.prayer,
    required this.practicalAction,
    this.author = 'VerboVivo',
  });

  final String id;
  final DateTime date;
  final String title;
  final String theme;
  final String scriptureReference;
  final String scriptureText;
  final String reflection;
  final String prayer;
  final String practicalAction;
  final String author;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'title': title,
        'theme': theme,
        'scriptureReference': scriptureReference,
        'scriptureText': scriptureText,
        'reflection': reflection,
        'prayer': prayer,
        'practicalAction': practicalAction,
        'author': author,
      };

  factory DevotionalModel.fromJson(Map<String, dynamic> json) =>
      DevotionalModel(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        title: json['title'] as String,
        theme: json['theme'] as String,
        scriptureReference: json['scriptureReference'] as String,
        scriptureText: json['scriptureText'] as String,
        reflection: json['reflection'] as String,
        prayer: json['prayer'] as String,
        practicalAction: json['practicalAction'] as String,
        author: (json['author'] as String?) ?? 'VerboVivo',
      );
}
