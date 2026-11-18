import 'package:flutter/material.dart';

import '../../controllers/devotional_controller.dart';
import '../../models/devotional_model.dart';
import '../chapter/chapter_view.dart';
import '../verse_studio/verse_studio_sheet.dart';

class DevotionalDialog extends StatelessWidget {
  const DevotionalDialog({
    super.key,
    required this.devotional,
    required this.controller,
  });

  final DevotionalModel devotional;
  final DevotionalController controller;

  static void show(BuildContext context, {required DevotionalModel devotional, required DevotionalController controller}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DevotionalDialog(
        devotional: devotional,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isDone = controller.isCompletedToday;
        final streak = controller.streakCount;

        return Container(
          constraints: BoxConstraints(maxHeight: media.size.height * 0.92),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, media.viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.wb_sunny_rounded, color: colors.onPrimaryContainer, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Devocional Diário',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (streak > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🔥 ', style: TextStyle(fontSize: 10)),
                                    Text(
                                      '$streak ${streak == 1 ? "dia" : "dias"}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Text(
                          devotional.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

              // Content Area
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Scripture Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.format_quote_rounded, size: 20, color: colors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      devotional.scriptureReference,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.primary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      iconSize: 18,
                                      visualDensity: VisualDensity.compact,
                                      tooltip: 'Criar Card de Fé',
                                      icon: const Icon(Icons.palette_outlined),
                                      onPressed: () {
                                        VerseStudioSheet.show(
                                          context,
                                          reference: devotional.scriptureReference,
                                          text: devotional.scriptureText,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      iconSize: 18,
                                      visualDensity: VisualDensity.compact,
                                      tooltip: 'Ler capítulo completo',
                                      icon: const Icon(Icons.open_in_new_rounded),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChapterView(
                                              reference: devotional.scriptureReference,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              devotional.scriptureText,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.55,
                                fontStyle: FontStyle.italic,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Reflection Section
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, size: 18, color: colors.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'Meditação do Dia',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        devotional.reflection,
                        style: TextStyle(fontSize: 14, height: 1.6, color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 18),

                      // Prayer Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.volunteer_activism_rounded, size: 16, color: colors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'Oração',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              devotional.prayer,
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Practical Action Step
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.checklist_rounded, size: 20, color: colors.secondary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Aplicação Prática',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: colors.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    devotional.practicalAction,
                                    style: TextStyle(fontSize: 13, color: colors.onSurface),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        VerseStudioSheet.show(
                          context,
                          reference: devotional.scriptureReference,
                          text: devotional.scriptureText,
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Criar Card'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: isDone ? Colors.green.shade700 : null,
                      ),
                      onPressed: () async {
                        final ok = await controller.markCompletedToday();
                        if (context.mounted && ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isDone
                                    ? 'Devocional de hoje já registrado!'
                                    : 'Parabéns! Devocional concluído hoje 🔥 (${controller.streakCount} dias)',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: Icon(isDone ? Icons.check_circle_rounded : Icons.check_rounded, size: 18),
                      label: Text(isDone ? 'Concluído Hoje' : 'Marcar Concluído'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
