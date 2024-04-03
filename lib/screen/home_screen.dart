import 'package:flutter/material.dart';
import 'package:table_calendar_practice/component/main_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //SafeArea : 시스템 UI랑 겹치지 않게 함.
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(),
          ],
        ),
      ),
    );
  }
}
