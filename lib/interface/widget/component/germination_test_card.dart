import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/domain/model/germination_test.dart';
import 'package:flutter_seedbyseed/infra/config/verify_date.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GerminationTestCard extends StatelessWidget {
  final GerminationTest germinationTest;
  final VoidCallback? onTap;
  final VoidCallback onLongPress;

  const GerminationTestCard(
      {super.key,
      required this.germinationTest,
      required this.onTap,
      required this.onLongPress});

  Widget _buildInfoSecondary(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalSeeds = germinationTest.totalSeeds;
    final int germinatedSeeds = germinationTest.germinatedSeeds;
    final double valueIndicatorGerminatedSeeds = (germinatedSeeds / totalSeeds);
    final double percGerminated = valueIndicatorGerminatedSeeds * 100;

    debugPrint("TotalSeeds: $totalSeeds");
    debugPrint("GerminatedSeeds: $germinatedSeeds");
    debugPrint("Value of Indicator: $valueIndicatorGerminatedSeeds");
    debugPrint("Percentual Germinated: $percGerminated");

    double heightScreen = MediaQuery.of(context).size.height * 0.14;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(children: [
        Card(
          margin: EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            height: heightScreen,
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircularProgressIndicator(
                        padding: EdgeInsetsGeometry.all(24),
                        constraints:
                            BoxConstraints(minHeight: 80, minWidth: 80),
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        value: valueIndicatorGerminatedSeeds,
                        strokeWidth: 6,
                      ),
                      Text(
                        "${percGerminated.toStringAsFixed(0)}%",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText(
                            germinationTest.species,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 16,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildInfoSecondary(
                              FontAwesomeIcons.seedling,
                              Colors.green,
                              '$germinatedSeeds/$totalSeeds sementes germinadas'),
                          _buildInfoSecondary(
                            Icons.calendar_month_rounded,
                            Colors.blue,
                            "Dia: ${germinationTest.currentDay} de ${germinationTest.lastCount}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        if (onTap == null)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                "Data da primeira contagem:\n${VerifyDate.normalizeDayMonth(germinationTest.calculateCountDate(germinationTest.firstCount))}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
