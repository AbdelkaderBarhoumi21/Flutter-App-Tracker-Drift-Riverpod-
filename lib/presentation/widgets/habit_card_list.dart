import 'package:app_tracker_riverpood_sqlite/data/providers/habits_for_date_provider.dart';
import 'package:app_tracker_riverpood_sqlite/presentation/widgets/habit_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HabitCardList extends HookConsumerWidget {
  final DateTime selectedDate;
  const HabitCardList({required this.selectedDate, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsyncValue = ref.watch(habitsForDateProvider(selectedDate));
    return habitAsyncValue.when(
      data: (habits) => Expanded(
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final habitWithCompletions = habits[index];
            return HabitCard(
              title: habitWithCompletions.habit.title,
              streak: habitWithCompletions.habit.streak,
              progress: habitWithCompletions.isCompleted ? 1 : 0,
              habitId: habitWithCompletions.habit.id,
              isCompleted: habitWithCompletions.isCompleted,
              date: selectedDate,
            );
          },
        ),
      ),
      error: (error, stack) => Center(child: Text(error.toString())),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
