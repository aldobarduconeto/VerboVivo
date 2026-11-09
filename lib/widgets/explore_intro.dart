import 'package:flutter/material.dart';
import '../services/app_localizations.dart';

class ExploreIntro extends StatelessWidget {
  const ExploreIntro({
    super.key,
    required this.topic,
    required this.description,
    required this.controller,
    required this.onSearch,
    required this.onOpenLink,
    required this.onDraw,
    required this.onExplore,
    this.focusNode,
    this.strings,
  });

  final String? topic;
  final String? description;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSearch, onOpenLink, onDraw;
  final VoidCallback? onExplore;
  final AppStrings? strings;

  @override
  Widget build(BuildContext context) {
    final s = strings ?? AppLocalizations.pt;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final hero = Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F3830), Color(0xFF07211B)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF4CA83).withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF4CA83).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFF4CA83).withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_stories_rounded, color: Color(0xFFF4CA83), size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  s.reflectionMoments,
                  style: const TextStyle(
                    color: Color(0xFFF4CA83),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          topic ?? (s == AppLocalizations.en ? 'A fresh look at the Word' : 'Um novo olhar para a Palavra'),
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description ??
              (s == AppLocalizations.en
                  ? 'Find a biblical theme to study, listen to and reflect upon.'
                  : 'Encontre um tema bíblico para estudar, ouvir e refletir.'),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFDBEEE6),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(spacing: 12, runSpacing: 12, children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF4CA83),
              foregroundColor: const Color(0xFF1E301F),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: onDraw,
            icon: const Icon(Icons.shuffle_rounded, size: 18),
            label: Text(topic == null ? s.drawTopic : s.drawAnotherTopic),
          ),
          if (onExplore != null)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0x80FFFFFF), width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: onExplore,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(s.exploreTopic),
            ),
        ]),
      ]),
    );

    final search = Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.travel_explore_rounded, color: colors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.searchTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      s.searchSubtitle,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLength: 280,
            maxLines: null,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 22),
              labelText: s.searchFieldLabel,
              hintText: s.searchFieldHint,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded, size: 18),
              label: Text(s.searchButton),
            ),
            OutlinedButton.icon(
              onPressed: onOpenLink,
              icon: const Icon(Icons.link_rounded, size: 18),
              label: Text(s.playByLink),
            ),
          ]),
        ]),
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 820) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            hero,
            const SizedBox(height: 16),
            search,
          ],
        );
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 5, child: hero),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: search),
      ]);
    });
  }
}
