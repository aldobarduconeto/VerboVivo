class ReadingPlanDay {
  const ReadingPlanDay({
    required this.dayNumber,
    required this.title,
    required this.passages,
    required this.focusThought,
  });

  final int dayNumber;
  final String title;
  final List<String> passages; // e.g. ['Mateus 1', 'Salmos 23']
  final String focusThought;

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'title': title,
        'passages': passages,
        'focusThought': focusThought,
      };

  factory ReadingPlanDay.fromJson(Map<String, dynamic> json) => ReadingPlanDay(
        dayNumber: json['dayNumber'] as int,
        title: json['title'] as String,
        passages: List<String>.from(json['passages'] as List),
        focusThought: json['focusThought'] as String,
      );
}

class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.days,
    required this.iconName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final List<ReadingPlanDay> days;
  final String iconName; // 'book', 'star', 'heart', 'sparkles'

  int get durationDays => days.length;
}
