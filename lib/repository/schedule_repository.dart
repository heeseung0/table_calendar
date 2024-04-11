import 'dart:io';

import 'package:dio/dio.dart';
import 'package:table_calendar_practice/model/schedule_model.dart';

class ScheduleRepository {
  final _dio = Dio();
  //안드로이드에서는 10.0.2.2가 localhost에 해당함
  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      //코팩 예시 사이트에선 매개변수는 YYYYMMDD 형태로 GET요청을 하고,
      //response는 ScheduleModel로 다시 매핑하여 받는다.
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );

    return resp.data
        .map<ScheduleModel>((x) => ScheduleModel.fromJson(json: x))
        .toList();
  }

  //Create를 할때는 데이터의 id값을 반환한다.
  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();
    final resp = await _dio.post(_targetUrl, data: json);
    return resp.data?['id'];
  }

  //Delete를 할때는 데이터의 id값을 매개변수로, 성공하면 다시 id값을 반환한다. 왜 다시 id를 주는지는 모르겠음
  Future<String> deleteSchedule({
    required String id,
  }) async {
    final resp = await _dio.delete(_targetUrl, data: {'id': id});
    return resp.data?['id'];
  }
}
