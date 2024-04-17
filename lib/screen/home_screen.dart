import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar_practice/component/main_calendar.dart';
import 'package:table_calendar_practice/component/schedule_bottom_sheet.dart';
import 'package:table_calendar_practice/component/schedule_card.dart';
import 'package:table_calendar_practice/component/today_banner.dart';
import 'package:table_calendar_practice/const/colors.dart';
import 'package:table_calendar_practice/database/drift_database.dart';
import 'package:table_calendar_practice/provider/schedule_provider.dart';

class HomeScreenState extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    // 프로바이더 변경이 있을 때마다 build() 함수 재실행
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate; // 선택된 날짜
    // 선택된 날짜에 해당하는 일정 가져오기
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          //BottomSheet 모달창으로 열기
          showModalBottomSheet(
            context: context,
            isDismissible: true, //배경 탭했을 때 BottomSheet 닫기
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            //BottomSheet의 높이를 화면의 최대 높이로,
            //정의하고 스크롤 가능하게 변경
            isScrollControlled: true,
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
            StreamBuilder(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.length ?? 0,
                );
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final schedule = snapshot.data![index];
                      return Dismissible(
                        //유니크 키값
                        key: ObjectKey(schedule.id),
                        //밀기 방향(오른쪽에서 왼쪽으로)
                        direction: DismissDirection.startToEnd,
                        //밀기 했을 때 실행할 함수
                        onDismissed: (DismissDirection direction) {
                          GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {}
}
