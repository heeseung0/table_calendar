import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar_practice/database/drift_database.dart';
import 'package:table_calendar_practice/firebase_options.dart';
import 'package:table_calendar_practice/provider/schedule_provider.dart';
import 'package:table_calendar_practice/repository/schedule_repository.dart';
import 'package:table_calendar_practice/screen/home_screen.dart';

void main() async {
  //플러터 프레임워크가 준비될 때 까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase 프로젝트 설정 함수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  final database = LocalDatabase(); // DB 생성

  // GetIt에 DB 변수 주입(싱글톤)
  // get_it 패키지는 DI를 구현하는 플러그인이다.
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => scheduleProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    ),
  );
}
