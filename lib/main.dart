import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/page/add_germinated_seeds.dart';
import 'package:flutter_seedbyseed/interface/page/add_germination_test.dart';
import 'package:flutter_seedbyseed/interface/widget/completed_tab.dart';
import 'package:flutter_seedbyseed/interface/widget/progress_tab.dart';
import 'package:flutter_seedbyseed/route/routes.dart';
import 'package:flutter_seedbyseed/service/germinationTest/germination_test_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
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
    return Scaffold(
      // TODO: CRIAR UM COMPONENT PARA APPBAR
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo1.png",
              width: 60,
            ),
            Image.asset(
              "assets/images/seed_logo.png",
              width: 30,
            ),
            Image.asset(
              "assets/images/logo2.png",
              width: 60,
            ),
          ],
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
          children: const [ProgressTab(), CompletedTab()]),
    );
  }
}
