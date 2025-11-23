import 'package:app_tracker_riverpood_sqlite/app/my_app.dart';
import 'package:app_tracker_riverpood_sqlite/data/database/database.dart';
import 'package:app_tracker_riverpood_sqlite/data/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  final database = AppDatabase();
  // Injecter cette instance dans Riverpod
  // ProviderScope.overrides remplace databaseProvider
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const MyApp(),
    ),
  );
}

