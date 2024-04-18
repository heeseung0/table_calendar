import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar_practice/component/custom_text_field.dart';
import 'package:table_calendar_practice/const/colors.dart';
import 'package:table_calendar_practice/database/drift_database.dart';
import 'package:table_calendar_practice/model/schedule_model.dart';
import 'package:table_calendar_practice/provider/schedule_provider.dart';
import 'package:uuid/uuid.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // 이거 추가 안하면 위젯 가려짐

    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
              bottom: bottomInset,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: '시작 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        label: '종료 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: '내용',
                    isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSavePressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed(BuildContext context) async {
    //글로벌 키 사용 하는 것 공부 해야겠음.
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      //스케쥴 모델 생성하기
      final schedule = ScheduleModel(
        id: Uuid().v4(),
        content: content!,
        date: widget.selectedDate,
        startTime: startTime!,
        endTime: endTime!,
      );

      //스케쥴 모델 파이어스토어에 삽입하기
      await FirebaseFirestore.instance
          .collection(
            'schedule',
          )
          .doc(schedule.id)
          .set(schedule.toJson());

      /*
      await GetIt.I<LocalDatabase>().createSchedule(
        //일정 생성하기
        SchedulesCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedDate),
        ),
      );
       */

      /*
      context.read<ScheduleProvider>().createSchedule(
            schedule: ScheduleModel(
              id: 'new_model', //임시 ID
              content: content!,
              date: widget.selectedDate,
              startTime: startTime!,
              endTime: endTime!,
            ),
          );
       */

      Navigator.of(context).pop(); //일정 생성 후 화면 뒤로 가기
    }
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }

    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }

    return null;
  }
}
