import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/persistence/helper/germination_test_helper.dart';

class GerminationTestRepository extends ChangeNotifier {
  GerminationTestHelper helper = GerminationTestHelper();

  GerminationTestRepository();

  Future<void> initialize() async {
    await _initRepository();
  }

  Future<void> _initRepository() async {
    await getAllProgressGerminationTest();
  }

  Future<int> addGerminationTest(GerminationTest germinationTest) async {
    int idGerminationTest = await helper.insert(germinationTest);

    notifyListeners();
    return idGerminationTest;
  }

  Future<List<GerminationTest>> getAllProgressGerminationTest() async {
    List mapGerminationTest = await helper.getAllProgress();
    List<GerminationTest> allGerminationTest = [];

    for (Map g in mapGerminationTest) {
      allGerminationTest.add(GerminationTest.fromMap(g));
    }

    return allGerminationTest;
  }

/*   Future<List<GerminationTest>> getAllGerminationTest() async {
    List mapGerminationTest = await helper.getAll();
    List<GerminationTest> allGerminationTest = [];

    for (Map g in mapGerminationTest) {
      allGerminationTest.add(GerminationTest.fromMap(g));
    }

    return allGerminationTest;
  } */

  Future<List<GerminationTest>> getAllFinishedGerminationTest() async {
    List mapGerminationTest = await helper.getAllFinished();
    List<GerminationTest> allGerminationTest = [];

    for (Map g in mapGerminationTest) {
      allGerminationTest.add(GerminationTest.fromMap(g));
    }

    return allGerminationTest;
  }

  Future<GerminationTest> getGerminationTest(int id) async {
    List listGerminationTest = await helper.get(id);

    if (listGerminationTest.isNotEmpty) {
      return GerminationTest.fromMap(listGerminationTest.first);
    } else {
      throw Exception('Nenhum Teste de Germinação com o ID $id encontrado');
    }
  }

  Future<int> updateGerminationTest(GerminationTest germinationTest) async {
    int numberRowsAffected;
    numberRowsAffected = await helper.update(germinationTest);

    notifyListeners();
    return numberRowsAffected;
  }

  Future<int> deleteGerminationTest(int id) async {
    int numberRowsAffected;
    numberRowsAffected = await helper.delete(id);

    notifyListeners();
    return numberRowsAffected;
  }
}
