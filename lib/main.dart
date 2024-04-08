import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar_practice/database/drift_database.dart';
import 'package:table_calendar_practice/screen/home_screen.dart';

void main() async {
  //플러터 프레임워크가 준비될 때 까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  final database = LocalDatabase(); // DB 생성

  // GetIt에 DB 변수 주입(싱글톤)
  // get_it 패키지는 DI를 구현하는 플러그인이다.
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
