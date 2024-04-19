import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar_practice/component/main_calendar.dart';
import 'package:table_calendar_practice/component/schedule_bottom_sheet.dart';
import 'package:table_calendar_practice/component/schedule_card.dart';
import 'package:table_calendar_practice/component/today_banner.dart';
import 'package:table_calendar_practice/const/colors.dart';
import 'package:table_calendar_practice/model/schedule_model.dart';
import 'package:table_calendar_practice/screen/banner_ad_widget.dart';

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
    //Provider 관련 코드 삭제1
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          //BottomSheet 모달창으로 열기
          showModalBottomSheet(
            context: context,
            isDismissible: true, //배경 탭했을 때 BottomSheet 닫기
            isScrollControlled: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            //BottomSheet의 높이를 화면의 최대 높이로,
            //정의하고 스크롤 가능하게 변경
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
              onDaySelected: (selectedDate, focusedDate) => onDaySelected(
                  selectedDate, focusedDate, context), // 날짜가 선택됐을 때 실행할 함수
            ),
            const SizedBox(height: 8.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule')
                  .where(
                    'date',
                    isEqualTo:
                        '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule')
                  .where(
                    'date',
                    isEqualTo:
                        '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('일정 정보를 가져오지 못했습니다.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                print(snapshot.data!.docs);
                //ScheduleModel로 데이터 매핑하기
                final schedules = snapshot.data!.docs
                    .map(
                      (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                          json: (e.data() as Map<String, dynamic>)),
                    )
                    .toList();
                return ListView.separated(
                  itemCount: schedules.length,

                  //일정 중간 중간에 실행될 함수
                  separatorBuilder: (context, index) {
                    return const BannerAdWidget();
                  },
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];

                    return Dismissible(
                      key: ObjectKey(schedule.id),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (DismissDirection direction) {
                        //Provider 관련 코드 삭제3
                        FirebaseFirestore.instance
                            .collection('schedule')
                            .doc(schedule.id)
                            .delete();
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                          )),
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    setState(() {
      this.selectedDate = selectedDate;
    });
    //Provider 관련 코드 삭제2
  }
}
