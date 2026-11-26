import 'package:flutter/material.dart';
import '../../controllers/ambient_audio_controller.dart';
import '../../models/ambient_track_model.dart';
import '../../widgets/tv_focusable.dart';

class AmbientSoundSheet extends StatelessWidget {
  const AmbientSoundSheet({super.key});

  IconData _iconForTrack(String iconName) {
    switch (iconName) {
      case 'harp':
        return Icons.music_note_rounded;
      case 'rain':
        return Icons.water_drop_rounded;
      case 'piano':
        return Icons.piano_rounded;
      case 'pad':
        return Icons.waves_rounded;
      case 'breeze':
        return Icons.air_rounded;
      default:
        return Icons.spa_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AmbientAudioController.instance;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final current = controller.currentTrack;
        final isPlaying = controller.isPlaying;
        final isLoading = controller.isLoading;

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.headphones_rounded, color: colors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Áudio Ambiente & Meditação',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Sons de paz para leitura e oração',
                              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isPlaying || current != null)
                      IconButton(
                        tooltip: 'Parar áudio',
                        icon: const Icon(Icons.stop_circle_outlined),
                        onPressed: () => controller.stop(),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de faixas
                Text(
                  'Ambientes Inspiradores',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.outline,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AmbientAudioController.presets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final track = AmbientAudioController.presets[index];
                      final isSelected = current?.id == track.id;

                      return TvFocusable(
                        onPressed: () => controller.playTrack(track),
                        child: InkWell(
                          onTap: () => controller.playTrack(track),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primaryContainer.withValues(alpha: 0.7)
                                  : colors.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? colors.primary
                                    : colors.outlineVariant.withValues(alpha: 0.3),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      _iconForTrack(track.iconName),
                                      size: 22,
                                      color: isSelected ? colors.primary : colors.onSurfaceVariant,
                                    ),
                                    if (isSelected && isPlaying)
                                      Icon(Icons.graphic_eq_rounded, size: 16, color: colors.primary),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  track.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isSelected ? colors.onPrimaryContainer : colors.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  track.subtitle,
                                  style: TextStyle(fontSize: 10, color: colors.outline),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Player Controls (Play/Pause e Volume)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      TvFocusable(
                        onPressed: () => controller.togglePlayPause(),
                        child: IconButton.filled(
                          onPressed: () => controller.togglePlayPause(),
                          icon: isLoading
                              ? SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onPrimary,
                                  ),
                                )
                              : Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              current?.title ?? 'Nenhum som selecionado',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(Icons.volume_down_rounded, size: 16, color: colors.outline),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 3,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                    ),
                                    child: Slider(
                                      value: controller.volume,
                                      onChanged: (v) => controller.setVolume(v),
                                    ),
                                  ),
                                ),
                                Icon(Icons.volume_up_rounded, size: 16, color: colors.outline),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Sleep Timer
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: colors.outline),
                    const SizedBox(width: 6),
                    Text(
                      'Timer de Repouso:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.outline),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _timerChip(context, controller, null, 'Desligado'),
                            _timerChip(context, controller, const Duration(minutes: 10), '10m'),
                            _timerChip(context, controller, const Duration(minutes: 20), '20m'),
                            _timerChip(context, controller, const Duration(minutes: 30), '30m'),
                            _timerChip(context, controller, const Duration(minutes: 60), '60m'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _timerChip(
    BuildContext context,
    AmbientAudioController controller,
    Duration? duration,
    String label,
  ) {
    final isSelected = controller.sleepTimerDuration == duration;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: isSelected,
        visualDensity: VisualDensity.compact,
        onSelected: (_) => controller.setSleepTimer(duration),
      ),
    );
  }
}
