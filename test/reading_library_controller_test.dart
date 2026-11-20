import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbo_vivo/controllers/reading_library_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'keeps the previous chapter and persists recent chapters without duplicates',
      () async {
    SharedPreferences.setMockInitialValues({
      'reading_last_chapter': 'Gênesis 1',
      'reading_bookmarks': ['Salmos 23'],
    });
    final library = ReadingLibraryController.instance;
    await library.load();

    expect(library.history, ['Gênesis 1']);
    expect(await library.recordReading('Gênesis 2'), isTrue);
    expect(await library.recordReading('Gênesis 1'), isTrue);
    await library.load();

    expect(library.lastRead, 'Gênesis 1');
    expect(library.history, ['Gênesis 1', 'Gênesis 2']);
    expect(library.bookmarks, ['Salmos 23']);

    for (var chapter = 3; chapter <= 32; chapter++) {
      expect(await library.recordReading('Gênesis $chapter'), isTrue);
    }
    await library.load();

    expect(library.history, hasLength(30));
    expect(library.lastRead, 'Gênesis 32');
    expect(library.history.last, 'Gênesis 3');
  });
}
