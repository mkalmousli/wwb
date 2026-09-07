import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Websites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text().unique()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get firstSeenAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get starredAt => dateTime().nullable()();
}

class Snapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get websiteId =>
      integer().references(Websites, #id, onDelete: KeyAction.cascade)();
  TextColumn get timestamp => text()();
  TextColumn get originalUrl => text()();
  IntColumn get statusCode => integer().nullable()();
  TextColumn get mimeType => text().nullable()();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get starredAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {websiteId, timestamp},
  ];
}

class SearchProviders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get displayName => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class SnapshotJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get websiteId => integer().references(Websites, #id)();
  DateTimeColumn get requestedAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get state => text().withDefault(const Constant('pending'))();
  TextColumn get resultTimestamp => text().nullable()();
  TextColumn get error => text().nullable()();
}

class CdxCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get websiteId => integer()();
  TextColumn get granularity => text()(); // year | month | day
  TextColumn get period => text()(); // e.g. '2019', '201903', '20190301'
  IntColumn get count => integer().withDefault(const Constant(0))();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {websiteId, granularity, period},
  ];
}

@DriftDatabase(
  tables: [
    Websites,
    Snapshots,
    SearchProviders,
    Settings,
    SnapshotJobs,
    CdxCache,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedProviders();
    },
    // Runs on every open — adds any newly-shipped providers without a
    // schema bump (insertOrIgnore keeps the user's enabled/disabled state).
    beforeOpen: (details) async {
      await _seedProviders();
    },
  );

  Future<void> _seedProviders() async {
    const defaults = [
      ('link_guesser', 'Link guesser', 0),
      ('wikidata', 'Wikidata', 1),
      ('wikipedia', 'Wikipedia', 2),
      ('marginalia', 'Marginalia', 3),
      ('duckduckgo', 'DuckDuckGo', 4),
      ('hackernews', 'Hacker News', 5),
      ('npm', 'npm', 6),
    ];
    for (final d in defaults) {
      await into(searchProviders).insert(
        SearchProvidersCompanion.insert(
          key: d.$1,
          displayName: d.$2,
          sortOrder: Value(d.$3),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  static QueryExecutor _open() => driftDatabase(
    name: 'wwb',
    native: DriftNativeOptions(
      // Keep the DB in the app's private support dir, not the user's
      // Documents folder (drift_flutter's default on desktop).
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );
}
