import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/chapter_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/bible_model.dart';
import '../../services/app_localizations.dart';

class ChapterView extends StatefulWidget {
  const ChapterView({
    super.key,
    required this.reference,
    this.preferredTranslation,
    this.controller,
  });

  final String reference;
  final String? preferredTranslation;
  final ChapterController? controller;

  @override
  State<ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends State<ChapterView> {
  late final ChapterController _controller;
  final _settings = SettingsController.instance;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        ChapterController(
          initialReference: widget.reference,
          initialTranslation: widget.preferredTranslation ?? _settings.bibleTranslation,
          initialFontSize: _settings.fontSize,
        );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _copyVerse(BibleVerse verse, String chapterTitle) {
    final strings = AppLocalizations.of(_settings.language);
    final textToCopy = '"${verse.text}" ($chapterTitle:${verse.number})';
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.verseCopied),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyFullChapter(BibleChapter chapter) {
    final strings = AppLocalizations.of(_settings.language);
    final buffer = StringBuffer('${chapter.reference} (${chapter.translation})\n\n');
    for (final v in chapter.verses) {
      buffer.writeln('${v.number}. ${v.text}');
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.chapterCopied),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final strings = AppLocalizations.of(_settings.language);
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final prev = _controller.previousChapter;
        final next = _controller.nextChapter;

        return Scaffold(
          appBar: AppBar(
            title: Text(_controller.currentReference,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              PopupMenuButton<String>(
                tooltip: strings.preferredTranslation,
                icon: const Icon(Icons.translate_rounded),
                initialValue: _controller.currentTranslation,
                onSelected: _controller.setTranslation,
                itemBuilder: (ctx) => const [
                  PopupMenuItem(
                    value: 'ACF11',
                    child: Text('Almeida Corrigida Fiel (ACF)'),
                  ),
                  PopupMenuItem(
                    value: 'ARA',
                    child: Text('Almeida Revista e Atualizada (ARA)'),
                  ),
                  PopupMenuItem(
                    value: 'ARC09',
                    child: Text('Almeida Revista e Corrigida (ARC)'),
                  ),
                  PopupMenuItem(
                    value: 'WEB',
                    child: Text('World English Bible (WEB)'),
                  ),
                ],
              ),
              IconButton.filledTonal(
                tooltip: 'Diminuir fonte',
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _controller.decreaseFontSize,
                icon: const Icon(Icons.text_decrease_rounded, size: 18),
              ),
              const SizedBox(width: 4),
              IconButton.filledTonal(
                tooltip: 'Aumentar fonte',
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _controller.increaseFontSize,
                icon: const Icon(Icons.text_increase_rounded, size: 18),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: FutureBuilder<BibleChapter>(
            future: _controller.chapterFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Carregando ${_controller.currentReference}...',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 48, color: colors.error),
                        const SizedBox(height: 16),
                        Text(
                          strings.loadError,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _controller.load,
                          icon: const Icon(Icons.refresh),
                          label: Text(strings.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final chapter = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                      children: [
                        // Header do capítulo
                        Card(
                          elevation: 0,
                          color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chapter.reference,
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.verified_outlined,
                                              size: 14, color: colors.primary),
                                          const SizedBox(width: 4),
                                          Text(
                                            chapter.translation,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: colors.onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton.outlined(
                                  tooltip: 'Copiar capítulo completo',
                                  onPressed: () => _copyFullChapter(chapter),
                                  icon: const Icon(Icons.copy_rounded, size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Lista de versículos
                        ...chapter.verses.map((verse) {
                          return InkWell(
                            onLongPress: () => _copyVerse(verse, chapter.reference),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 34,
                                    padding: const EdgeInsets.only(top: 2),
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      '${verse.number}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: (_controller.fontSize * 0.78).clamp(11, 20),
                                        color: colors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      verse.text,
                                      style: TextStyle(
                                        fontSize: _controller.fontSize,
                                        height: 1.68,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // Barra de navegação inferior estilo floating bar
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.25),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (prev != null)
                          FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () => _controller.goTo(prev),
                            icon: const Icon(Icons.chevron_left_rounded, size: 18),
                            label: Text(prev),
                          )
                        else
                          const SizedBox.shrink(),
                        if (next != null)
                          FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () => _controller.goTo(next),
                            label: Text(next),
                            icon: const Icon(Icons.chevron_right_rounded, size: 18),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

// Backwards compatibility alias
typedef ChapterScreen = ChapterView;
