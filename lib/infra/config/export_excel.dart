import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/lot.dart'; // Certifique-se que o caminho do modelo Lot está correto
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> lidarComExportacao(BuildContext context, List<Lot> lotes) async {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Gerando relatório, por favor aguarde...")),
  );

  final Map<int, List<double>> mapaDePercentuais = {};
  for (final lote in lotes) {
    mapaDePercentuais[lote.numberLot] =
        await lote.calculatePercGerminatedSeedsPerRepetition();
  }

  final fileBytes = _gerarBytesDoExcel(lotes, mapaDePercentuais);

  if (fileBytes != null) {
    final file =
        await salvarExcelLocalmente(fileBytes, "relatorio_germinacao.xlsx");
    await compartilharArquivo(file);

    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Arquivo pronto para compartilhamento!")),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao gerar o arquivo.")),
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

Future<File> salvarExcelLocalmente(Uint8List bytes, String nomeArquivo) async {
  final dir =
      await getApplicationDocumentsDirectory(); // diretório privado do app
  final path = '${dir.path}/$nomeArquivo';

  final file = File(path);
  await file.writeAsBytes(bytes);
  return file;
}

Future<void> compartilharArquivo(File file) async {
  final xfile = XFile(file.path);
  await SharePlus.instance.share(
    ShareParams(
      files: [xfile],
      text: 'Relatório de Germinação',
    ),
  );
}

/// Salva uma lista de bytes em um arquivo na pasta de Downloads do dispositivo.

/// Solicita permissão de armazenamento de forma robusta e correta.
Future<bool> solicitarPermissao(BuildContext context) async {
  var status = await Permission.storage.status;
  debugPrint("Status inicial da permissão: $status");

  // 1. Se a permissão já foi concedida, retorna 'true' e termina.
  if (status.isGranted) {
    return true;
  }

  // 2. Se foi permanentemente negada, guia o usuário para as configurações.
  if (status.isPermanentlyDenied) {
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permissão Necessária"),
          content: const Text(
              "A permissão de armazenamento foi negada permanentemente. Por favor, habilite-a nas configurações do aplicativo."),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Abrir Configurações"),
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    return false;
  }

  // 3. ESTA É A PARTE IMPORTANTE: Se a permissão foi apenas negada (ou nunca pedida).
  if (status.isDenied) {
    if (context.mounted) {
      // Mostra o diálogo explicando POR QUE você precisa da permissão.
      final bool? usuarioConcordou = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Opcional: impede fechar clicando fora
        builder: (context) => AlertDialog(
          title: const Text("Permissão Necessária"),
          content: const Text(
              "Para salvar o relatório em Excel, o aplicativo precisa da sua permissão para acessar o armazenamento."),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context, false), // Retorna 'false'
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context, true), // Retorna 'true'
            ),
          ],
        ),
      );

      debugPrint("Usuário concordou? $usuarioConcordou");

      // 4. Se o usuário clicou em "OK" (usuarioConcordou == true)...
      if (usuarioConcordou == true) {
        // ...ENTÃO, E SOMENTE ENTÃO, pedimos a permissão REAL ao sistema Android.
        final result = await Permission.storage.request();
        debugPrint(result.toString());
        // O resultado final (true ou false) depende da escolha do usuário no diálogo do SISTEMA.
        return usuarioConcordou!;
      }
    }
  }

  // Se o usuário cancelou o nosso diálogo ou o status é outro, retorna false.
  return false;
}
