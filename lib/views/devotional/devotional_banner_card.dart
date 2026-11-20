import 'package:flutter/material.dart';

import '../../controllers/devotional_controller.dart';
import '../../widgets/tv_focusable.dart';
import 'devotional_dialog.dart';
import '../verse_studio/verse_studio_sheet.dart';

class DevotionalBannerCard extends StatelessWidget {
  const DevotionalBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DevotionalController.instance;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final devotional = controller.todayDevotional;
        final streak = controller.streakCount;
        final isDone = controller.isCompletedToday;

        return TvFocusable(
          onPressed: () => DevotionalDialog.show(
            context,
            devotional: devotional,
            controller: controller,
          ),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surfaceContainerLow,
                  colors.primaryContainer.withValues(alpha: isDark ? 0.3 : 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colors.primary.withValues(alpha: isDark ? 0.22 : 0.28),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: isDark ? 0.04 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Tag & Streak flame
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny_rounded, size: 13, color: colors.onPrimary),
                          const SizedBox(width: 5),
                          Text(
                            'Devocional de Hoje',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (streak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: isDark ? 0.15 : 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (isDark ? Colors.amber.shade300 : Colors.amber.shade700)
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥 ', style: TextStyle(fontSize: 11)),
                            Text(
                              '$streak ${streak == 1 ? "dia" : "dias"}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isDone)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: isDark ? 0.2 : 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Concluído',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title & scripture
                Text(
                  devotional.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '“${devotional.scriptureText}”',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  devotional.scriptureReference,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => DevotionalDialog.show(
                        context,
                        devotional: devotional,
                        controller: controller,
                      ),
                      icon: const Icon(Icons.menu_book_rounded, size: 16),
                      label: const Text('Meditar Agora'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        VerseStudioSheet.show(
                          context,
                          reference: devotional.scriptureReference,
                          text: devotional.scriptureText,
                        );
                      },
                      icon: const Icon(Icons.palette_outlined, size: 16),
                      label: const Text('Criar Card'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
