import 'package:flutter/material.dart';
import 'package:table_calendar_practice/model/schedule_model.dart';
import 'package:table_calendar_practice/repository/schedule_repository.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository; //API 요청 로직을 담은 클래스

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {}; //일정 정보를 저장해둘 변수

  ScheduleProvider({
    required this.repository,
  }) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({required DateTime date}) async {
    final resp = await repository.getSchedules(date: date); //GET 요청

    //ifAbsent 매개변수는 date에 해당되는 key값이 존재하지 않을 때 실행되는 함수이다.
    cache.update(date, (value) => resp,
        ifAbsent: () => resp); //선택한 날짜의 일정들 업데이트하기

    //해당 함수를 실행하면 현재 클래스를 watch()하고있는 모든 위젯들의 build()함수를 다시 실행한다.
    notifyListeners(); //리슨하는 위젯들 업데이트하기
  }

  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final savedSchedule = await repository.createSchedule(schedule: schedule);

    final targetDate = schedule.date;

    const uuid = Uuid();

    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(
      id: tempId,
    );

    cache.update(
      targetDate,
      (value) => [
        //현존하는 캐시 리스트 끝에 새로운 일정 추가
        ...value,
        newSchedule,
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      //날짜에 해당되는 값이 없다면 새로운 리스트에 새로운 일정 하나만 추가
      ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try {
      //api 요청
      final savedSchedule = await repository.createSchedule(schedule: schedule);

      //서버 응답 기반으로 캐시 업데이트
      cache.update(
          targetDate,
          (value) => value
              .map((e) => e.id == tempId
                  ? e.copyWith(
                      id: savedSchedule,
                    )
                  : e)
              .toList());
    } catch (e) {
      //삭제 실패 시 캐시 롤백하기
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final resp = await repository.deleteSchedule(id: id);

    final targetSchedule = cache[date]!.firstWhere(
      (e) => e.id == id,
    );

    //긍정적 응답 (응답 전에 캐시 먼저 업데이트)
    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    //캐시 업데이트 반영하기
    notifyListeners();

    //캐시에서 데이터 삭제
    try {
      await repository.deleteSchedule(id: id);
    } catch (e) {
      //삭제 실패 시 캐시 롤백하기
      cache.update(
        date,
        (value) => [...value, targetSchedule]..sort(
            (a, b) => a.startTime.compareTo(
              b.startTime,
            ),
          ),
      );
      notifyListeners();
    }
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    //현재 선택된 날짜를 매개변수로 입력받은 날짜로 변경
    selectedDate = date;
    notifyListeners();
  }
}
