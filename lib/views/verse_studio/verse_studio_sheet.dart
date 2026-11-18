import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum StudioTheme {
  emerald,
  slate,
  dawn,
  parchment,
}

enum StudioFormat {
  story, // 9:16
  square, // 1:1
}

class VerseStudioSheet extends StatefulWidget {
  const VerseStudioSheet({
    super.key,
    required this.reference,
    required this.text,
  });

  final String reference;
  final String text;

  static void show(BuildContext context, {required String reference, required String text}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VerseStudioSheet(reference: reference, text: text),
    );
  }

  @override
  State<VerseStudioSheet> createState() => _VerseStudioSheetState();
}

class _VerseStudioSheetState extends State<VerseStudioSheet> {
  StudioTheme _theme = StudioTheme.emerald;
  StudioFormat _format = StudioFormat.story;
  bool _useSerif = true;
  double _fontSize = 20.0;

  void _copyToClipboard() {
    final text = '“${widget.text}”\n— ${widget.reference}\n\nCompartilhado via VerboVivo 📖✨';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Texto do versículo copiado com sucesso!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  BoxDecoration _getCardDecoration() {
    switch (_theme) {
      case StudioTheme.emerald:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F382C), Color(0xFF071B15)],
          ),
          border: Border.all(
            color: const Color(0xFFF4CA83).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        );
      case StudioTheme.slate:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E2631), Color(0xFF0E1318)],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        );
      case StudioTheme.dawn:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5C3317), Color(0xFF1F1007)],
          ),
          border: Border.all(
            color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        );
      case StudioTheme.parchment:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFF9F5EC),
          border: Border.all(
            color: const Color(0xFFD7CCC8),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        );
    }
  }

  Color _getTextColor() {
    switch (_theme) {
      case StudioTheme.emerald:
      case StudioTheme.slate:
      case StudioTheme.dawn:
        return Colors.white;
      case StudioTheme.parchment:
        return const Color(0xFF2C241E);
    }
  }

  Color _getAccentColor() {
    switch (_theme) {
      case StudioTheme.emerald:
        return const Color(0xFFF4CA83);
      case StudioTheme.slate:
        return const Color(0xFF90CAF9);
      case StudioTheme.dawn:
        return const Color(0xFFFFB74D);
      case StudioTheme.parchment:
        return const Color(0xFF8D6E63);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, media.viewInsets.bottom + 20),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.palette_rounded, color: colors.onPrimaryContainer, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estúdio de Cards de Fé',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                      'Gere um card inspirador para compartilhar',
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

          // Card Preview Area
          Flexible(
            child: Center(
              child: SingleChildScrollView(
                child: AspectRatio(
                  aspectRatio: _format == StudioFormat.story ? 9 / 14 : 1,
                  child: Container(
                    decoration: _getCardDecoration(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          size: 36,
                          color: _getAccentColor().withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 12),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Text(
                              widget.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _getTextColor(),
                                fontSize: _fontSize,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: _useSerif ? 'serif' : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getAccentColor().withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getAccentColor().withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.reference,
                            style: TextStyle(
                              color: _getAccentColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_stories_rounded, size: 14, color: _getTextColor().withValues(alpha: 0.6)),
                            const SizedBox(width: 6),
                            Text(
                              'VerboVivo',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                                color: _getTextColor().withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Formatting options: Theme Chips & Format Toggle
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Esmeralda'),
                  selected: _theme == StudioTheme.emerald,
                  onSelected: (s) {
                    if (s) setState(() => _theme = StudioTheme.emerald);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Ardósia'),
                  selected: _theme == StudioTheme.slate,
                  onSelected: (s) {
                    if (s) setState(() => _theme = StudioTheme.slate);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Amanhecer'),
                  selected: _theme == StudioTheme.dawn,
                  onSelected: (s) {
                    if (s) setState(() => _theme = StudioTheme.dawn);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Papiro'),
                  selected: _theme == StudioTheme.parchment,
                  onSelected: (s) {
                    if (s) setState(() => _theme = StudioTheme.parchment);
                  },
                ),
                const SizedBox(width: 12),
                IconButton.outlined(
                  tooltip: _format == StudioFormat.story ? 'Mudar para 1:1 Quadrado' : 'Mudar para 9:16 Stories',
                  icon: Icon(_format == StudioFormat.story ? Icons.crop_portrait_rounded : Icons.crop_square_rounded),
                  onPressed: () {
                    setState(() {
                      _format = _format == StudioFormat.story ? StudioFormat.square : StudioFormat.story;
                    });
                  },
                ),
                const SizedBox(width: 6),
                IconButton.outlined(
                  tooltip: _useSerif ? 'Usar fonte Sans' : 'Usar fonte Serif',
                  icon: const Icon(Icons.font_download_rounded),
                  onPressed: () {
                    setState(() => _useSerif = !_useSerif);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copiar Texto'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Compartilhar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
