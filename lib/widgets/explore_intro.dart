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

    return Container(
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
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            onPressed: onOpenLink,
            icon: const Icon(Icons.link_rounded, size: 18),
            label: Text(s.playByLink),
          ),
        ]),
      ]),
    );
  }
}
