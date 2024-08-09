import 'package:flutter/material.dart';
import 'package:p2record/UserData/last_group.dart';
import 'package:p2record/screen/pain_history/pain_detail_history_screen.dart';
import 'package:p2record/screen/pain_history/pain_history_calendar.dart';
import 'package:p2record/screen/pain_history/pain_history_painarea_select.dart';
import '../../common/my_divider.dart';
import '../RecordRegister/add_pain_frame.dart';

class PainHistory extends StatefulWidget {
  @override
  _PainHistoryState createState() => _PainHistoryState();
}

class _PainHistoryState extends State<PainHistory> {
  String painArea = '손 / 손가락'; // Default pain area
  List<Map<String, dynamic>> recordList = [];

  // recordList 업데이트 메서드
  void setRecordList(List<Map<String, dynamic>> newRecordList) {
    setState(() {
      recordList.clear(); // 기존 리스트 초기화
      recordList.addAll(newRecordList); // 새로운 리스트 추가
    });
  }

  // PainHistoryCalendar에서 호출되는 데이터 업데이트 메서드
  void painHistoryUpdate(List<Map<String, dynamic>> newRecordList) {
    setRecordList(newRecordList); // 데이터 업데이트
    // 데이터 업데이트를 디버그하고 확인하기 위해 print 문을 사용합니다.
    print('${recordList.length}개의 레코드가 발견되었습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PainHistoryPainareaSelect(
          painArea: painArea,
          onChanged: (String value) {
            setState(() {
              painArea = value;
            });
          },
        ),
        MyDivider(indent: 0, endIndent: 0),
        PainHistoryCalendar(
          painArea: painArea,
          updateParent: painHistoryUpdate, // 함수 자체를 전달해야 하므로 괄호 ()를 제거합니다.
        ),
        MyDivider(indent: 0, endIndent: 0),
        Expanded(
            flex: 55,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: recordList.length,
                  itemBuilder: (context, index) {
                    print('ListViewBuilder is running');
                    print('${recordList[index]}');
                    return summarizeBox(
                      record: recordList[index],
                      context: context,
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddPainFrame(
                                painArea: lastgroupPainArea,
                                groupId: lastgroup,
                              )));
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue,
                      size: 60,
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

Widget summarizeBox({
  required Map<String, dynamic> record,
  required BuildContext context,
}) {
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
                record['createdAt'].toString().substring(0, 10),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              // Display createdAt date
              Text(
                record['createdAt'].toString().substring(11),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: (){
                    showDialog(context: context, builder: (builder) => PainDetailHistoryScreen(id: record['id']));
                },
                child: Text(
                  '상세',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              // Placeholder for detail (not implemented)
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
                  record['painMood'] == '0'
                      ? Icons.sentiment_very_dissatisfied
                      : record['painMood'] == '1'
                          ? Icons.sentiment_neutral
                          : Icons.sentiment_very_satisfied,
                  color: record['painMood'] == '0'
                      ? Colors.red
                      : record['painMood'] == '1'
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
                  record['painIntensity'].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Display pain intensity
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
                    record['note'],
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                  // Placeholder for memo text
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
