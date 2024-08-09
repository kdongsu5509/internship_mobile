import 'package:flutter/material.dart';

class MyDateTimePicker extends StatelessWidget {
  final void Function(DateTime) onDateChanged;
  final void Function(TimeOfDay) onTimeChanged;
  final DateTime? startDate;
  final TimeOfDay? startTime;

  const MyDateTimePicker({
    required this.onDateChanged,
    required this.onTimeChanged,
    this.startDate,
    this.startTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: Color(0x3FE0E0E0),
                border: Border.all(
                  color: Colors.grey[400]!,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  startDate == null
                      ? '날짜를 선택해 주세요'
                      : '${startDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2010),
              lastDate: DateTime(2030),
            );
            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
        ),
        SizedBox(width: 16), // 여백 추가
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: Color(0x3FE0E0E0),
                border: Border.all(
                  color: Colors.grey[400]!,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  startTime == null
                      ? '시간을 선택해 주세요'
                      : '${startTime!.format(context)}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                onTimeChanged(pickedTime);
              }
            },
          ),
        ),
      ],
    );
  }
}
