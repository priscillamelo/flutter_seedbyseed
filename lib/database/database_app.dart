import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseApp {
  DatabaseApp._internalConstructor();
  static const String _kDATABASENAME = 'germination_test_db.db';

  static final DatabaseApp instanceDatabaseApp =
      DatabaseApp._internalConstructor();

  static Database? database;

  Future<Database> _initDatabase() async {
    final String databaseDirPath = await getDatabasesPath();
    final String databasePath = join(
      databaseDirPath,
      DatabaseApp._kDATABASENAME,
    );
    final Database database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (database, newerVersion) async {
        await database.execute(_sqlTableGerminationTest);
      },
    );

    return database;
  }

  Future<Database> get getDatabase async {
    if (database != null) return database!;

    return await _initDatabase();
  }

  final String _sqlTableGerminationTest = """
CREATE TABLE ${GerminationTestConst.kGERMINATIONTESTTABLE} (
  ${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${GerminationTestConst.kSPECIESCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kLOTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kMATERIALCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kSUBSTRATECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kTEMPERATURECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kDURATIONCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kFIRSTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kLASTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kREPETITIONCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kTOTALSEEDSCOLUMN} INTEGER NOT NULL
);
""";
}
