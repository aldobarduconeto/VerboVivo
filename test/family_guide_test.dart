import 'package:flutter_test/flutter_test.dart';
import 'package:verbo_vivo/services/family_guide_service.dart';

void main() {
  group('FamilyGuideService', () {
    const service = FamilyGuideService();

    test('returns curated guide for The Chosen episode', () {
      final guide = service.getGuideForMedia('the-chosen-t1-e1');

      expect(guide, isNotNull);
      expect(guide!.seriesTitle, contains('The Chosen'));
      expect(guide.keyScriptureRef, equals('Isaías 43:1'));
      expect(guide.debateQuestions.length, equals(3));
      expect(guide.familyPrayer.isNotEmpty, isTrue);
      expect(guide.practicalChallenge.isNotEmpty, isTrue);
    });

    test('returns curated guide for Young David episode', () {
      final guide = service.getGuideForMedia('young-david-e1');

      expect(guide, isNotNull);
      expect(guide!.seriesTitle, contains('Young David'));
      expect(guide.keyScriptureRef, equals('1 Samuel 17:45'));
      expect(guide.debateQuestions.length, equals(3));
    });

    test('provides dynamic fallback guide for unknown production', () {
      final guide = service.getGuideForMedia('unknown-movie-123', title: 'Filme Inspirador');

      expect(guide, isNotNull);
      expect(guide!.title, equals('Filme Inspirador'));
      expect(guide.keyScriptureRef, equals('Filipenses 4:8'));
      expect(guide.debateQuestions.length, equals(3));
    });

    test('provides catalog of worship songs with lyrics for ambient cult display', () {
      final songs = service.getWorshipCatalog();

      expect(songs.isNotEmpty, isTrue);
      expect(songs.length, greaterThanOrEqualTo(3));
      for (final song in songs) {
        expect(song.title.isNotEmpty, isTrue);
        expect(song.artist.isNotEmpty, isTrue);
        expect(song.lyricsSnippet.isNotEmpty, isTrue);
        expect(song.scriptureConnection.isNotEmpty, isTrue);
      }
    });
  });
}
