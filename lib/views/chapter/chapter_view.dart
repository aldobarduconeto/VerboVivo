import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/ambient_audio_controller.dart';
import '../../controllers/chapter_controller.dart';
import '../../controllers/journal_controller.dart';
import '../../controllers/reading_library_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/bible_model.dart';
import '../../services/app_localizations.dart';
import '../../services/bible_service.dart' show BibleService;
import '../ambient/ambient_sound_sheet.dart';
import '../verse_studio/verse_studio_sheet.dart';

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
  final _library = ReadingLibraryController.instance;
  final _journal = JournalController.instance;
  Future<BibleChapter>? _observedChapter;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        ChapterController(
          initialReference: widget.reference,
          initialTranslation: widget.preferredTranslation ?? _settings.bibleTranslation,
          initialFontSize: _settings.fontSize,
        );
    _controller.addListener(_observeChapter);
    _observeChapter();
  }

  @override
  void dispose() {
    _controller.removeListener(_observeChapter);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _observeChapter() {
    final request = _controller.chapterFuture;
    if (request == null || identical(request, _observedChapter)) return;
    _observedChapter = request;
    final reference = BibleService.normalizeReference(
      _controller.currentReference,
    );
    if (reference == null) return;

    unawaited(request.then<void>((_) {
      if (mounted && identical(request, _observedChapter)) {
        unawaited(_library.recordReading(reference));
      }
    }, onError: (Object _, StackTrace __) {}));
  }

  Future<void> _toggleBookmark(String reference, AppStrings strings) async {
    final saved = await _library.toggleBookmark(reference);
    if (mounted && !saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.bookmarkSaveError)),
      );
    }
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

  void _showVerseActionSheet(BibleVerse verse, String chapterTitle) {
    final colors = Theme.of(context).colorScheme;
    final verseRef = '$chapterTitle:${verse.number}';
    final existing = _journal.getHighlight(chapterTitle, verse.number);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  verseRef,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.primary,
                  ),
                ),
                Text(
                  '${_controller.currentTranslation}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '“${verse.text}”',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Destacar com Cor Temática:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorHighlightButton('gold', Colors.amber, 'Promessa', chapterTitle, verse),
                _buildColorHighlightButton('green', Colors.green, 'Gratidão', chapterTitle, verse),
                _buildColorHighlightButton('blue', Colors.blue, 'Esperança', chapterTitle, verse),
                _buildColorHighlightButton('rose', Colors.pinkAccent, 'Sabedoria', chapterTitle, verse),
                if (existing != null)
                  IconButton.filledTonal(
                    tooltip: 'Remover destaque',
                    onPressed: () {
                      _journal.removeHighlight(chapterTitle, verse.number);
                      Navigator.of(sheetContext).pop();
                    },
                    icon: const Icon(Icons.format_color_reset_rounded, size: 20),
                  ),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      VerseStudioSheet.show(
                        context,
                        reference: verseRef,
                        text: verse.text,
                      );
                    },
                    icon: const Icon(Icons.palette_outlined, size: 18),
                    label: const Text('Criar Card'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      _showAddToPrayerDialog(verse, chapterTitle);
                    },
                    icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
                    label: const Text('Orar por Isso'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                _copyVerse(verse, chapterTitle);
              },
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: const Text('Copiar Versículo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorHighlightButton(
    String key,
    Color color,
    String label,
    String chapterTitle,
    BibleVerse verse,
  ) {
    final existing = _journal.getHighlight(chapterTitle, verse.number);
    final isSelected = existing?.colorKey == key;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _journal.setHighlight(
              chapterReference: chapterTitle,
              verseNumber: verse.number,
              reference: '$chapterTitle:${verse.number}',
              text: verse.text,
              colorKey: key,
            );
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  void _showAddToPrayerDialog(BibleVerse verse, String chapterTitle) {
    final titleController = TextEditingController(text: 'Meditação em $chapterTitle:${verse.number}');
    final descController = TextEditingController(text: '“${verse.text}”\n\nSenhor, ');

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Adicionar ao Diário de Oração'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Motivo da Oração'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Minha Oração'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              await _journal.addPrayer(
                title: titleController.text,
                description: descController.text,
                scriptureReference: '$chapterTitle:${verse.number}',
              );
              if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pedido adicionado ao Mural de Oração! 🙏'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Salvar Oração'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller,
        _library,
        _journal,
        AmbientAudioController.instance,
      ]),
      builder: (context, _) {
        final strings = AppLocalizations.of(_settings.language);
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final prev = _controller.previousChapter;
        final next = _controller.nextChapter;
        final reference = BibleService.normalizeReference(
          _controller.currentReference,
        );
        final bookmarked = _library.bookmarks.contains(reference);
        final isAmbientPlaying = AmbientAudioController.instance.isPlaying;

        return Scaffold(
          appBar: AppBar(
            title: Text(_controller.currentReference,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                tooltip: 'Áudio Ambiente & Meditação',
                icon: Icon(
                  isAmbientPlaying
                      ? Icons.headphones_rounded
                      : Icons.headphones_outlined,
                  color: isAmbientPlaying ? colors.primary : null,
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AmbientSoundSheet(),
                  );
                },
              ),
              if (reference != null)
                IconButton(
                  tooltip: bookmarked
                      ? strings.removeChapterBookmark
                      : strings.saveChapterBookmark,
                  onPressed: () => _toggleBookmark(reference, strings),
                  icon: Icon(
                    bookmarked ? Icons.bookmark : Icons.bookmark_border,
                  ),
                ),
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
                          final highlight = _journal.getHighlight(chapter.reference, verse.number);
                          Color? highlightColor;
                          if (highlight != null) {
                            switch (highlight.colorKey) {
                              case 'gold':
                                highlightColor = Colors.amber;
                                break;
                              case 'green':
                                highlightColor = Colors.green;
                                break;
                              case 'blue':
                                highlightColor = Colors.blue;
                                break;
                              case 'rose':
                                highlightColor = Colors.pinkAccent;
                                break;
                            }
                          }

                          return InkWell(
                            onTap: () => _showVerseActionSheet(verse, chapter.reference),
                            onLongPress: () => _showVerseActionSheet(verse, chapter.reference),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              decoration: highlightColor != null
                                  ? BoxDecoration(
                                      color: highlightColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border(
                                        left: BorderSide(
                                          color: highlightColor,
                                          width: 3.5,
                                        ),
                                      ),
                                    )
                                  : null,
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
                                        color: highlightColor ?? colors.primary,
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
