import 'package:flutter/material.dart';
import 'package:p2record/UserData/last_group.dart';
import 'package:p2record/request_fuction/record_request.dart';
import 'package:p2record/screen/RecordRegister/new_rocord_add.dart';
import '../../UserData/selected_user.dart';
import '../../boxes/new_pain_box.dart';
import '../../boxes/old_pain_box.dart';

class PainRecord extends StatefulWidget {
  const PainRecord({required this.addfunc, Key? key}) : super(key: key);

  final VoidCallback addfunc;

  @override
  _PainRecordState createState() => _PainRecordState();
}

class _PainRecordState extends State<PainRecord> {
  Map<String, dynamic>? _data; // 전체 기록이네?
  Map<int, Map<String, dynamic>> latestRecords = {};
  bool _isLoading = true;
  bool _hasError = false;
  int totalPainCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMainPageInfo();
  }

  Future<void> _fetchMainPageInfo() async {
    try {
      // 여기서 반환 타입을 맞추어줍니다.
      Map<String, dynamic> data = await getMainPageInfo();
      _data = data;
      List<Map<String, dynamic>> records =
          List<Map<String, dynamic>>.from(data['data']['groups']);

      if (data['data']['daysSinceLastRecord'] == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      } else {
        // 2. `groupId`로 묶기
        Map<int, List<Map<String, dynamic>>> groupedRecords = {};
        for (var record in records) {
          int groupId = record['groupId'];
          if (!groupedRecords.containsKey(groupId)) {
            groupedRecords[groupId] = [];
          }
          groupedRecords[groupId]!.add(record);
        }

        // 3. `groupId`별로 최신값만 뽑기
        for (var groupId in groupedRecords.keys) {
          var recordsInGroup = groupedRecords[groupId]!;
          var latestRecord = recordsInGroup.reduce((a, b) {
            // `lastRecordDate`를 `DateTime`으로 변환하여 비교
            DateTime dateA = DateTime.parse(a['lastRecordDate']);
            DateTime dateB = DateTime.parse(b['lastRecordDate']);
            return dateA.isAfter(dateB) ? a : b;
          });
          latestRecords[groupId] = latestRecord;
        }
        setState(() {
          _data = data;
          _isLoading = false;
          totalPainCount = data['data']['totalCount'];
        });
      }
    } catch (e) {
      print(
          '========================at pain_record.dart========================');
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      return Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => newRecordAdd(widget.addfunc),
              ),
            );
          },
          child: Text('기록 시작하기', style: TextStyle(fontSize: 20,),),
        ),
      );
    } else if (_data!['data']['daysSinceLastRecord'] == null) {
      return _PainRecordTop(
          _data!['data']['username'], _data!['data']['daysSinceLastRecord']);
      // XX님의 마지막 통증 기록은 XX일 전입니다.
    } else {
      return Column(
        children: [
          _PainRecordTop(_data!['data']['username'],
              _data!['data']['daysSinceLastRecord']),
          // XX님의 마지막 통증 기록은 XX일 전입니다.
          _PainRecordMiddle(context: context, totalPainCount: totalPainCount),
          _PainRecordBottom(),
        ],
      );
    }
  }

  Widget _PainRecordTop(String username, int daysSinceLastRecord) {
    TextStyle ts = TextStyle(
      fontSize: 25,
    );

    if (selectedUser == null)
      print(
          '-------------------------------------------at pain_record.dart alert. user is null.-----------------------------------------------------------------');
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _PainRecordTopTexts(
              ts: ts,
              username: username,
              daysSinceLastRecord: daysSinceLastRecord),
        ),
      ),
    );
  }

  List<Widget> _PainRecordTopTexts({
    required TextStyle ts,
    String username = "ERROR:NO_USER",
    required int daysSinceLastRecord,
  }) {
    return [
      Row(
        children: [
          Text(
            username,
            style: ts.copyWith(color: Color(0xFF007EFF)),
          ),
          Text(
            "님의",
            style: ts,
          ),
        ],
      ),
      Text(
        "마지막 통증 기록은",
        style: ts,
      ),
      Row(
        children: [
          Text(
            daysSinceLastRecord == 0
                ? '오늘 '
                : '${daysSinceLastRecord.toString()}일 전',
            style: ts.copyWith(fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          Text(
            "입니다.",
            style: ts,
          ),
        ],
      ),
    ];
  }

  Expanded _PainRecordMiddle({
    required BuildContext context,
    required int totalPainCount,
  }) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: NewRecordBox(
          context: context,
          topLeftText: "아픈 곳이 있나요?",
          topRightText: "새로운 통증",
          bottomLeftText: "전체 기록",
          bottomMiddleText: totalPainCount.toString(),
          bottomRightText: "이력 보기(API X)",
          addfunc: widget.addfunc,
          rawData: _data!,
        ),
      ),
    );
  }

  Expanded _PainRecordBottom() {
    // Sort entries by 'lastRecordDate' in descending order
    List<MapEntry<int, Map<String, dynamic>>> sortedEntries = latestRecords.entries.toList()
      ..sort((a, b) => DateTime.parse(b.value['lastRecordDate']).compareTo(DateTime.parse(a.value['lastRecordDate'])));

    setlastgroup(sortedEntries[0].key);
    setlastgroupPainArea(sortedEntries[0].value['painArea']);



    return Expanded(
      flex: 14,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: sortedEntries.map((entry) {
            int groupId = entry.key;
            Map<String, dynamic> record = entry.value;
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: OldPainBox(
                topLeftText: record['painArea'],
                topRightText: '통증 기록 추가',
                bottomLeftFirstText: '통증 기록',
                bottomLeftSecondText: record['count'].toString(),
                bottomRightFirstText: '마지막 기록일',
                bottomRightSecondText: record['lastRecordDate'].toString().substring(0, 10),
                context: context,
                groupId: groupId,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
