import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_const.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_const.dart';
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

  final String _sqlTableGerminationTest = """
CREATE TABLE ${GerminationTestConst.kGERMINATIONTESTTABLE} (
  ${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${GerminationTestConst.kSPECIESCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kMATERIALCOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kSUBSTRATECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kTEMPERATURECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kFIRSTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kLASTCOUNTCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kTOTALSEEDSCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kGERMINATEDSEEDSCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kCURRENTDAYCOLUMN} INTEGER NOT NULL,
  ${GerminationTestConst.kLASTRECORDEDDATECOLUMN} TEXT NOT NULL,
  ${GerminationTestConst.kFINISHEDCOLUMN} INTEGER NOT NULL
);
""";

  final String _sqlTableLot = """
CREATE TABLE ${LotConst.kLOTTABLE} (
  ${LotConst.kIDLOTCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${LotConst.kNUMBERLOTCOLUMN} INTEGER NOT NULL,
  ${LotConst.kGERMINATEDSEEDPERLOT} INTEGER NOT NULL,
  ${LotConst.kDAILYCOUNTCOLUMN} TEXT NOT NULL,
  ${LotConst.kIDGERMINATIONTESTFOREIGNKEY} INTEGER NOT NULL,
  FOREIGN KEY (${LotConst.kIDGERMINATIONTESTFOREIGNKEY}) REFERENCES ${GerminationTestConst.kGERMINATIONTESTTABLE} (${GerminationTestConst.kIDGERMINATIONTESTCOLUMN}) ON DELETE CASCADE
);
""";

  final String _sqlTableRepetition = """
CREATE TABLE ${RepetitionConst.kREPETITIONTABLE} (
  ${RepetitionConst.kIDREPETITIONCOLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${RepetitionConst.kSEEDSTOTALCOLUMN} INTEGER NOT NULL,
  ${RepetitionConst.kGERMINATEDSEEDSCOLUMN} INTEGER NOT NULL,
  ${RepetitionConst.kIDLOTFOREIGNKEYREPETITION} INTEGER NOT NULL,
  FOREIGN KEY (${RepetitionConst.kIDLOTFOREIGNKEYREPETITION}) REFERENCES ${LotConst.kLOTTABLE} (${LotConst.kIDLOTCOLUMN}) ON DELETE CASCADE
);
""";
}
