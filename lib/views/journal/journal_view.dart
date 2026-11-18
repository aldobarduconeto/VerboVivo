import 'package:flutter/material.dart';

import '../../controllers/journal_controller.dart';
import '../../models/journal_model.dart';
import '../chapter/chapter_view.dart';
import '../verse_studio/verse_studio_sheet.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const JournalView()),
    );
  }

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _journal = JournalController.instance;
  String _selectedColorFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddPrayerDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final refController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Novo Pedido de Oração'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Título do Pedido',
                  hintText: 'Ex.: Saúde da família, Direção no trabalho',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Detalhes ou Motivo',
                  hintText: 'Descreva sua oração e clamor a Deus...',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: refController,
                decoration: const InputDecoration(
                  labelText: 'Passagem Bíblica Âncora (Opcional)',
                  hintText: 'Ex.: Filipenses 4:6 ou Salmos 91',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              await _journal.addPrayer(
                title: titleController.text,
                description: descController.text,
                scriptureReference: refController.text.isNotEmpty ? refController.text : null,
              );
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Salvar Oração'),
          ),
        ],
      ),
    );
  }

  Color _getColorForKey(String key) {
    switch (key) {
      case 'gold':
        return Colors.amber;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'rose':
        return Colors.pinkAccent;
      default:
        return Colors.amber;
    }
  }

  String _getLabelForColorKey(String key) {
    switch (key) {
      case 'gold':
        return 'Promessa de Deus';
      case 'green':
        return 'Gratidão & Louvor';
      case 'blue':
        return 'Paz & Esperança';
      case 'rose':
        return 'Sabedoria & Instrução';
      default:
        return 'Destaque';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: _journal,
      builder: (context, _) {
        final activePrayers = _journal.activePrayers;
        final answeredPrayers = _journal.answeredPrayers;
        final highlights = _journal.allHighlights;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Diário de Fé & Orações'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: const Icon(Icons.volunteer_activism_rounded),
                  text: 'Mural de Oração (${activePrayers.length})',
                ),
                Tab(
                  icon: const Icon(Icons.format_paint_rounded),
                  text: 'Destaques Bíblicos (${highlights.length})',
                ),
              ],
            ),
          ),
          floatingActionButton: _tabController.index == 0
              ? FloatingActionButton.extended(
                  onPressed: _showAddPrayerDialog,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Nova Oração'),
                )
              : null,
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Mural de Oração
              _buildPrayerTab(colors, activePrayers, answeredPrayers),

              // Tab 2: Versículos Marcados
              _buildHighlightsTab(colors, highlights),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerTab(
    ColorScheme colors,
    List<PrayerItem> active,
    List<PrayerItem> answered,
  ) {
    if (active.isEmpty && answered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.volunteer_activism_outlined, size: 56, color: colors.outline),
              const SizedBox(height: 16),
              const Text(
                'Seu Mural de Oração está Vazio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Registre seus motivos de oração, conversas com Deus e acompanhe as respostas com gratidão!',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _showAddPrayerDialog,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adicionar Primeiro Pedido'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        if (active.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                const Text('🙏 ', style: TextStyle(fontSize: 14)),
                Text(
                  'Em Clamor (${active.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          ...active.map((p) => _buildPrayerCard(colors, p)),
          const SizedBox(height: 24),
        ],
        if (answered.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                const Text('🙌 ', style: TextStyle(fontSize: 14)),
                Text(
                  'Orações Respondidas & Gratidão (${answered.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          ...answered.map((p) => _buildPrayerCard(colors, p)),
        ],
      ],
    );
  }

  Widget _buildPrayerCard(ColorScheme colors, PrayerItem prayer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: prayer.isAnswered
              ? Colors.green.withValues(alpha: 0.5)
              : colors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      color: prayer.isAnswered
          ? Colors.green.withValues(alpha: 0.08)
          : colors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: prayer.isAnswered,
                  activeColor: Colors.green,
                  onChanged: (_) async {
                    await _journal.togglePrayerAnswered(prayer.id);
                  },
                ),
                Expanded(
                  child: Text(
                    prayer.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: prayer.isAnswered ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  onPressed: () => _journal.deletePrayer(prayer.id),
                ),
              ],
            ),
            if (prayer.description.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 48, right: 12, bottom: 8),
                child: Text(
                  prayer.description,
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13.5),
                ),
              ),
            ],
            if (prayer.scriptureReference != null && prayer.scriptureReference!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 48, bottom: 4),
                child: ActionChip(
                  avatar: const Icon(Icons.menu_book_rounded, size: 14),
                  label: Text(prayer.scriptureReference!),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChapterView(reference: prayer.scriptureReference!),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (prayer.isAnswered && prayer.answeredAt != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 4),
                child: Text(
                  '🙌 Respondida em: ${prayer.answeredAt!.day}/${prayer.answeredAt!.month}/${prayer.answeredAt!.year}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightsTab(ColorScheme colors, List<VerseHighlight> highlights) {
    if (highlights.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.format_paint_outlined, size: 56, color: colors.outline),
              const SizedBox(height: 16),
              const Text(
                'Nenhum Versículo Marcado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Ao ler qualquer capítulo bíblico, toque em um versículo para destacá-lo com cores temáticas!',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = _selectedColorFilter == 'all'
        ? highlights
        : highlights.where((h) => h.colorKey == _selectedColorFilter).toList();

    return Column(
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: _selectedColorFilter == 'all',
                onSelected: (s) {
                  if (s) setState(() => _selectedColorFilter = 'all');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                avatar: const Icon(Icons.circle, size: 12, color: Colors.amber),
                label: const Text('Promessas'),
                selected: _selectedColorFilter == 'gold',
                onSelected: (s) {
                  if (s) setState(() => _selectedColorFilter = 'gold');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                avatar: const Icon(Icons.circle, size: 12, color: Colors.green),
                label: const Text('Gratidão'),
                selected: _selectedColorFilter == 'green',
                onSelected: (s) {
                  if (s) setState(() => _selectedColorFilter = 'green');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                avatar: const Icon(Icons.circle, size: 12, color: Colors.blue),
                label: const Text('Esperança'),
                selected: _selectedColorFilter == 'blue',
                onSelected: (s) {
                  if (s) setState(() => _selectedColorFilter = 'blue');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                avatar: const Icon(Icons.circle, size: 12, color: Colors.pinkAccent),
                label: const Text('Sabedoria'),
                selected: _selectedColorFilter == 'rose',
                onSelected: (s) {
                  if (s) setState(() => _selectedColorFilter = 'rose');
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // List of highlights
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final h = filtered[index];
              final color = _getColorForKey(h.colorKey);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: color.withValues(alpha: 0.4), width: 1.2),
                ),
                color: color.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 10, color: color),
                                const SizedBox(width: 6),
                                Text(
                                  _getLabelForColorKey(h.colorKey),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
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
                                    reference: h.reference,
                                    text: h.text,
                                  );
                                },
                              ),
                              IconButton(
                                iconSize: 18,
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Remover destaque',
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _journal.removeHighlight(h.chapterReference, h.verseNumber);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '“${h.text}”',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontStyle: FontStyle.italic,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            h.reference,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: colors.primary,
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChapterView(reference: h.chapterReference),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                            label: const Text('Ler Capítulo'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
