import 'package:app_tracker_riverpood_sqlite/data/providers/daily_summary_provider.dart';
import 'package:app_tracker_riverpood_sqlite/presentation/pages/create_habit_screen.dart';
import 'package:app_tracker_riverpood_sqlite/presentation/widgets/daily_summary_card.dart';
import 'package:app_tracker_riverpood_sqlite/presentation/widgets/habit_card_list.dart';
import 'package:app_tracker_riverpood_sqlite/presentation/widgets/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineView(
                selectedDate: selectedDate.value,
                onSelectedDateChanged: (date) => selectedDate.value = date,
              ),
              ref
                  .watch(dailySummaryProvider(selectedDate.value))
                  .when(
                    data: ((int, int) data) => DailySummaryCard(
                      completedTask: data.$1,
                      totalTasks: data.$2,
                      date: DateFormat('yyyy-MM-dd').format(selectedDate.value),
                    ),
                    error: (Object error, StackTrace stackTrace) =>
                        Text(error.toString()),
                    loading: () => const SizedBox.shrink(),
                  ),

              const SizedBox(height: 16),
              const Text('Habits'),
              const SizedBox(height: 16),
              HabitCardList(selectedDate: selectedDate.value),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateHabitScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text('Create Habit'),
            ),
          ),
        ),
      ),
    );
  }
}
