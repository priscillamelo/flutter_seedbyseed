import 'package:flutter_seedbyseed/domain/model/repetition.dart';
import 'package:flutter_seedbyseed/persistence/helper/repetition_helper.dart';

class RepetitionRepository {
  RepetitionHelper helper = RepetitionHelper();

  RepetitionRepository();

  Future<int> addRepetition(Repetition repetition) async {
    int idRepetition = await helper.insertRepetition(repetition);

    return idRepetition;
  }

  Future<List<Repetition>> getAllRepetition(int? idLot) async {
    List mapRepetition = await helper.getAllRepetitions(idLot!);
    List<Repetition> allRepetition = [];

    for (Map r in mapRepetition) {
      allRepetition.add(Repetition.fromMap(r));
    }

    return allRepetition;
  }

  Future<void> updateRepetition(Repetition repetition) async {
    await helper.updateRepetition(repetition);
  }
}
