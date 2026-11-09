import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/topic_model.dart';
import '../services/angel_service.dart';
import '../services/bible_service.dart';
import '../services/topic_recommendation_service.dart';
import '../services/youtube_service.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    TopicGenerator? generator,
    YouTubeService? youtubeService,
    PodcastService? podcastService,
    TopicRecommendationService? recommendations,
    AngelService? angelService,
  })  : _generator = generator ?? TopicGenerator(Random.secure()),
        _youtubeService = youtubeService ?? const YouTubeService(),
        _podcastService = podcastService ?? const PodcastService(),
        _recommendations = recommendations ?? const TopicRecommendationService(),
        _angelService = angelService ?? const AngelService();

  final TopicGenerator _generator;
  final YouTubeService _youtubeService;
  final PodcastService _podcastService;
  final TopicRecommendationService _recommendations;
  final AngelService _angelService;

  BibleTopic? _selectedTopic;
  bool _confirmed = false;
  bool _customTopic = false;
  int _currentTab = 0; // Sub-aba de Estudo Bíblico (0: Vídeos, 1: Louvores, 2: Bíblia, 3: Podcasts)
  int _mainTab = 0; // Aba principal adaptativa (0: Estudo Bíblico, 1: Bíblia Sagrada, 2: Angel Studios, 3: Configurações)
  String _selectedAngelCategory = 'Todos';
  String _angelSearchQuery = '';

  Future<List<VideoItem>>? _videosFuture;
  Future<List<VideoItem>>? _songsFuture;
  Future<List<PodcastItem>>? _podcastsFuture;

  // Getters
  BibleTopic? get selectedTopic => _selectedTopic;
  bool get confirmed => _confirmed;
  bool get customTopic => _customTopic;
  int get currentTab => _currentTab;
  int get mainTab => _mainTab;
  String get selectedAngelCategory => _selectedAngelCategory;
  String get angelSearchQuery => _angelSearchQuery;
  List<String> get angelCategories => AngelService.categories;

  Future<List<VideoItem>>? get videosFuture => _videosFuture;
  Future<List<VideoItem>>? get songsFuture => _songsFuture;
  Future<List<PodcastItem>>? get podcastsFuture => _podcastsFuture;

  Future<T> _observe<T>(Future<T> request) {
    unawaited(request.then<void>((_) {}, onError: (Object _, StackTrace __) {}));
    return request;
  }

  void drawTopic() {
    _selectedTopic = _generator.next(_selectedTopic);
    _customTopic = false;
    _confirmed = false;
    _currentTab = 0;
    _videosFuture = null;
    _songsFuture = null;
    _podcastsFuture = null;
    notifyListeners();
  }

  bool searchCustomTopic(String query) {
    final trimmed = query.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) return false;

    _selectedTopic = _recommendations.topicFor(trimmed);
    _customTopic = true;
    _confirmed = true;

    // Se o usuário buscou diretamente uma passagem ou livro bíblico e estava na aba de vídeos,
    // direciona para a aba de leitura bíblica para acesso imediato ao texto
    final isDirectBible = BibleService.parseReference(trimmed) != null ||
        BibleService.findBook(trimmed) != null;
    if (isDirectBible && _currentTab == 0) {
      _currentTab = 2;
    }

    _videosFuture = null;
    _songsFuture = null;
    _podcastsFuture = null;

    switch (_currentTab) {
      case 0:
        _loadVideos();
        break;
      case 1:
        _loadSongs();
        break;
      case 3:
        _loadPodcasts();
        break;
    }

    notifyListeners();
    return true;
  }

  void confirmTopic() {
    if (_selectedTopic == null) return;
    _confirmed = true;
    _currentTab = 0;
    _loadVideos();
    _songsFuture = null;
    _podcastsFuture = null;
    notifyListeners();
  }

  void setMainTab(int index) {
    final clamped = index.clamp(0, 3);
    if (_mainTab == clamped) return;
    _mainTab = clamped;
    if (_mainTab == 2) {
      _currentTab = 4;
    } else if (_mainTab == 1) {
      _currentTab = 2;
    } else if (_mainTab == 0 && _currentTab == 4) {
      _currentTab = 0;
    }
    notifyListeners();
  }

  void nextMainTab() {
    setMainTab((_mainTab + 1) % 4);
  }

  void previousMainTab() {
    setMainTab((_mainTab - 1 + 4) % 4);
  }

  void setAngelSearchQuery(String query) {
    if (_angelSearchQuery == query) return;
    _angelSearchQuery = query;
    notifyListeners();
  }

  void setTab(int index) {
    final clamped = index.clamp(0, 4);
    if (_currentTab == clamped) return;
    _currentTab = clamped;
    if (_currentTab == 4) {
      _mainTab = 2;
    } else {
      _mainTab = 0;
    }

    if (_currentTab == 0 && _videosFuture == null) {
      _loadVideos();
    } else if (_currentTab == 1 && _songsFuture == null) {
      _loadSongs();
    } else if (_currentTab == 3 && _podcastsFuture == null) {
      _loadPodcasts();
    }
    notifyListeners();
  }

  void nextTab() {
    setTab((_currentTab + 1) % 5);
  }

  void previousTab() {
    setTab((_currentTab - 1 + 5) % 5);
  }

  void setAngelCategory(String category) {
    if (_selectedAngelCategory == category) return;
    _selectedAngelCategory = category;
    notifyListeners();
  }

  List<AngelMediaItem> getAngelItems() {
    var items = _angelService.getByCategory(_selectedAngelCategory);
    if (_angelSearchQuery.trim().isNotEmpty) {
      final q = _angelSearchQuery.trim().toLowerCase();
      items = items.where((it) {
        return it.title.toLowerCase().contains(q) ||
            it.description.toLowerCase().contains(q) ||
            it.category.toLowerCase().contains(q) ||
            it.seriesTitle.toLowerCase().contains(q);
      }).toList();
    }
    return items;
  }

  AngelMediaItem get featuredAngelItem => _angelService.featured;

  void retryVideos() {
    _loadVideos();
    notifyListeners();
  }

  void retrySongs() {
    _loadSongs();
    notifyListeners();
  }

  void retryPodcasts() {
    _loadPodcasts();
    notifyListeners();
  }

  List<String> getReferences() {
    if (_selectedTopic == null) return const [];
    final t = _selectedTopic!;
    return _recommendations.referencesFor(
      t.title,
      suggested: [t.reference, ...t.queries],
    );
  }

  void _loadVideos() {
    if (_selectedTopic == null) return;
    _videosFuture = _observe(_youtubeService.search(_selectedTopic!.effectiveVideoQuery));
  }

  void _loadSongs() {
    if (_selectedTopic == null) return;
    _songsFuture = _observe(_youtubeService.search(_selectedTopic!.effectiveSongQuery));
  }

  void _loadPodcasts() {
    if (_selectedTopic == null) return;
    _podcastsFuture = _observe(_podcastService.search(_selectedTopic!.effectivePodcastQuery));
  }
}
