import 'package:flutter_seedbyseed/database/database_app.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';
import 'package:sqflite/sqflite.dart';

class GerminationTestHelper {
  final DatabaseApp _databaseApp = DatabaseApp.instanceDatabaseApp;
  final String tableName = GerminationTestConst.kGERMINATIONTESTTABLE;

  Future<int> insert(GerminationTest germinationTest) async {
    final Database database = await _databaseApp.getDatabase;

    int idGerminationTest = await database.insert(
      tableName,
      germinationTest.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return idGerminationTest;
  }

  Future<List> get(int id) async {
    final Database database = await _databaseApp.getDatabase;
    final List listGerminationTest = await database.query(tableName,
        limit: 1,
        where: '${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} = ?',
        whereArgs: [id]);

    return listGerminationTest;
  }

  Future<List> getAllProgress() async {
    final Database database = await _databaseApp.getDatabase;
    final List listGerminationTest = await database.query(
      tableName,
      where: '${GerminationTestConst.kFINISHEDCOLUMN} = ?',
      whereArgs: [0],
    );

    return listGerminationTest;
  }
/*   Future<List> getAll() async {
    final Database database = await _databaseApp.getDatabase;
    final List listGerminationTest = await database.query(tableName);

    return listGerminationTest;
  } */

  Future<List> getAllFinished() async {
    final Database database = await _databaseApp.getDatabase;
    final List listGerminationTest = await database.query(
      tableName,
      where: '${GerminationTestConst.kFINISHEDCOLUMN} = ?',
      whereArgs: [1],
    );

    return listGerminationTest;
  }

  Future<int> update(GerminationTest germinationTest) async {
    final Database database = await _databaseApp.getDatabase;
    late final int numberRowsAffected;

    numberRowsAffected = await database.update(
        tableName, germinationTest.toMap(),
        where: '${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} = ?',
        whereArgs: [germinationTest.id],
        conflictAlgorithm: ConflictAlgorithm.replace);

    return numberRowsAffected;
  }

  Future<int> delete(int id) async {
    final Database database = await _databaseApp.getDatabase;
    late final int numberRowsAffected;

    numberRowsAffected = await database.delete(
      tableName,
      where: '${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} = ?',
      whereArgs: [id],
    );

    return numberRowsAffected;
  }
}
