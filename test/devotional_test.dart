import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbo_vivo/controllers/devotional_controller.dart';
import 'package:verbo_vivo/models/devotional_model.dart';
import 'package:verbo_vivo/services/devotional_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DevotionalService', () {
    const service = DevotionalService();

    test('returns consistent devotional for specific date', () {
      final date = DateTime(2026, 11, 18);
      final devotional = service.getDevotionalForDate(date);

      expect(devotional, isA<DevotionalModel>());
      expect(devotional.id, contains('dev-2026-11-18'));
      expect(devotional.title.isNotEmpty, isTrue);
      expect(devotional.scriptureReference.isNotEmpty, isTrue);
      expect(devotional.scriptureText.isNotEmpty, isTrue);
      expect(devotional.reflection.isNotEmpty, isTrue);
      expect(devotional.prayer.isNotEmpty, isTrue);
      expect(devotional.practicalAction.isNotEmpty, isTrue);
    });

    test('serializes and deserializes DevotionalModel correctly', () {
      final original = DevotionalModel(
        id: 'test-1',
        date: DateTime(2026, 1, 1),
        title: 'Fé Inabalável',
        theme: 'Fé',
        scriptureReference: 'Hebreus 11:1',
        scriptureText: 'Ora, a fé é a certeza...',
        reflection: 'Reflexão sobre a fé...',
        prayer: 'Senhor, aumenta a nossa fé...',
        practicalAction: 'Dê um passo de fé hoje.',
      );

      final json = original.toJson();
      final recovered = DevotionalModel.fromJson(json);

      expect(recovered.id, equals(original.id));
      expect(recovered.title, equals(original.title));
      expect(recovered.scriptureReference, equals(original.scriptureReference));
    });
  });

  group('DevotionalController', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('loads today devotional and handles streak increment', () async {
      final controller = DevotionalController.instance;
      await controller.load();

      expect(controller.todayDevotional, isNotNull);
      expect(controller.streakCount, equals(0));
      expect(controller.isCompletedToday, isFalse);

      final success = await controller.markCompletedToday();
      expect(success, isTrue);
      expect(controller.isCompletedToday, isTrue);
      expect(controller.streakCount, equals(1));

      // Marking again today maintains same streak
      await controller.markCompletedToday();
      expect(controller.streakCount, equals(1));
    });
  });
}
