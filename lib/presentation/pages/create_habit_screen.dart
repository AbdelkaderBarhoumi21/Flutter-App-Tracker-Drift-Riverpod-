import 'package:app_tracker_riverpood_sqlite/data/database/database.dart';
import 'package:app_tracker_riverpood_sqlite/data/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

class CreateHabitScreen extends HookConsumerWidget {
  const CreateHabitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isDaily = useState(true);
    final hasReminder = useState(false);
    final reminderTime = useState<TimeOfDay?>(
      const TimeOfDay(hour: 10, minute: 0),
    );
    Future<void> onCreatehabit() async {
      final title = titleController.text;
      final description = descriptionController.text;
      if (title.isEmpty) {
        return;
      }

      final habit = HabitsCompanion.insert(
        title: title,
        description: Value(description),
        createdAt: Value(DateTime.now()),
        isDaily: Value(isDaily.value),
        reminderTime: Value(reminderTime.value?.format(context)),
      );
      await ref.read(databaseProvider).createHabit(habit);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Habit Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Habit Description'),
            ),
            const SizedBox(height: 16),
            const Text('Goal'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daily'),
                Switch(
                  value: isDaily.value,
                  onChanged: (value) => isDaily.value = value,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Reminder'),
            const SizedBox(height: 16),
            SwitchListTile(
              value: hasReminder.value,
              onChanged: (value) {
                hasReminder.value = value;
                if (value) {
                  showTimePicker(
                    context: context,
                    initialTime:
                        reminderTime.value ??
                        const TimeOfDay(hour: 10, minute: 0),
                  ).then((time) {
                    if (time != null) {
                      reminderTime.value = time;
                    } else {
                      hasReminder.value = false;
                    }
                  });
                }
              },
              title: const Text('Has Reminder'),
              subtitle: hasReminder.value && reminderTime.value != null
                  ? Text(reminderTime.value!.format(context))
                  : null,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: onCreatehabit,
                child: const Text('Create habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
