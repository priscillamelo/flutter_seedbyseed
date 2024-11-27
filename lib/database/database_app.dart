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
        await database.execute(_sqlTableLot);
        await database.execute(_sqlTableRepetition);
      },
    );

    return database;
  }

  Future<Database> get getDatabase async {
    if (database != null) return database!;

    return await _initDatabase();
  }

  /* final String _sqlTableGerminationTest = """
CREATE TABLE germination_test_table (
  id_germination_test INTEGER PRIMARY KEY AUTOINCREMENT,
  specie_germination_test TEXT NOT NULL,
  material_germination_test TEXT NOT NULL,
  substrate_germination_test TEXT NOT NULL,
  temperature_germination_test TEXT NOT NULL,
  duration_germination_test INTEGER NOT NULL,
  first_count_germination_test INTEGER NOT NULL,
  last_count_germination_test INTEGER NOT NULL,
  total_seeds_germination_test INTEGER NOT NULL
);
"""; */
  final String _sqlTableGerminationTest = """
CREATE TABLE ${GerminationTestConst.kGERMINATIONTESTTABLE} (
  ${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${GerminationTestConst.kSPECIESCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kMATERIALCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kSUBSTRATECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kTEMPERATURECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kDURATIONCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kFIRSTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kLASTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kTOTALSEEDSCOLUMN} INTEGER NOT NULL
);
""";

  final String _sqlTableLot = """
CREATE TABLE lot_table (
  id_lot INTEGER PRIMARY KEY AUTOINCREMENT,
  number_lot INTEGER NOT NULL,
  id_germination_test_lot INTEGER NOT NULL,
  FOREIGN KEY (id_germination_test_lot) REFERENCES germination_test_table (id_germination_test) ON DELETE CASCADE
);
""";

  final String _sqlTableRepetition = """
CREATE TABLE repetition_table (
  id_repetition INTEGER PRIMARY KEY AUTOINCREMENT,
  seeds_total_repetition INTEGER NOT NULL,
  germinated_seeds_repetition INTEGER NOT NULL,
  id_lot_repetition INTEGER NOT NULL,
  FOREIGN KEY (id_lot_repetition) REFERENCES lot_table (id_lot) ON DELETE CASCADE
);
""";

  /* final String _sqlTableLot = """
CREATE TABLE ${LotConst.kLOTTABLE} (
  ${LotConst.kIDLOTCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${LotConst.kNUMBERLOTCOLUMN} INTEGER NOT NULL,
  ${LotConst.kIDGERMINATIONTESTFOREIGNKEY} INTEGER NOT NULL,
  FOREIGN KEY (${LotConst.kIDGERMINATIONTESTFOREIGNKEY}) REFERENCES ${GerminationTestConst.kGERMINATIONTESTTABLE} (${GerminationTestConst.kIDGERMINATIONTESTCOLUMN}) ON DELETE CASCADE
);
"""; */
  /* final String _sqlTableRepetition = """
CREATE TABLE ${RepetitionConst.kREPETITIONTABLE} (
  ${RepetitionConst.kIDREPETITIONCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${RepetitionConst.kSEEDSTOTALCOLUMN} INTEGER NOT NULL,
  ${RepetitionConst.kGERMINATEDSEEDSCOLUMN} INTEGER NOT NULL,
  ${RepetitionConst.kIDLOTFOREIGNKEYREPETITION} INTEGER NOT NULL,
  FOREIGN KEY (${RepetitionConst.kIDLOTFOREIGNKEYREPETITION}) REFERENCES ${LotConst.kLOTTABLE} (${LotConst.kIDLOTCOLUMN}) ON DELETE CASCADE
);
"""; */
}
