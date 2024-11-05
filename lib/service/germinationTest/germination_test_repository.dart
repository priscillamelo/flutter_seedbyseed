import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_helper.dart';

class GerminationTestRepository extends ChangeNotifier {
  GerminationTestHelper helper = GerminationTestHelper();

  GerminationTestRepository();

  Future<void> initialize() async {
    await _initRepository();
  }

  _initRepository() async {
    await getAllGerminationTest();
  }

  Future<List<GerminationTest>> getAllGerminationTest() async {
    List mapGerminationTest = await helper.getAllGerminationTest();
    List<GerminationTest> allGerminationTest = [];

    for (Map g in mapGerminationTest) {
      allGerminationTest.add(GerminationTest.fromMap(g));
    }

    return allGerminationTest;
  }

  Future<int> addGerminationTest(GerminationTest germinationTest) async {
    int numberRowsAffected;
    numberRowsAffected = await helper.addGerminationTest(germinationTest);

    notifyListeners();
    return numberRowsAffected;
  }

  Future<GerminationTest?> getGerminationTest(int id) async {
    final GerminationTest? germinationTest;
    germinationTest = await helper.getGerminationTest(id);

    return germinationTest;
  }

  Future<int> updateGerminationTest(GerminationTest germinationTest) async {
    int numberRowsAffected;
    numberRowsAffected = await helper.updateGerminationTest(germinationTest);

    notifyListeners();
    return numberRowsAffected;
  }

  Future<int> deleteGerminationTest(int id) async {
    int numberRowsAffected;
    numberRowsAffected = await helper.deleteGerminationTest(id);

    notifyListeners();
    return numberRowsAffected;
  }
}
