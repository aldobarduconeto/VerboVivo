import 'package:flutter/material.dart';

/// Shares the page scroll and lets cards grow with the user's text size.
class ResponsiveMediaGrid extends StatelessWidget {
  const ResponsiveMediaGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 16.0;
          final isWide = constraints.maxWidth >= 560;
          final columns = isWide
              ? ((constraints.maxWidth + spacing) / (300 + spacing))
                  .floor()
                  .clamp(2, 4)
              : 1;
          final cardWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final child in children)
                SizedBox(width: cardWidth, child: child),
            ],
          );
        },
      );
}
