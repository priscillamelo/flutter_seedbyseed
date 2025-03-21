import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/repetition_future_builder.dart';
import 'package:flutter_seedbyseed/model/germinationTest/germination_test.dart';
import 'package:flutter_seedbyseed/model/germinationTest/lot/lot.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';

class LotFutureBuilder extends StatefulWidget {
  final GerminationTest germinationTest;

  const LotFutureBuilder({super.key, required this.germinationTest});

  @override
  State<LotFutureBuilder> createState() => _LotFutureBuilderState();
}

class _LotFutureBuilderState extends State<LotFutureBuilder>
    with TickerProviderStateMixin {
  late LotRepository lotRepository;
  late Future<List<Lot>> listLot;
  late PageController _pageViewController;
  int _currentPageIndex = 0;
  bool lastPage = false;

  @override
  void initState() {
    super.initState();
    lotRepository = LotRepository();
    listLot = lotRepository.getAllLots(widget.germinationTest.id);
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listLot,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPageIndex > 0
                          ? IconButton(
                              onPressed: () {
                                _pageViewController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              iconSize: 32,
                            )
                          : const SizedBox(width: 48),
                      Text(
                        "Lote ${snapshot.data![_currentPageIndex].numberLot}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _currentPageIndex < snapshot.data!.length - 1
                          ? IconButton(
                              onPressed: () {
                                _pageViewController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              iconSize: 32,
                            )
                          : const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                      itemCount: snapshot.data!.length,
                      controller: _pageViewController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index; // Atualiza o lote atual
                          //print(lastPage);
                        });
                      },
                      itemBuilder: (context, index) {
                        lastPage =
                            _currentPageIndex == snapshot.data!.length - 1;
                        return Center(
                          child: RepetitionFutureBuilder(
                            idLot: snapshot.data![index].id,
                            germinationTest: widget.germinationTest,
                            lastPage: lastPage,
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Nenhum lote cadastrado'),
            );
          }
        });
  }
}
