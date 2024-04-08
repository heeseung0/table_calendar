import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar_practice/screen/home_screen.dart';

void main() async {
  //플러터 프레임워크가 준비될 때 까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
