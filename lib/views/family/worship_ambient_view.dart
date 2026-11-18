import 'package:flutter/material.dart';

import '../../models/family_guide_model.dart';
import '../../services/family_guide_service.dart';
import '../../widgets/tv_focusable.dart';
import '../chapter/chapter_view.dart';

class WorshipAmbientView extends StatefulWidget {
  const WorshipAmbientView({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WorshipAmbientView()),
    );
  }

  @override
  State<WorshipAmbientView> createState() => _WorshipAmbientViewState();
}

class _WorshipAmbientViewState extends State<WorshipAmbientView> {
  final _service = const FamilyGuideService();
  late List<WorshipSongItem> _songs;
  int _currentIndex = 0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _songs = _service.getWorshipCatalog();
  }

  void _nextSong() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
    });
  }

  void _prevSong() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final song = _songs[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F14),
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient glowing gradient background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 1.2,
                    colors: [
                      const Color(0xFF1B382B).withValues(alpha: 0.6),
                      const Color(0xFF091410).withValues(alpha: 0.95),
                      const Color(0xFF060A0D),
                    ],
                  ),
                ),
              ),
            ),

            // Top Bar
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TvFocusable(
                    onPressed: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4CA83).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF4CA83).withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tv_rounded, size: 14, color: Color(0xFFF4CA83)),
                        SizedBox(width: 6),
                        Text(
                          'Modo Culto Doméstico • Telão de Louvor',
                          style: TextStyle(
                            color: Color(0xFFF4CA83),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen_rounded, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Central Lyrics & Praise Section
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 80, 28, 120),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Music icon emblem
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF4CA83).withValues(alpha: 0.15),
                        border: Border.all(color: const Color(0xFFF4CA83).withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.music_note_rounded, size: 28, color: Color(0xFFF4CA83)),
                    ),
                    const SizedBox(height: 16),

                    // Song title & artist
                    Text(
                      song.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Lyrics Box
                    Container(
                      constraints: const BoxConstraints(maxWidth: 680),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: Text(
                        song.lyricsSnippet,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFE8F0E9),
                          fontSize: 21,
                          height: 1.8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Biblical Anchor Button
                    TvFocusable(
                      onPressed: () {
                        final firstRef = song.scriptureConnection.split('•').first.trim();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ChapterView(reference: firstRef)),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4CA83).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF4CA83).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_stories_rounded, size: 16, color: Color(0xFFF4CA83)),
                            const SizedBox(width: 8),
                            Text(
                              song.scriptureConnection,
                              style: const TextStyle(
                                color: Color(0xFFF4CA83),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Controls
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TvFocusable(
                        onPressed: _prevSong,
                        child: IconButton(
                          icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 28),
                          onPressed: _prevSong,
                        ),
                      ),
                      TvFocusable(
                        onPressed: () => setState(() => _isPlaying = !_isPlaying),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF4CA83),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: const Color(0xFF091410),
                              size: 32,
                            ),
                            onPressed: () => setState(() => _isPlaying = !_isPlaying),
                          ),
                        ),
                      ),
                      TvFocusable(
                        onPressed: _nextSong,
                        child: IconButton(
                          icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 28),
                          onPressed: _nextSong,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
