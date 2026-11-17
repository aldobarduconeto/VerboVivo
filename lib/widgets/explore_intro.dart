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

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 680;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic ?? s.studyWelcomeTitle,
              style: (wide
                      ? theme.textTheme.displaySmall
                      : theme.textTheme.headlineMedium)
                  ?.copyWith(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w800,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description ?? s.studyWelcomeDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onPrimaryContainer,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: onExplore ?? onDraw,
                  icon: Icon(
                    onExplore == null
                        ? Icons.shuffle_rounded
                        : Icons.arrow_forward_rounded,
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
                    icon: const Icon(Icons.shuffle_rounded),
                    label: Text(s.drawAnotherTopic),
                  ),
                TextButton.icon(
                  onPressed: onOpenLink,
                  icon: const Icon(Icons.link_rounded),
                  label: Text(s.playByLink),
                ),
              ],
            ),
          ],
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(wide ? 36 : 22),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: wide
              ? Row(
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 32),
                    ExcludeSemantics(
                      child: Container(
                        width: 144,
                        height: 144,
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Icon(
                          Icons.auto_stories_outlined,
                          size: 68,
                          color: colors.onPrimaryContainer,
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
