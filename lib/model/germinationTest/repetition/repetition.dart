import 'package:flutter_seedbyseed/service/germinationTest/repetition/repetition_const.dart';

class Repetition {
  late int id;
  late int lotId;
  late int seedsTotal;
  late int germinatedSeeds;

  Repetition(
      {required this.lotId,
      required this.seedsTotal,
      required this.germinatedSeeds});

  Map<String, dynamic> toMap() {
    return {
      RepetitionConst.kSEEDSTOTALCOLUMN: seedsTotal,
      RepetitionConst.kGERMINATEDSEEDSCOLUMN: germinatedSeeds,
      RepetitionConst.kIDLOTFOREIGNKEYREPETITION: lotId,
    };
  }

  Repetition.fromMap(Map map) {
    id = map[RepetitionConst.kIDREPETITIONCOLUMN];
    seedsTotal = map[RepetitionConst.kSEEDSTOTALCOLUMN];
    germinatedSeeds = map[RepetitionConst.kGERMINATEDSEEDSCOLUMN];
    lotId = map[RepetitionConst.kIDLOTFOREIGNKEYREPETITION];
  }

  /* // Função para adicionar sementes germinadas
  void adicionarSementesGerminadas(int germinatedSeeds) {
    String currentDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); // Obtém a data atual no formato 'yyyy-MM-dd'
    print("Data atual: $currentDate");
    print("Útima Data gravada: $lastRecordedDate");
    if (currentDate != lastRecordedDate) {
      currentDay++; // Incrementa o contador de dias
      lastRecordedDate = currentDate; // Atualiza a data registrada
      print("NOVO DIA: $currentDay");
      // Registra as sementes germinadas no novo dia
      dailyCount[currentDay] = germinatedSeeds;
      print("Sementes Germinadas no Dia $currentDay: $germinatedSeeds");
    } else {
      // Se for o mesmo dia, apenas atualiza o valor para o dia atual
      dailyCount[currentDay] = germinatedSeeds;
      print(
          "Sementes Germinadas (atualizadas) no Dia $currentDay: $germinatedSeeds");
    }
  } */
}
