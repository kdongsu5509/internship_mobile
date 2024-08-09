import 'package:flutter/material.dart';
import 'package:p2record/picker/myDateTimePicker.dart';
import 'package:p2record/request_fuction/record_request.dart'; // 실제 사용하는 임포트 경로로 대체해야 합니다.
import '../../UserData/MYTOKEN.dart'; // 실제 사용하는 임포트 경로로 대체해야 합니다.
import '../../boxes/symtom_box.dart'; // 실제 사용하는 임포트 경로로 대체해야 합니다.
import '../../common/only_title_appbar.dart'; // 실제 사용하는 임포트 경로로 대체해야 합니다.
import '../../common/questionTextStyle.dart'; // 실제 사용하는 임포트 경로로 대체해야 합니다.
import '../pain_record/pain_record_page_title.dart';
import '../tapbar_screen.dart'; // 실제 사용하는 임포트 경로로 대체해야 합니다.

class AddPainFrame extends StatefulWidget {
  const AddPainFrame({required this.painArea, required this.groupId, Key? key})
      : super(key: key);

  final String painArea;
  final int groupId;

  @override
  State<AddPainFrame> createState() => _AddPainFrameState();
}

class _AddPainFrameState extends State<AddPainFrame> {
  late List<String> _pastList; // 과거 통증 기록을 담는 문자열 리스트
  Map<int, Map<String, dynamic>> _pastSymptoms = {}; // id와 선택 여부를 포함한 과거 증상들
  DateTime? startDate;
  TimeOfDay? startTime = TimeOfDay.now();
  bool isStartDateSelected = false;
  bool isStartTimeSelected = false;
  DateTime? endDate;
  TimeOfDay? endTime = TimeOfDay.now();
  double sliderValue = 0;
  int painMoodVal = 0;
  String userNote = "";

  bool isDone = false;

  @override
  void initState() {
    super.initState();
    _pastList = []; // 초기화
    sliderValue = 0; // 슬라이더 값을 0으로 초기화
    _getPastSymptoms(); // 과거 통증 기록을 가져오는 메서드 호출
  }

  void _getPastSymptoms() async {
    try {
      // 실제 API 호출 등을 통해 과거 증상을 가져옵니다.
      List<Map<String, dynamic>> response =
          await getPastSymptoms(widget.groupId);

      // response를 기반으로 _pastSymptoms를 초기화합니다.
      _pastSymptoms = {
        for (var i = 0; i < response.length; i++)
          response[i]['id']: {
            'symptom': response[i]['symptom'],
            'isSelected': true
          },
      };

      setState(() {
        // _pastList는 symptom들의 리스트로 초기화됩니다.
        _pastList = response.map((e) => e['symptom'] as String).toList();
        isDone = true;
      });
    } catch (e) {
      // 에러 처리 로직
      print('\n\n\n -add_pain_frame.dart에서 에러 발생\n\n\n');
      print('에러 : ${e}');
    }
  }

  void onDateChanged(DateTime date) {
    isStartDateSelected = !isStartDateSelected;
    setState(() {
      isStartDateSelected ? endDate = date : startDate = date;
    });
  }

  void onTimeChanged(TimeOfDay time) {
    isStartTimeSelected = !isStartTimeSelected;
    setState(() {
      isStartTimeSelected ? endTime = time : startTime = time;
    });
  }

