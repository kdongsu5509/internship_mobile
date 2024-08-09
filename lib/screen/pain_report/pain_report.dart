import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2record/screen/pain_report/my_line_chart.dart';
import 'package:p2record/screen/pain_report/report_data.dart';
import '../../common/my_divider.dart';

// 이 코드 내에서만 리팩토링 합시다.

class PainReport extends StatefulWidget {
  final BuildContext context;

  PainReport({Key? key, required this.context}) : super(key: key);

  @override
  _PainReportState createState() => _PainReportState();
}

class _PainReportState extends State<PainReport> {
  DateTime? startDate; // 상단에서 관리하는 시작 날짜
  DateTime? endDate; // 상단에서 관리하는 종료 날짜
  String? _selectedValue; // 상단에서 관리하는 통증 부위
  bool isClicked = false;
  List<ReportData> reportData = [];

  void onChanged(newValue) {
    setState(() {
      _selectedValue = newValue;
    });
  }

  @override
  build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 7,
          child: PainAreaPicker(
            context: context,
            painArea: _selectedValue,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              SizedBox(width: 20),
              Text('조회 기간'),
              PainDatePicker(
                context: context,
                comment: '시작 날짜',
                selectedDate: startDate,
                onDateChanged: (DateTime? newDate) {
                  setState(() {
                    startDate = newDate;
                  });
                },
              ),
              PainDatePicker(
                context: context,
                comment: '종료 날짜',
                selectedDate: endDate,
                onDateChanged: (DateTime? newDate) {
                  setState(() {
                    endDate = newDate;
                  });
                },
              ),
              (!isClicked)
                  ? ElevatedButton(
                      onPressed: () {
                        if (startDate == null ||
                            endDate == null ||
                            _selectedValue == null) {
                          Fluttertoast.showToast(msg: '모든 값을 입력해주세요.');
                        } else {
                          if (!isClicked) {
                            setState(() {
                              isClicked = !isClicked;
                            });
                          }
                        }
                        print(
                            'startDate : $startDate, endDate : $endDate, painArea : $_selectedValue');
                      },
                      child: Text('조회'),
                    )
                  : Container(),
            ],
          ),
        ),
        MyDivider(indent: 0, endIndent: 0),
        //------------------------------------
        Expanded(
          flex: 55,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Text(
                    '통증 증감',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                isClicked
                    ? Column(
                        children: [
                          _PainReportCharts(
                            painArea: _selectedValue!,
                            startDate: startDate.toString().substring(0, 10),
                            endDate: endDate.toString().substring(0, 10),
                            reportData: reportData,
                          ),
                          Column(children: reportData.map((e) => EmotionChart(record: e, context: context)).toList(),),
                        ],
                      )
                    : SizedBox(child: Center(child: Text('조회 버튼을 눌러주세요.'))),
              ],
            ),
          ),
        ),
        MyDivider(indent: 0, endIndent: 0),
      ],
    );
  }
}

//--------------------------------------------------통증 부위 및 조회 기간------------------------------------------------------------------------------------------------------------------
class EmotionChart extends StatelessWidget {
  final ReportData record;
  final BuildContext context;

  const EmotionChart({required this.record, required this.context});

  @override
  Widget build(BuildContext context) {
    if (record == null) {
      print('record is null');
      return SizedBox.shrink();
    }else
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.createdAt.toString().substring(0, 10),
                  style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  record.createdAt.toString().substring(11),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  '상세(미구현)',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    record.painMood == '0'
                        ? Icons.sentiment_very_dissatisfied
                        : record.painMood == '1'
                        ? Icons.sentiment_neutral
                        : Icons.sentiment_very_satisfied,
                    color: record.painMood == '0'
                        ? Colors.red
                        : record.painMood == '1'
                        ? Colors.yellow
                        : Colors.green,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '통증 강도 : ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    record.painIntensity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      '나의 메모 : ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      record.note,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//--------------------------------------------------통증 증감 차트 부분-----------------------------------------------------------------------------------------------------------------------------

Widget _PainReportCharts({
  required String painArea,
  required String startDate,
  required String endDate,
  required List<ReportData> reportData,
}) {
  return FutureBuilder<Widget>(
    future: _generateChart(
      painArea: painArea,
      startDate: startDate,
      endDate: endDate,
      reportData: reportData,
    ),
    builder: (context, snapshot) {
      print(
          'at futureBuilder : painArea: $painArea, startDate: $startDate, endDate: $endDate');
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return snapshot.data ?? SizedBox.shrink();
      }
    },
  );
}

Future<Widget> _generateChart({
  required String painArea,
  required String startDate,
  required String endDate,
  required List<ReportData> reportData,
}) async {
  // Simulating fetching data and generating the chart
  await Future.delayed(Duration(seconds: 1)); // Simulating delay

  print(
      'at _generateChart : painArea: $painArea, startDate: $startDate, endDate: $endDate');

  return SizedBox(
    width: double.infinity,
    height: 250,
    child: MyLineChart(
      painArea: painArea,
      startDate: startDate,
      endDate: endDate,
      reportData: reportData,
    ),
  );
}

/**
 * 날짜 선택 -> 1개 만들어서 동시에 쓸거임.
 * */
class PainDatePicker extends StatefulWidget {
  final BuildContext context;
  final String comment;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged; // 새로운 콜백 추가

  PainDatePicker({
    required this.context,
    required this.comment,
    required this.selectedDate,
    required this.onDateChanged, // 생성자에 새로운 콜백 추가
    Key? key,
  }) : super(key: key);

  @override
  State<PainDatePicker> createState() => _PainDatePickerState();
}

class _PainDatePickerState extends State<PainDatePicker> {
  @override
  void initState() {
    super.initState();
    // initState에서 selectedDate 초기화
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // 새로운 날짜를 상위 위젯으로 전달
      widget.onDateChanged(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(widget.context),
      child: Text(
        widget.selectedDate != null
            ? '${widget.selectedDate!.year}-${widget.selectedDate!.month}-${widget.selectedDate!.day}'
            : widget.comment,
      ),
    );
  }
}

/**
 * 통증 부위 선택*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * */

class PainAreaPicker extends StatefulWidget {
  final BuildContext context;
  final String? painArea;
  final ValueChanged<String?> onChanged;

  PainAreaPicker({
    Key? key,
    required this.context,
    required this.painArea,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PainAreaPickerState createState() => _PainAreaPickerState();
}

class _PainAreaPickerState extends State<PainAreaPicker> {
  double fontSize = 12.0;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.painArea; // Initialize dropdown value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.035,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '통증 부위 : ',
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: DropdownButton<String>(
                    focusColor: Colors.black,
                    alignment: Alignment.center,
                    value: _selectedValue,
                    hint: Text(
                      '통증 부위 선택하기',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    items: <String>['손 / 손가락', '목 / 어깨', '등 / 허리', '다리 / 발']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: value == _selectedValue
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: value == _selectedValue
                                ? Color(0xFF007EFF)
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue; // Update selected value
                        widget.onChanged(newValue); // Callback to parent widget
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
