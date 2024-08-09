import 'package:flutter/material.dart';
import 'package:p2record/request_fuction/record_request.dart'; // Replace with your actual import path
import 'package:table_calendar/table_calendar.dart';

class PainHistoryCalendar extends StatefulWidget {
  final String painArea;
  final void Function(List<Map<String, dynamic>> recordList) updateParent;

  PainHistoryCalendar({
    required this.painArea,
    required this.updateParent,
    Key? key,
  }) : super(key: key);

  @override
  State<PainHistoryCalendar> createState() => _PainHistoryCalendarState();
}


class _PainHistoryCalendarState extends State<PainHistoryCalendar> {
  DateTime selectedDay = DateTime.now();
  List<Map<String, dynamic>> recordList = [];
  Map<DateTime, List<dynamic>> _events = {};
  int cnt = 0;

  @override
  void initState() {
    super.initState();
    requestData(bodyPart: "");
  }

  Future<void> requestData({required String bodyPart}) async {
    setState(() {
      _events.clear(); // Clear previous events
      recordList.clear(); // Clear previous records
    });

    List<dynamic> temp = await requestSpecificRecordList(
      painArea: bodyPart,
      yearMonth:
          '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}',
    );

    List<Map<String, dynamic>> convertedList = temp.map((item) {
      return item as Map<String, dynamic>;
    }).toList();

    // Add fetched records to recordList
    recordList.addAll(convertedList); // 여기서 List<Map<String, dynamic>> convertedList를 recordList에 추가합니다.

    // Update events based on new records
    updateEvents();
    widget.updateParent(recordList);
  }

  void selectedDateChange(DateTime date) {
    setState(() {
      selectedDay = date;
      cnt = 0;
    });
    requestData(bodyPart: widget.painArea); // Request data and update
  }

  void updateOrder() { /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    List<DateTime> keys = _events.keys.toList();
    keys.sort((a, b) => a.difference(selectedDay).abs().compareTo(b.difference(selectedDay).abs()));

    List<Map<String, dynamic>> convertedList = [];

    for (var key in keys) {
      for (var record in _events[key]!) {
        convertedList.add(record);
      }
    }
    widget.updateParent(convertedList);
  }

  void updateEvents() {
    _events = {};

    for (var record in recordList) {
      DateTime createdAt = DateTime.parse(record['createdAt']);
      DateTime date = DateTime(createdAt.year, createdAt.month, createdAt.day);

      if (_events.containsKey(date)) {
        _events[date]!.add(record); // Add record to existing date's list
      } else {
        _events[date] = [record]; // Create new list for the date and add record
      }
    }
  }


  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1.0,
      ),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return Expanded(
      flex: 85,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: TableCalendar(
              daysOfWeekHeight: 30.0,
              locale: 'ko_KR',
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: DateTime(2024, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: this.selectedDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                // 같은 달, 다른 날짜를 선택했을 때만 setState
                if(this.selectedDay.month == selectedDay.month && this.selectedDay.day != selectedDay.day){
                  setState(() {
                    this.selectedDay = selectedDay;
                    requestData(bodyPart: widget.painArea);
                  });
                }
                else if (this.selectedDay.day == selectedDay.day){
                  setState(() {
                    updateEvents();
                    updateOrder();
                  });
                }
                else if (this.selectedDay.month != selectedDay.month) { // 다른 달이어야지 바
                  setState(() {
                    this.selectedDay = selectedDay;
                    requestData(bodyPart: widget.painArea);
                  });
                }
              },
              selectedDayPredicate: (date) {
                return isSameDay(selectedDay, date);
              },
              eventLoader: _getEventsForDay,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: defaultBoxDecoration,
                    child: Text(
                      day.day.toString(),
                      style: defaultTextStyle,
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  final DateTime _date =
                      DateTime(date.year, date.month, date.day);
                  if (_events.containsKey(_date)) {
                    return Container(
                      width: 40,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Container(
                              width: 30,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _events[_date]!
                                      .map((record) => feelToCircle(
                                      int.parse(record['painMood'])))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                defaultDecoration: defaultBoxDecoration,
                weekendDecoration: defaultBoxDecoration,
                selectedDecoration: defaultBoxDecoration.copyWith(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
                todayDecoration: defaultBoxDecoration.copyWith(
                  color: Colors.blue[100],
                ),
                outsideDecoration: defaultBoxDecoration.copyWith(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                defaultTextStyle: defaultTextStyle,
                weekendTextStyle: defaultTextStyle,
                selectedTextStyle: defaultTextStyle.copyWith(
                  color: Colors.blue,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 1,
            right: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  requestData(bodyPart: "");
                },
                child: Text('${selectedDay.month}월 전체 보기', style: TextStyle(color: Colors.blue),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon feelToCircle(int painMood) {
    switch (painMood) {
      case 0:
        return Icon(
          Icons.circle,
          color: Colors.red,
          size: 8,
        );
      case 1:
        return Icon(
          Icons.circle,
          color: Colors.yellow,
          size: 8,
        );
      case 2:
        return Icon(
          Icons.circle,
          color: Colors.green,
          size: 8,
        );
      default:
        return Icon(
          Icons.circle,
          color: Colors.black,
          size: 8,
        );
    }
  }
}
