import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar_practice/const/colors.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; //날짜 선택 시 실행할 함수
  final DateTime selectedDate; //선택된 날짜

  const MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr', //한국어로 언어 변경
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      focusedDay: DateTime.now(), //화면에 보여지는 날
      firstDay: DateTime(1800, 1, 1), //첫째 날
      lastDay: DateTime(3000, 1, 1),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: PRIMARY_COLOR,
        ),
      ),
    ); //마지막 날
  }
}
