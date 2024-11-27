import 'package:flutter_seedbyseed/model/germinationTest/repetition/repetition.dart';
import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_helper.dart';

class RepetitionRepository {
  RepetitionHelper helper = RepetitionHelper();

  RepetitionRepository();
  Future<int> addRepetition(Repetition repetition) async {
    int idRepetition = await helper.insertRepetition(repetition);

    return idRepetition;
  }

  Future<List<Repetition>> getAllRepetition(int idLot) async {
    List mapRepetition = await helper.getAllRepetitions(idLot);
    List<Repetition> allRepetition = [];

    for (Map r in mapRepetition) {
      allRepetition.add(Repetition.fromMap(r));
    }

    return allRepetition;
  }
}
