import 'package:flutter/material.dart';

import '../../models/family_guide_model.dart';
import '../../services/family_guide_service.dart';
import '../../widgets/tv_focusable.dart';
import '../chapter/chapter_view.dart';

class FamilyGuideDialog extends StatelessWidget {
  const FamilyGuideDialog({
    super.key,
    required this.guide,
  });

  final FamilyGuideItem guide;

  static void show(BuildContext context, {required String mediaId, String? title}) {
    const service = FamilyGuideService();
    final guide = service.getGuideForMedia(mediaId, title: title);
    if (guide == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FamilyGuideDialog(guide: guide),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * 0.92),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(22, 16, 22, media.viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.3)),
                ),
                child: const Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Momento Família & Célula',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.amber.shade300 : Colors.amber.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      guide.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      guide.seriesTitle,
                      style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Body Content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Scripture card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.menu_book_rounded, size: 18, color: colors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  guide.keyScriptureRef,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChapterView(reference: guide.keyScriptureRef),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.open_in_new_rounded, size: 15),
                              label: const Text('Ler Capítulo'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '“${guide.keyScriptureText}”',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3 Questions Section
                  Row(
                    children: [
                      Icon(Icons.question_answer_rounded, size: 18, color: colors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        '3 Perguntas para Conversar em Família',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(guide.debateQuestions.length, (i) {
                    final q = guide.debateQuestions[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.45,
                                color: colors.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),

                  // Family Prayer Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🙏 ', style: TextStyle(fontSize: 16)),
                            Text(
                              'Oração Conjunta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          guide.familyPrayer,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Weekly Family Challenge
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.flag_rounded, size: 20, color: colors.secondary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Desafio da Semana',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: colors.secondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                guide.practicalChallenge,
                                style: TextStyle(fontSize: 13, color: colors.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Action
          TvFocusable(
            onPressed: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(14),
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Concluir Momento em Família'),
            ),
          ),
        ],
      ),
    );
  }
}
