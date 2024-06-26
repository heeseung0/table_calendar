import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar_practice/firebase_options.dart';
import 'package:table_calendar_practice/screen/home_screen.dart';

void main() async {
  //플러터 프레임워크가 준비될 때 까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  //광고 기능 초기화하기
  MobileAds.instance.initialize();

  //Firebase 프로젝트 설정 함수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  //코드 정리
  //Firebase로 이전

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
