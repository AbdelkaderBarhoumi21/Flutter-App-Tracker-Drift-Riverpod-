import 'package:app_tracker_riverpood_sqlite/data/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dailySummaryProvider =
    StreamProvider.family<(int completedTasks, int totaltasks), DateTime>((
      ref,
      date,
    ) {
      final database = ref.watch(databaseProvider);
      return database.watchDailySummary(date);
    });
