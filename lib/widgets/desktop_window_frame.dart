import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

bool get isDesktopWindow =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows =>
        true,
      _ => false,
    };

class DesktopWindowFrame extends StatelessWidget {
  const DesktopWindowFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VirtualWindowFrame(
        child: Material(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          WindowCaption(
            brightness: theme.brightness,
            backgroundColor: theme.colorScheme.surface,
            title: Text('VerboVivo', style: theme.textTheme.labelLarge),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          Expanded(child: child),
        ],
      ),
    ));
  }
}
