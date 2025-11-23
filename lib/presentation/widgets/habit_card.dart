import 'package:app_tracker_riverpood_sqlite/data/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HabitCard extends HookConsumerWidget {
  final String title;
  final int streak;
  final double progress;
  final int habitId;
  final bool isCompleted;
  final DateTime date;

  const HabitCard({
    super.key,
    required this.title,
    required this.streak,
    required this.progress,
    required this.habitId,
    required this.isCompleted,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> onComplet() async {
      await ref.read(databaseProvider).completedHabit(habitId, date);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit completed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        gradient: LinearGradient(
          colors: [
            isCompleted
                ? colorScheme.primaryContainer.withValues(alpha: 0.8)
                : colorScheme.surface.withValues(alpha: 0.1),
            isCompleted
                ? colorScheme.primaryContainer.withValues(alpha: 0.6)
                : colorScheme.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: colorScheme.shadow, blurRadius: 16)],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (streak > 0) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('$streak days'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isCompleted
                      ? LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                        )
                      : null,
                  color: isCompleted
                      ? colorScheme.surfaceContainerHighest
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onComplet,
                    borderRadius: BorderRadius.circular(16),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: isCompleted
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
