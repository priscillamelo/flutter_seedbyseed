import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart'; // Certifique-se que o caminho do modelo Lot está correto
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> lidarComExportacao(BuildContext context, List<Lot> lotes) async {
  // 1. Lida com a permissão primeiro
  final bool permissaoConcedida = await solicitarPermissao(context);

  // 2. Se a permissão não for concedida, pare o processo.
  if (!permissaoConcedida || !context.mounted) return;

  // 3. Se a permissão foi concedida, gere os bytes do arquivo
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Gerando relatório, por favor aguarde...")),
  );

  final Map<int, List<double>> mapaDePercentuais = {};
  for (final lote in lotes) {
    mapaDePercentuais[lote.numberLot] =
        await lote.calculatePercGerminatedSeedsPerRepetition();
  }

  final fileBytes = _gerarBytesDoExcel(lotes, mapaDePercentuais);

  // 4. Salve o arquivo se os bytes foram gerados com sucesso
  if (fileBytes != null) {
    await _salvarArquivo(fileBytes, "relatorio_germinacao.xlsx");
    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Relatório salvo na pasta Downloads!")),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocorreu um erro ao gerar o relatório.")),
      );
    }
  }
}

/// Cria um arquivo Excel em memória com os dados dos lotes e retorna seus bytes.
Uint8List? _gerarBytesDoExcel(
  List<Lot> lotes,
  Map<int, List<double>> mapaDePercentuais,
) {
  if (lotes.isEmpty) {
    debugPrint("A lista de lotes está vazia. Nenhum arquivo foi gerado.");
    return null;
  }

  final excel = Excel.createExcel();
  final Sheet sheet = excel['Germinação'];
  excel.delete("Sheet1");

  // --- ESTILOS ---
  final estiloCabecalho = CellStyle(
    bold: true,
    backgroundColorHex: ExcelColor.grey50,
    fontFamily: getFontFamily(FontFamily.Arial),
    verticalAlign: VerticalAlign.Center,
    horizontalAlign: HorizontalAlign.Center,
  );

  final coresLotes = [
    ExcelColor.pink50,
    ExcelColor.yellow50,
    ExcelColor.blue50,
    ExcelColor.green50,
    ExcelColor.purple50,
  ];

  // --- CABEÇALHO ---
  final dias = lotes.first.dailyCount.keys.toList()..sort();
  final tituloAmostra = "Amostra";
  final tituloRepeticao = "Rep.";
  final titulosDias = dias.map((dia) => dia.toString()).toList();
  final tituloSementesGerminadas = "Germ.";
  final tituloGerminacaoPercent = "G(%)";
  final tituloMediaGerminacao = "M. G.(%)";
  final tituloIVG = "IVG";
  final tituloMediaIVG = "M. IVG(%)";

  final List<String> cabecalho = [
    tituloAmostra,
    tituloRepeticao,
    ...titulosDias,
    tituloSementesGerminadas,
    tituloGerminacaoPercent,
    tituloMediaGerminacao,
    tituloIVG,
    tituloMediaIVG
  ];

  sheet.appendRow(cabecalho.map((valor) => TextCellValue(valor)).toList());
  for (var cell in sheet.row(0)) {
    cell?.cellStyle = estiloCabecalho;
  }

  for (int i = 0; i < cabecalho.length; i++) {
    sheet.setColumnWidth(i + 2, 8);
  }

  // --- DADOS ---
  int linhaInicialLote = 1;
  for (int i = 0; i < lotes.length; i++) {
    final lote = lotes[i];
    final corLote = coresLotes[i % coresLotes.length];
    final estiloLote = CellStyle(
      backgroundColorHex: corLote,
      fontFamily: getFontFamily(FontFamily.Calibri),
      verticalAlign: VerticalAlign.Center,
    );

    final qtdRepeticoes = lotes.first.dailyCount[dias.first]?.length ?? 0;

    final List<double> percGerminadasDoLote =
        mapaDePercentuais[lote.numberLot] ?? [];
    final double mediaSementesGerminadas = (percGerminadasDoLote.isEmpty)
        ? 0.0
        : percGerminadasDoLote.reduce((a, b) => a + b) /
            percGerminadasDoLote.length;
    final double mediaIVG = lote.averageIVG;

    for (int repIndex = 0; repIndex < qtdRepeticoes; repIndex++) {
      final int totalGerminadas = lote.dailyCount.values.fold(0, (sum, lista) {
        return sum +
            ((lista != null && repIndex < lista.length) ? lista[repIndex] : 0);
      });

      final double percGerminada = (repIndex < percGerminadasDoLote.length)
          ? percGerminadasDoLote[repIndex]
          : 0.0;

      final double ivg = lote.ivgPerLot["R${repIndex + 1}"] ?? 0.0;

      final List<CellValue> linha = [
        TextCellValue(repIndex == 0 ? "LOTE ${lote.numberLot}" : ""),
        TextCellValue("R${repIndex + 1}"),
      ];

      // dias
      for (var dia in dias) {
        final repeticoesDoDia = lote.dailyCount[dia]?[repIndex] ?? 0;
        linha.add(IntCellValue(repeticoesDoDia));
      }

      // Adiciona as colunas calculadas
      linha.add(IntCellValue(totalGerminadas)); // Total por repetição
      linha.add(DoubleCellValue(percGerminada)); // % Germinação por repetição
      linha.add(DoubleCellValue(mediaSementesGerminadas)); // Média do LOTE
      linha.add(DoubleCellValue(ivg)); // IVG por repetição
      linha.add(DoubleCellValue(mediaIVG)); // Média IVG do LOTE

      sheet.appendRow(linha);
      final rowIndex = sheet.maxRows - 1;
      for (int colIndex = 0; colIndex < linha.length; colIndex++) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .cellStyle = estiloLote;
      }
    }
    if (qtdRepeticoes > 1) {
      // Função auxiliar para simplificar a mesclagem
      void mergeCellsForLot(String columnName) {
        final colIndex = cabecalho.indexOf(columnName);
        if (colIndex != -1) {
          sheet.merge(
            CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: linhaInicialLote),
            CellIndex.indexByColumnRow(
                columnIndex: colIndex,
                rowIndex: linhaInicialLote + qtdRepeticoes - 1),
          );
        }
      }

      mergeCellsForLot(tituloAmostra);
      mergeCellsForLot(tituloMediaGerminacao);
      mergeCellsForLot(tituloMediaIVG);
    }
    linhaInicialLote += qtdRepeticoes;
  }

  // Retorna os bytes do arquivo gerado
  return Uint8List.fromList(excel.save()!);
}

