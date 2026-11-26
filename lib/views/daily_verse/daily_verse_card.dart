import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/journal_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/daily_verse_model.dart';
import '../../models/bible_model.dart';
import '../../widgets/tv_focusable.dart';
import '../chapter/chapter_view.dart';
import '../verse_studio/verse_studio_sheet.dart';

class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({
    super.key,
    required this.verse,
  });

  final DailyVerse verse;

  void _openChapter(BuildContext context) {
    final settings = SettingsController.instance;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterView(
          reference: verse.chapterReference,
          preferredTranslation: settings.bibleTranslation,
        ),
      ),
    );
  }

  void _openVerseStudio(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VerseStudioSheet(
        verse: BibleVerse(verse.verseNumber, verse.verseText),
        chapterReference: verse.chapterReference,
      ),
    );
  }

  void _copyVerse(BuildContext context) {
    final textToCopy = '"${verse.verseText}" (${verse.reference})';
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Versículo do dia copiado com sucesso!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveHighlight(BuildContext context) async {
    final saved = await JournalController.instance.setHighlight(
      chapterReference: verse.chapterReference,
      verseNumber: verse.verseNumber,
      reference: verse.reference,
      text: verse.verseText,
      colorKey: 'gold',
      note: 'Destaque do Versículo do Dia',
    );

    if (context.mounted && saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Versículo salvo no seu Diário Espiritual! 🌟'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colors.primary.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.08),
              colors.surfaceContainerHighest.withValues(alpha: 0.35),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Tag do dia & Tema
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        size: 16,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'VERSÍCULO DO DIA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    verse.theme,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Texto do Versículo
            Text(
              '“${verse.verseText}”',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.45,
                fontSize: 17,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),

            // Referência
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '— ${verse.reference}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Reflexão curta
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 18,
                    color: colors.outline,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      verse.reflection,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ações Rápidas
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TvFocusable(
                  onPressed: () => _openChapter(context),
                  child: FilledButton.tonalIcon(
                    onPressed: () => _openChapter(context),
                    icon: const Icon(Icons.auto_stories_rounded, size: 16),
                    label: const Text('Ler Capítulo', style: TextStyle(fontSize: 12)),
                  ),
                ),
                TvFocusable(
                  onPressed: () => _openVerseStudio(context),
                  child: OutlinedButton.icon(
                    onPressed: () => _openVerseStudio(context),
                    icon: const Icon(Icons.palette_outlined, size: 16),
                    label: const Text('Criar Imagem', style: TextStyle(fontSize: 12)),
                  ),
                ),
                TvFocusable(
                  onPressed: () => _copyVerse(context),
                  child: IconButton.outlined(
                    tooltip: 'Copiar citação',
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    onPressed: () => _copyVerse(context),
                  ),
                ),
                TvFocusable(
                  onPressed: () => _saveHighlight(context),
                  child: IconButton.outlined(
                    tooltip: 'Salvar nos Destaques',
                    icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                    onPressed: () => _saveHighlight(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
