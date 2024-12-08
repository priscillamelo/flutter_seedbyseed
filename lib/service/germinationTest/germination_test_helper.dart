import 'package:flutter_seedbyseed/database/database_app.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_const.dart';
import 'package:sqflite/sqflite.dart';

class GerminationTestHelper {
  final DatabaseApp _databaseApp = DatabaseApp.instanceDatabaseApp;
  final String tableName = GerminationTestConst.kGERMINATIONTESTTABLE;

  Future<int> insertGerminationTest(GerminationTest germinationTest) async {
    final Database database = await _databaseApp.getDatabase;

    int idGerminationTest = await database.insert(
      tableName,
      germinationTest.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return idGerminationTest;
  }

  Future<List> getGerminationTest(int id) async {
    final Database database = await _databaseApp.getDatabase;
    final List listGerminationTest = await database.query(tableName,
        limit: 1,
        where: '${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} = ?',
        whereArgs: [id]);

    return listGerminationTest;
  }

  Future<List> getAllGerminationTest() async {
    final Database database = await _databaseApp.getDatabase;
    final List listGerminationTest = await database.query(tableName);

    return listGerminationTest;
  }

  Future<int> updateGerminationTest(GerminationTest germinationTest) async {
    final Database database = await _databaseApp.getDatabase;
    late final int numberRowsAffected;

    numberRowsAffected = await database.update(
        tableName, germinationTest.toMap(),
        where: '${GerminationTestConst.kIDGERMINATIONTESTCOLUMN} = ?',
        whereArgs: [germinationTest.id],
        conflictAlgorithm: ConflictAlgorithm.replace);

    return numberRowsAffected;
  }

  Future<int> deleteGerminationTest(int id) async {
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