/// Salva uma lista de bytes em um arquivo na pasta de Downloads do dispositivo.
Future<void> _salvarArquivo(Uint8List bytes, String nomeArquivo) async {
  try {
    final directory = await getDownloadDirectory();

    if (directory == null) return;

    final path = "${directory.path}/$nomeArquivo";
    final file = File(path);

    await file.writeAsBytes(bytes);
    debugPrint("✅ Arquivo salvo em: $path");
  } catch (e) {
    debugPrint("❌ Erro ao salvar o arquivo: $e");
  }
}

Future<bool> solicitarPermissao(BuildContext context) async {
  var status = await Permission.storage.status;
  bool? permissaoConcedida = true;
  if (status.isGranted) return permissaoConcedida;

  if (status.isDenied) {
    if (context.mounted) {
      permissaoConcedida = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permissão Necessária"),
          content: const Text(
              "Precisamos da sua permissão de armazenamento para salvar o relatório em Excel no seu dispositivo."),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      );
    }
    return permissaoConcedida ?? false;
  }

  if (status.isPermanentlyDenied) {
    if (context.mounted) {
      permissaoConcedida = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permissão Necessária"),
          content: const Text(
              "A permissão de armazenamento foi negada permanentemente. Para salvar arquivos, você precisa habilitá-la manualmente nas configurações do aplicativo."),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text("Abrir Configurações"),
              onPressed: () {
                openAppSettings(); // Abre as configurações do app
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      );
    }
    return permissaoConcedida ?? false;
  }

  return permissaoConcedida;
}

Future<Directory?> getDownloadDirectory() async {
  if (Platform.isAndroid) {
    final directory = Directory('/storage/emulated/0/Download');
    if (await directory.exists()) {
      return directory;
    } else {
      debugPrint("❌ Diretório de Downloads não encontrado.");
      return null;
    }
  } else if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  }
  return null;
}
