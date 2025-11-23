import 'dart:io';
import 'package:app_tracker_riverpood_sqlite/data/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
part 'database.g.dart';

/// Defines an auto-incrementing integer column for the primary key.
/// - `integer()`: Creates an integer column
/// - `autoIncrement()`: Configures auto-increment behavior
/// - `()`: Executes the expression and returns the column instance
///select(habits) is therefore a query to get all the rows from the Habits table.
@DriftDatabase(tables: [Habits, HabitCompletions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnections());

  @override
  int get schemaVersion => 1;
  //List<Habit> - Drift generates a data class named Habit
  Future<List<Habit>> getHabits() => select(habits).get();
  Stream<List<Habit>> watchHabits() => select(habits).watch();
  Future<int> createHabit(HabitsCompanion habit) => into(habits).insert(habit);
  Stream<List<HabitWithCompletions>> watchHabitsForData(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);

    // Defines the end of the selected day (23:59:59.999)
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = select(habits).join([
      leftOuterJoin(
        habitCompletions,
        habitCompletions.habitId.equalsExp(habits.id) &
            habitCompletions.completedAt.isBetweenValues(startOfDay, endOfDay),
      ),
    ]);
    return query.watch().map((row) {
      return row.map((row) {
        final habit = row.readTable(habits);
        final completion = row.readTableOrNull(habitCompletions);
        return HabitWithCompletions(habit, completion != null);
      }).toList();
    });
  }

  /// Marks a habit as completed for a given date.
  ///
  /// This function:
  /// 1. Checks if the habit has already been completed for this day
  /// 2. If not, creates a new completion and updates the statistics
  ///
  /// Parameters:
  /// - [habitId]: The identifier of the habit to complete
  /// - [selectedDate]: The date of completion
  Future<void> completedHabit(int habitId, DateTime selectedDate) async {
    // Transaction: ensures all operations succeed or fail together
    await transaction(() async {
      // Defines the start of the selected day (00:00:00)
      final startOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      // Defines the end of the selected day (23:59:59.999)
      final endOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        23,
        59,
        59,
        999,
      );

      // Checks if a completion already exists for this habit today
      final exisitingCompletion =
          await (select(habitCompletions)..where(
                (t) =>
                    t.habitId.equals(habitId) &
                    t.completedAt.isBetween(
                      // Variable<T>: Converts Dart values into secure SQL parameters
                      // Used in WHERE clauses to prevent SQL injection
                      Variable(startOfDay),
                      Variable(endOfDay),
                    ),
              ))
              .get();

      // If no completion exists for today
      if (exisitingCompletion.isEmpty) {
        // Inserts a new completion
        await into(habitCompletions).insert(
          // HabitCompletionsCompanion: Generated class for building insertions
          // Companion allows specifying only the necessary fields
          HabitCompletionsCompanion(
            // Value<T>: Indicates that a value is explicitly provided
            // Unspecified fields will use their default values
            habitId: Value(habitId),
            completedAt: Value(selectedDate),
          ),
        );

        // Retrieves the habit to update its statistics
        final habit = await (select(
          habits,
        )..where((t) => t.id.equals(habitId))).getSingle();

        await update(habits).replace(
          habit
              .copyWith(
                streak: habit.streak + 1,
                totalCompletion: habit.totalCompletion + 1,
              )
              // toCompanion(true): Converts Habit to HabitsCompanion
              // The true parameter indicates to include all fields
              .toCompanion(true),
        );
      }
    });
  }

  Stream<(int, int)> watchDailySummary(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);

    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    final completionsStream =
        (select(habitCompletions)..where(
              ((t) => t.completedAt.isBetween(
                Variable(startOfDay),
                Variable(endOfDay),
              )),
            ))
            .watch();

    final habitStream = watchHabitsForData(date);
    return Rx.combineLatest2(
      completionsStream,
      habitStream,
      (completions, habits) => (completions.length, habits.length),
    );
  }
}

class HabitWithCompletions {
  final Habit habit;
  final bool isCompleted;
  HabitWithCompletions(this.habit, this.isCompleted, {required});
}

LazyDatabase _openConnections() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'habits.db'));
    return NativeDatabase.createInBackground(file);
  });
}
