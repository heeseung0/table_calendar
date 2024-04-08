import 'package:drift/drift.dart';

/*
  SQLite로 sql문을 사용하지 않고 디비 구축
 */

class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()(); //PRIMARY KEY, 정수 열
  TextColumn get content => text()(); //내용, 글자 열
  DateTimeColumn get date => dateTime()(); //일정 날짜, 날짜 열
  IntColumn get startTime => integer()(); //시작 시간
  IntColumn get endTime => integer()(); //종료 시간
}
