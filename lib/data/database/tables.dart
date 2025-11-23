import 'package:drift/drift.dart';

/// Defines an auto-incrementing integer column for the primary key.
/// - `integer()`: Creates an integer column
/// - `autoIncrement()`: Configures auto-increment behavior
/// - `()`: Executes the expression and returns the column instance
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get reminderTime => text().nullable()();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  IntColumn get totalCompletion => integer().withDefault(const Constant(0))();
  BoolColumn get isDaily => boolean().withDefault(const Constant(false))();
}

class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer()();
  DateTimeColumn get completedAt => dateTime()();
}
