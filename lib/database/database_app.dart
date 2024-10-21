import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseApp {
  DatabaseApp._internalConstructor();
  static const String _kDATABASENAME = 'germination-test-db.db';

  static final DatabaseApp instanceDatabaseApp =
      DatabaseApp._internalConstructor();

  static Database? _database;

  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(
      databaseDirPath,
      DatabaseApp._kDATABASENAME,
    );
    final Database database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );

    return database;
  }

  _onCreate(db, version) async {
    await _database!.execute(_sqlTableGerminationTest);
  }

  Future<Database> get getDatabase async {
    if (_database != null) return _database!;

    return await _initDatabase();
  }

  final String _sqlTableGerminationTest = GerminationTestRepository().sqlTable;
}
