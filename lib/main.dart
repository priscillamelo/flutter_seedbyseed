import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter_seedbyseed/interface/screens/add_germinated_seeds.dart';
import 'package:flutter_seedbyseed/interface/screens/add_germination_test.dart';
import 'package:flutter_seedbyseed/interface/screens/details_germination_test.dart';
import 'package:flutter_seedbyseed/interface/widget/finished_tab.dart';
import 'package:flutter_seedbyseed/interface/widget/progress_tab.dart';
import 'package:flutter_seedbyseed/route/routes.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:flutter_seedbyseed/service/germinationTest/lot/lot_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GerminationTestRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => LotRepository(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Seed By Seed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routes: {
        PageRoutes.kHOME: (context) => const HomePage(),
        PageRoutes.kADD_GERMINATIONTEST: (context) =>
            const AddGerminationTest(),
        PageRoutes.kADD_GERMINATEDSEEDS: (context) =>
            const AddGerminatedSeeds(),
        PageRoutes.kDETAILS_GERMINATIONTEST: (context) =>
            const DetailsGerminationTest(),

        //PageRoutes.kUPDATE_GERMINATIONTEST: (context) => const UpdateGerminationTest(),
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //GerminationTest.totalUngerminatedSeed();
    //GerminationTest.calculateMeanRepetition();

    return Scaffold(
      // TODO: CRIAR UM COMPONENT PARA APPBAR
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Seed',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 64, 104, 25),
                ),
              ),
              TextSpan(
                text: ' By ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 94, 55, 31),
                ),
              ),
              TextSpan(
                text: 'Seed',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 34, 167, 195),
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            text: "Em Andamento",
          ),
          Tab(
            text: "Concluído",
          )
        ]),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [ProgressTab(), FinishedTab()]),
    );
  }
}
