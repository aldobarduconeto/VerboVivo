class AmbientTrack {
  const AmbientTrack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioUrl,
    required this.iconName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String audioUrl;
  final String iconName; // 'harp', 'rain', 'piano', 'breeze', 'pad'
}
