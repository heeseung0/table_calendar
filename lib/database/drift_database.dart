import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // path 같은 이름이 많아서 편하게 쓰기 위해
import 'package:table_calendar_practice/model/schedule.dart';
import 'package:drift/drift.dart';

//private값까지 불러올 수 있음

/*
  part 파일은 import와 비슷한 기능을 가지고 있다.
  part 파일로 파일을 지정하면 해당 파일의 값들을 현재 파일에서 사용할 수 있게 된다.
  하지만 public 값들만 사용할 수 있는 import 기능과 달리,
  part 파일은 private 값들도 사용할 수 있는 차이가 있다.
 */

// .g 파일에 에러가 날 경우 코드 생성이 되지 않아서 그렇다.
// flutter pub run build_runner build
part 'drift_database.g.dart'; //part 파일 지정

@DriftDatabase(
  //사용할 테이블 등록
  tables: [
    Schedules,
  ],
)

//Code Generation으로 생성할 클래스 상속
//_$를 추가한 부모 클래스를 상속하면, 현재 존재하지 않지만 코드 생성을 실행하면 생성된다.
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // 데이터를 조회하고 변화 감지
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  // INSERT 주의 사항 : into() 함수를 먼저 사용해서 테이블을 지정해준 다음, insert()함수를 이어서 사용해야 한다.
  // 또한 데이터 생성에는 꼭 생성된 Companion 클래스를 통하여 값들을 넣어줘야 한다.
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  // SELECT에서 watch와 get을 사용하듯,
  // DELETE에서는 go 함수를 실행해줘야 삭제가 완료된다.
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  /*
    Drift DB 클래스는 "필수"로 schemaVersion값을 지정해줘야 한다.
    기본적으로 1부터 시작하고, 테이블의 변화가 있을 때마다 1씩 올라가며
    테이블 구조가 변경된다는 걸 드리프트에 인지시켜주는 기능이다.
   */
  @override
  int get schemaVersion => 1;
}

/*
  Drift DB 객체는 부모 생성자에 "필수"로 LazyDatabase를 넣어줘야 한다.
  LazyDatabase 객체에는 db를 생성할 위치에 대한 정보만 입력해주면 된다.
 */
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
