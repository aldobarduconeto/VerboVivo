import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Escopo que captura eventos globais de controle remoto de TV e Gamepad,
/// permitindo atalhos como troca de abas (L1/R1), voltar (B/Esc), pesquisa (X) e modo TV (Y).
class TvRemoteScope extends StatelessWidget {
  const TvRemoteScope({
    super.key,
    required this.child,
    this.onNextTab,
    this.onPrevTab,
    this.onBack,
    this.onSearchRequested,
    this.onToggleTvMode,
  });

  final Widget child;
  final VoidCallback? onNextTab;
  final VoidCallback? onPrevTab;
  final VoidCallback? onBack;
  final VoidCallback? onSearchRequested;
  final VoidCallback? onToggleTvMode;

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Troca de abas com L1/R1, L2/R2 ou PageUp/PageDown
    if (key == LogicalKeyboardKey.gameButtonRight1 ||
        key == LogicalKeyboardKey.gameButtonRight2 ||
        key == LogicalKeyboardKey.pageDown) {
      if (onNextTab != null) {
        onNextTab!();
        return KeyEventResult.handled;
      }
    } else if (key == LogicalKeyboardKey.gameButtonLeft1 ||
        key == LogicalKeyboardKey.gameButtonLeft2 ||
        key == LogicalKeyboardKey.pageUp) {
      if (onPrevTab != null) {
        onPrevTab!();
        return KeyEventResult.handled;
      }
    }

    // Botão Voltar (B do Gamepad, Esc, Backspace, Navegador Back)
    if (key == LogicalKeyboardKey.gameButtonB ||
        key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.browserBack ||
        key == LogicalKeyboardKey.goBack) {
      if (onBack != null) {
        onBack!();
        return KeyEventResult.handled;
      }
    }

    // Botão de Pesquisa (X do Gamepad ou tecla F3)
    if (key == LogicalKeyboardKey.gameButtonX ||
        key == LogicalKeyboardKey.f3) {
      if (onSearchRequested != null) {
        onSearchRequested!();
        return KeyEventResult.handled;
      }
    }

    // Botão de Alternar Modo TV (Y do Gamepad ou tecla F4)
    if (key == LogicalKeyboardKey.gameButtonY ||
        key == LogicalKeyboardKey.f4) {
      if (onToggleTvMode != null) {
        onToggleTvMode!();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: Focus(
        autofocus: true,
        canRequestFocus: false,
        onKeyEvent: _handleKeyEvent,
        child: child,
      ),
    );
  }
}
