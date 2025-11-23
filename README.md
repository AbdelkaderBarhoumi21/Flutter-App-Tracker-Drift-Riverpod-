# 🎯 Habit Tracker

A beautiful and modern habit tracking application built with Flutter, featuring a clean architecture and persistent local storage.

## ✨ Features

- **📅 Daily Habit Tracking** - Track your habits day by day with an intuitive timeline view
- **📊 Progress Visualization** - Beautiful progress indicators and daily summaries
- **🔔 Reminders** - Set custom reminder times for your habits
- **📈 Streak Tracking** - Monitor your consistency with streak counters
- **💾 Offline Storage** - All data stored locally using SQLite with Drift
- **🎨 Modern UI** - Clean, gradient-based design with Material Design 3
- **⚡ Reactive State Management** - Built with Riverpod for efficient state updates

## 📸 Screenshots

> Add your app screenshots here

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── app/                    # Application configuration
├── data/                   # Data layer
│   ├── database/          # Drift database & tables
│   └── providers/         # Riverpod providers
├── domain/                # Business logic (if needed)
└── presentation/          # UI layer
    ├── pages/            # Screen widgets
    └── widgets/          # Reusable components
```

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/) + [Flutter Hooks](https://pub.dev/packages/flutter_hooks)
- **Database**: [Drift](https://drift.simonbinder.eu/) (SQLite)
- **Reactive Streams**: [RxDart](https://pub.dev/packages/rxdart)
- **UI Theme**: [FlexColorScheme](https://pub.dev/packages/flex_color_scheme)
- **Date Formatting**: [intl](https://pub.dev/packages/intl)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/habit-tracker.git
   cd habit-tracker
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Drift code**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  drift: ^2.29.0
  drift_flutter: ^0.2.0
  hooks_riverpod: ^2.6.1
  flutter_hooks: ^0.20.5
  rxdart: ^0.28.0
  path_provider: ^2.1.5
  intl: ^0.20.2
  flex_color_scheme: ^8.1.0

dev_dependencies:
  drift_dev: ^2.29.0
  build_runner: ^2.7.1
```

## 🎯 Core Features Explained

### 1. Habit Creation

Create habits with:

- Title and description
- Daily/custom frequency
- Optional reminder times

### 2. Completion Tracking

- Mark habits as completed with a single tap
- Visual feedback with gradient buttons
- Automatic streak calculation

### 3. Daily Summary

- View completion progress for any date
- Beautiful gradient cards with progress bars
- Quick overview of completed vs total habits

### 4. Timeline Navigation

- Swipe through dates easily
- Visual indicators for selected date
- Smooth animations

## 🗄️ Database Schema

### Tables

**Habits**

- `id` (Primary Key)
- `title` (Text)
- `description` (Text, nullable)
- `createdAt` (DateTime)
- `reminderTime` (Text, nullable)
- `streak` (Integer, default: 0)
- `totalCompletion` (Integer, default: 0)
- `isDaily` (Boolean, default: false)

**HabitCompletions**

- `id` (Primary Key)
- `habitId` (Foreign Key → Habits)
- `completedAt` (DateTime)

## 🔄 State Management Pattern

This app uses **Riverpod** with the following providers:

- `databaseProvider` - Singleton database instance
- `dailySummaryProvider.family` - Daily completion summary by date
- `habitsForDateProvider.family` - Habits with completion status by date

### Example Usage

```dart
// Watch daily summary for a specific date
final summary = ref.watch(dailySummaryProvider(selectedDate));

// Access database
final db = ref.read(databaseProvider);
await db.createHabit(habitData);
```

## 🎨 UI Components

### Custom Widgets

- **DailySummaryCard** - Gradient card showing daily progress
- **HabitCard** - Individual habit item with completion button
- **TimelineView** - Horizontal date selector
- **HabitCardList** - Scrollable list of habits

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
