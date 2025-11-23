import 'package:app_tracker_riverpood_sqlite/data/database/database.dart';
import 'package:app_tracker_riverpood_sqlite/data/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final habitsForDateProvider =
    StreamProvider.family<List<HabitWithCompletions>, DateTime>((ref, date) {
      final database = ref.watch(databaseProvider);
      return database.watchHabitsForData(date);
    });
