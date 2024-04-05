import 'package:flutter/material.dart';
import 'package:table_calendar_practice/component/main_calendar.dart';
import 'package:table_calendar_practice/component/schedule_bottom_sheet.dart';
import 'package:table_calendar_practice/component/schedule_card.dart';
import 'package:table_calendar_practice/component/today_banner.dart';
import 'package:table_calendar_practice/const/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          //BottomSheet 모달창으로 열기
          showModalBottomSheet(
            context: context,
            isDismissible: true, //배경 탭했을 때 BottomSheet 닫기
            builder: (_) => const ScheduleBottomSheet(),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      //SafeArea : 시스템 UI랑 겹치지 않게 함.
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기
              onDaySelected: onDaySelected, // 날짜가 선택됐을 때 실행할 함수
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDate: selectedDate,
              count: 0,
            ),
            const SizedBox(height: 8.0),
            const ScheduleCard(
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부',
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
