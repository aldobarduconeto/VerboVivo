import 'package:flutter/material.dart';
import '../services/app_localizations.dart';

class ExploreIntro extends StatelessWidget {
  const ExploreIntro({
    super.key,
    required this.topic,
    required this.description,
    required this.onOpenLink,
    required this.onDraw,
    required this.onExplore,
    this.strings,
  });

  final String? topic;
  final String? description;
  final VoidCallback onOpenLink, onDraw;
  final VoidCallback? onExplore;
  final AppStrings? strings;

  @override
  Widget build(BuildContext context) {
    final s = strings ?? AppLocalizations.pt;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 680;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 13, color: colors.primary),
                  const SizedBox(width: 6),
                  Text(
                    topic == null ? 'BEM-VINDO AO VERBOVIVO' : 'TEMA EM DESTAQUE',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              topic ?? s.studyWelcomeTitle,
              style: (wide
                      ? theme.textTheme.headlineMedium
                      : theme.textTheme.titleLarge)
                  ?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description ?? s.studyWelcomeDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onExplore ?? onDraw,
                  icon: Icon(
                    onExplore == null
                        ? Icons.shuffle_rounded
                        : Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                  label: Text(
                    onExplore != null
                        ? s.exploreTopic
                        : topic == null
                            ? s.drawTopic
                            : s.drawAnotherTopic,
                  ),
                ),
                if (onExplore != null)
                  OutlinedButton.icon(
                    onPressed: onDraw,
                    icon: const Icon(Icons.shuffle_rounded, size: 18),
                    label: Text(s.drawAnotherTopic),
                  ),
                TextButton.icon(
                  onPressed: onOpenLink,
                  icon: const Icon(Icons.link_rounded, size: 18),
                  label: Text(s.playByLink),
                ),
              ],
            ),
          ],
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(wide ? 32 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.surfaceContainerLow,
                colors.primaryContainer.withValues(alpha: isDark ? 0.35 : 0.22),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: isDark ? 0.16 : 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: isDark ? 0.05 : 0.04),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: wide
              ? Row(
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 32),
                    ExcludeSemantics(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.auto_stories_rounded,
                            size: 60,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : content,
        );
      },
    );
  }
}
