import 'package:flutter/material.dart';
import '../../controllers/reading_plan_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/reading_plan_model.dart';
import '../../widgets/tv_focusable.dart';
import '../chapter/chapter_view.dart';

class ReadingPlanView extends StatefulWidget {
  const ReadingPlanView({super.key});

  @override
  State<ReadingPlanView> createState() => _ReadingPlanViewState();
}

class _ReadingPlanViewState extends State<ReadingPlanView> {
  final _controller = ReadingPlanController.instance;
  final _settings = SettingsController.instance;

  void _openChapter(String passage) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterView(
          reference: passage,
          preferredTranslation: _settings.bibleTranslation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final currentPlan = _controller.activePlan;
        final progress = _controller.getProgress(currentPlan.id);
        final completedDays = _controller.getCompletedDays(currentPlan.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Planos de Leitura',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              if (_controller.streak > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '${_controller.streak} dias',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Seletor de Planos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _controller.allPlans.map((plan) {
                    final isSelected = plan.id == currentPlan.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(plan.title),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _controller.setActivePlan(plan.id);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Banner do Plano Ativo & Progresso
              Card(
                elevation: 0,
                color: colors.primaryContainer.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colors.primary.withValues(alpha: 0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: colors.onPrimary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentPlan.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currentPlan.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentPlan.description,
                        style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: colors.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${completedDays.length} de ${currentPlan.durationDays} dias concluídos',
                        style: TextStyle(fontSize: 11, color: colors.outline),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Cabeçalho da Lista de Dias
              Text(
                'Jornada de Leitura',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),

              // 4. Lista dos Dias
              ...currentPlan.days.map((day) {
                final isDone = completedDays.contains(day.dayNumber);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDone
                          ? colors.primary.withValues(alpha: 0.3)
                          : colors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? colors.primary
                                    : colors.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${day.dayNumber}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDone
                                        ? colors.onPrimary
                                        : colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                day.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: isDone
                                      ? colors.outline
                                      : colors.onSurface,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isDone
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: isDone ? colors.primary : colors.outline,
                              ),
                              tooltip: isDone
                                  ? 'Marcar como não lido'
                                  : 'Marcar como lido',
                              onPressed: () {
                                _controller.toggleDayCompleted(
                                  currentPlan.id,
                                  day.dayNumber,
                                );
                              },
                            ),
                          ],
                        ),
                        if (day.focusThought.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(left: 44, right: 8),
                            child: Text(
                              '💡 "${day.focusThought}"',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 44),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: day.passages.map((passage) {
                              return TvFocusable(
                                onPressed: () => _openChapter(passage),
                                child: ActionChip(
                                  avatar: const Icon(Icons.auto_stories_rounded, size: 14),
                                  label: Text(
                                    passage,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () => _openChapter(passage),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
