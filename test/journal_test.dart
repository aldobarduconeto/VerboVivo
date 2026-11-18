import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbo_vivo/controllers/journal_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JournalController & Models', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('adds and retrieves verse highlights', () async {
      final controller = JournalController.instance;
      await controller.load();

      await controller.setHighlight(
        chapterReference: 'Salmos 23',
        verseNumber: 1,
        reference: 'Salmos 23:1',
        text: 'O Senhor é o meu pastor; nada me faltará.',
        colorKey: 'gold',
      );

      final highlight = controller.getHighlight('Salmos 23', 1);
      expect(highlight, isNotNull);
      expect(highlight!.reference, equals('Salmos 23:1'));
      expect(highlight.colorKey, equals('gold'));

      final chapterHighlights = controller.highlightsForChapter('Salmos 23');
      expect(chapterHighlights.containsKey(1), isTrue);

      await controller.removeHighlight('Salmos 23', 1);
      expect(controller.getHighlight('Salmos 23', 1), isNull);
    });

    test('adds, toggles answered, and deletes prayer items', () async {
      final controller = JournalController.instance;
      await controller.load();

      await controller.addPrayer(
        title: 'Paz para minha família',
        description: 'Clamando por harmonia e saúde.',
        scriptureReference: 'Filipenses 4:7',
      );

      expect(controller.activePrayers.length, equals(1));
      expect(controller.answeredPrayers.length, equals(0));

      final prayer = controller.activePrayers.first;
      expect(prayer.title, equals('Paz para minha família'));
      expect(prayer.isAnswered, isFalse);

      // Toggle answered
      await controller.togglePrayerAnswered(prayer.id);

      expect(controller.activePrayers.length, equals(0));
      expect(controller.answeredPrayers.length, equals(1));
      expect(controller.answeredPrayers.first.isAnswered, isTrue);
      expect(controller.answeredPrayers.first.answeredAt, isNotNull);

      // Delete prayer
      await controller.deletePrayer(prayer.id);
      expect(controller.allPrayers.isEmpty, isTrue);
    });
  });
}