  void onSliderChanged(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  void _handleSymptomTap(String symptom) {
    setState(() {
      // 선택된 증상의 isSelected를 토글합니다.
      _pastSymptoms.forEach((key, value) {
        if (value['symptom'] == symptom) {
          value['isSelected'] = !value['isSelected'];
        }
      });
    });
  }

  void _handleFeelIconTap(int val) {
    setState(() {
      painMoodVal = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDone ?  Scaffold(
      appBar: OnlyTitleAppbar.createAppBar("통증 기록"), // 커스텀 앱바
      body: Column(
        children: [
          PainRecordPageTitle(
            explainText: "님의 ${widget.painArea} 통증 기록,", // 설명 텍스트
            explain_text_fontSize: 15.0, // 폰트 크기
          ),
          _middle(), // 중간 부분 위젯 호출
          _saveButton(
            context: context,
            groupId: widget.groupId,
            rs: _pastSymptoms,
            startTime: '${startTime!.hour}:${startTime!.minute}:00',
            endTime: '${endTime!.hour}:${endTime!.minute}:00',
            sliderValue: sliderValue,
            painMoodVal: painMoodVal,
            note: userNote,
          ), // 저장 버튼
        ],
      ),
    ) : Center(child: CircularProgressIndicator());
  }

  Widget _middle() {
    // 디버그용 로그
    print('---------add_pain_frame.dart에서 출력---------');
    print(widget.groupId); // groupId 출력
    print(MYTOKEN); // 토큰 출력

    // 과거 통증 기록을 위한 SymtomBox 위젯들의 리스트 생성
    List<Widget> pastWidgets = _pastList.map((element) {
      return SymtomBox(
        text: element,
        // 텍스트는 증상 문자열
        isSelected: _pastSymptoms.keys
            .where((key) => _pastSymptoms[key]!['symptom'] == element)
            .map((e) => _pastSymptoms[e]!['isSelected'])
            .first,
        // 선택 여부는 _pastSymptoms를 통해 가져옵니다.
        onTap: () => _handleSymptomTap(element),
        // 탭 핸들러
        basic: BoxDecoration(
          color: Colors.white60,
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        selected: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        textStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      );
    }).toList();

    // Expanded를 사용하여 공간을 확보하고 Column으로 위젯들을 배치합니다.
    return Expanded(
      flex: 8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('통증은 어떤 느낌인가요?', style: questionStyle),
                  // 질문 텍스트
                  Text('추가/변경하기',
                      style: TextStyle(color: Colors.blue, fontSize: 12.0)),
                  // 추가/변경하기 텍스트
                ],
              ),
              ...pastWidgets, // SymtomBox 위젯들을 추가합니다.
              const SizedBox(height: 40), // 간격을 추가합니다.
              Text('통증이 언제부터 시작된 것 같나요?', style: questionStyle), // 질문 텍스트
              MyDateTimePicker(
                  onDateChanged: onDateChanged,
                  onTimeChanged: onTimeChanged,
                  startDate: startDate,
                  startTime: startTime),
              const SizedBox(height: 32), // 간격을 추가합니다.
              Text('통증이 지속적인 경우 종료 시간을 기록하세요', style: questionStyle), // 질문 텍스트
              MyDateTimePicker(
                  onDateChanged: onDateChanged,
                  onTimeChanged: onTimeChanged,
                  startDate: endDate,
                  startTime: endTime),
              const SizedBox(height: 32), // 간격을 추가합니다.
              Text('통증이 얼마나 아픈지 위치를 이동해 주세요', style: questionStyle), // 질문 텍스트
              Slider(
                value: sliderValue.toDouble(),
                onChanged: onSliderChanged,
                min: 0,
                max: 10,
                divisions: 10,
                thumbColor: Colors.blue,
                activeColor: Colors.blue,
              ),
              const SizedBox(height: 32), // 간격을 추가합니다.
              Text('지금 기분이 어떤가요?', style: questionStyle), // 질문 텍스트
              Text('선택된 표정은 파란색으로 표시됩니다', style: TextStyle(color: Colors.grey[400], fontSize: 12)), // 안내 텍스트
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    feelIcon(
                      icon: Icons.sentiment_very_dissatisfied_outlined,
                      color: Colors.red,
                      text: '나쁨',
                      context: context,
                      isSelected: painMoodVal == 0,
                      onTap: () => _handleFeelIconTap(0),
                    ),
                    feelIcon(
                      icon: Icons.sentiment_neutral,
                      color: Colors.yellow[700]!,
                      text: '우울함',
                      context: context,
                      isSelected: painMoodVal == 1,
                      onTap: () => _handleFeelIconTap(1),
                    ),
                    feelIcon(
                      icon: Icons.insert_emoticon,
                      color: Colors.green,
                      text: '좋음',
                      context: context,
                      isSelected: painMoodVal == 2,
                      onTap: () => _handleFeelIconTap(2),
                    ),
                  ],
                ),
              ),
              Text('기록하고 싶은 내용이 있나요?', style: questionStyle), // 질문 텍스트
              TextField(
                onChanged: (value) {
                  userNote = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '기록하고 싶은 내용을 입력해주세요',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget feelIcon({
  required IconData? icon,
  required Color color,
  required String text,
  required BuildContext context,
  required bool isSelected, // 선택 여부를 받아올 변수 추가
  required Function() onTap, // 탭 핸들러 추가
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : color,
            size: MediaQuery.of(context).size.width * 0.12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _saveButton({
  required BuildContext context,
  required int groupId,
  required Map<int, Map<String, dynamic>> rs,
  required String startTime,
  required String endTime,
  required double sliderValue,
  required int painMoodVal,
  required String note,
}) {
  void sendAdditionalRecord() async {
    await addAdditionalRecord(
      groupId: groupId,
      rawSymtoms: rs,
      painStartTime: startTime,
      painEndTime: endTime,
      painIntensity: sliderValue.toInt(),
      painMood: painMoodVal,
      note: note,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  return GestureDetector(
    onTap: sendAdditionalRecord,
    child: SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.08,
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            '저장하기',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ); // 저장하기 텍스트
}
