class FamilyGuideItem {
  const FamilyGuideItem({
    required this.mediaId,
    required this.title,
    required this.seriesTitle,
    required this.keyScriptureRef,
    required this.keyScriptureText,
    required this.debateQuestions,
    required this.familyPrayer,
    required this.practicalChallenge,
  });

  final String mediaId;
  final String title;
  final String seriesTitle;
  final String keyScriptureRef;
  final String keyScriptureText;
  final List<String> debateQuestions;
  final String familyPrayer;
  final String practicalChallenge;
}

class WorshipSongItem {
  const WorshipSongItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.lyricsSnippet,
    required this.scriptureConnection,
    this.streamId,
  });

  final String id;
  final String title;
  final String artist;
  final String duration;
  final String lyricsSnippet;
  final String scriptureConnection;
  final String? streamId;
}
