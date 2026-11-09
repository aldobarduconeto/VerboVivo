import 'media_model.dart';

class AngelMediaItem {
  const AngelMediaItem({
    required this.id,
    required this.title,
    required this.seriesTitle,
    required this.category,
    required this.description,
    required this.thumbnail,
    required this.duration,
    required this.webUrl,
    this.streamId,
    this.badge = '100% Grátis Sem Login',
    this.ageRating = 'Livre',
    this.episodeNumber,
    this.seasonNumber,
  });

  final String id;
  final String title;
  final String seriesTitle;
  final String category;
  final String description;
  final String thumbnail;
  final String duration;
  final String webUrl;
  final String? streamId;
  final String badge;
  final String ageRating;
  final int? episodeNumber;
  final int? seasonNumber;

  String get effectiveThumbnail {
    if (thumbnail.isNotEmpty && !thumbnail.contains('upload/v1/')) {
      return thumbnail;
    }
    if (streamId != null && streamId!.length == 11) {
      return 'https://i.ytimg.com/vi/$streamId/hqdefault.jpg';
    }
    return thumbnail;
  }

  VideoItem toVideoItem() {
    return VideoItem(
      id: streamId ?? id,
      title: '$seriesTitle: $title',
      channel: 'Angel Studios (angel.com/pt-BR)',
      thumbnail: effectiveThumbnail,
      webUrl: webUrl,
      description: description,
    );
  }
}
