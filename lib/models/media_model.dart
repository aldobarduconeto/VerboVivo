class VideoItem {
  const VideoItem({
    required this.id,
    required this.title,
    required this.channel,
    required this.thumbnail,
    this.webUrl,
    this.description,
  });

  final String id;
  final String title;
  final String channel;
  final String thumbnail;
  final String? webUrl;
  final String? description;
}

class PodcastItem {
  const PodcastItem({
    required this.title,
    required this.show,
    required this.audioUrl,
    required this.artwork,
    this.duration,
  });

  final String title;
  final String show;
  final String audioUrl;
  final String artwork;
  final Duration? duration;
}

class ResolvedVideo {
  const ResolvedVideo(this.video, {this.audio});

  final Uri video;
  final Uri? audio;
}

class SearchUnavailable implements Exception {
  const SearchUnavailable(this.message);
  final String message;

  @override
  String toString() => message;
}
