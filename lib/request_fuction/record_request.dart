import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../UserData/MYTOKEN.dart';

/**
 * record 관련 함수
 * record 관련 함수들은 모두 이곳에 정의되어 있습니다.
 */

final dio = Dio();


/**
 * 1. 특정 부위, 년-월에 해당하는 통증 기록 이력 조회
 *
 * - 설명
 * -> 특정 부위, 년-월에 해당하는 통증 기록 이력을 조회하는 함수
 *
 * - 파라미터
 * painArea : 통증 부위
 * yearMonth : yyyy-MM 형식의 년-월
 *
 * - 반환값
 *
 * */

Future<List<dynamic>> requestSpecificRecordList({
  required String painArea,
  required String yearMonth,
}) async {

  switch(painArea){
    case '손 / 손가락':
      painArea = '손/손가락';
      break;
    case '목 / 어깨':
      painArea = '목/어깨';
      break;
    case '등 / 허리':
      painArea = '등/허리';
      break;
    case '다리 / 발':
      painArea = '다리/발';
      break;
  }

  String encodedString = Uri.encodeComponent(painArea);

  try{
    Response resp = await dio.get(
      'http://10.10.7.26:8080/api/records?painArea=$encodedString&yearMonth=$yearMonth',
      options: Options(
        headers: {
          'Authorization': 'Bearer $MYTOKEN',
        },
      ),
    );
    
    print('--------------------------alert at record_request.dart--------------------------');
    _alert(log: '\n\n통증 기록 조회 성공\n\n', user: '${yearMonth.substring(5)}월 조회 완료');
    print('response: ${resp.data['data']}');
    return resp.data['data']; // List<Map<String, dynamic>> 형태


  }
  catch (e){
    print('http://10.10.7.26:8080/api/records?painArea=$encodedString&yearMonth=$yearMonth',);
    _alert(log: '\n통증 기록 조회 실패 ${e}\n', user: '통증 기록 조회 실패');
    print('Error: $e');
    return []; // 에러 발생 시 빈 리스트 반환
  }
}

/**
 * 2. 통증 기록 저장 함수
 */

Future<void> saveData({
  required String painArea,
  required List<int> getSelectedIndexes,
  required int painAreaDetail,
  required DateTime? selectedDate,
  required TimeOfDay? selectedTime,
  required double painIntensity,
  required int painStartPattern,
  required int painDuration,
  required TextEditingController noteController,
  required BuildContext context,
}) async {
  // 서버로 전송할 데이터
  Map<String, dynamic> mydata = {
    "painArea": painArea,
    "symptoms": getSelectedIndexes,
    "painAreaDetail": painAreaDetail ?? 0,
    "painStartDateTime": selectedDate != null && selectedTime != null
        ? "${selectedDate.toIso8601String().split('T').first} ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}"
        : null,
    "painIntensity": painIntensity.toInt(),
    "painStartPattern": painStartPattern,
    "painDuration": painDuration ?? 0,
    "painMood": 0,
    "note": noteController.text.isEmpty ? null : noteController.text,
  };
  try {
    final response = await dio.post(
      'http://10.10.7.26:8080/api/records',
      options: Options(
        headers: {
          'Authorization': 'Bearer $MYTOKEN',
        },
      ),
      data: mydata,
    );

    print(
        '--------------------------alert at record_request.dart--------------------------');
    print('newe record add request my data: \n $mydata');

    // 응답 상태 코드에 따른 처리
    if (response.statusCode == null) {
      Fluttertoast.showToast(msg: '알 수 없는 오류가 발생했습니다.');
    } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
      Fluttertoast.showToast(msg: '저장에 실패했습니다. 다시 시도해 주세요.');
      print('Failed');
      print('my data: $mydata');
      print('response: ${response.data}');
    } else if (response.statusCode! >= 500) {
      Fluttertoast.showToast(msg: '서버 오류가 발생했습니다. 나중에 다시 시도해 주세요.');
      print('Server Error');
      print('my data: $mydata');
      print('response: ${response.data}');
    } else {
      Fluttertoast.showToast(msg: '저장되었습니다.');
      print('Success');
      print('my data: $mydata');
      print('response: ${response.data}');
      Navigator.of(context).pop(); // 성공 시 화면을 닫음
    }
  } catch (e) {
    Fluttertoast.showToast(msg: '오류가 발생했습니다: $e');
    print('Error: $e');
  }
}

/**
 * 3. 통증 기록 + a 함수
 * - 설명
 * -> 통증 기록 + a를 저장하는 함수
 * - 파라미터
 * - 인증 토큰
 * - 그룹 아이디
 * */
Future<void> addAdditionalRecord({
  required int groupId,
  required Map<int, Map<String, dynamic>> rawSymtoms,
  required String painStartTime,
  required String painEndTime,
  required int painIntensity,
  required int painMood, required String note,
}) async {
  List<int> sendSymtoms = rawSymtoms.entries
      .where((entry) => entry.value['isSelected'] == true)
      .map((entry) => entry.key)
      .toList();

  Map<String, dynamic> mydata = {
    "symptoms": sendSymtoms,
    "painStartTime": painStartTime,
    "painEndTime": painEndTime,
    "painIntensity": painIntensity,
    "painMood": painMood,
    "note": note == "" ? "메모를 추가하지 않았습니다." : note,
  };
  print('addAdditionalRecord request data: $mydata');

  try {
    final response = await Dio().post(
      'http://10.10.7.26:8080/api/records/$groupId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $MYTOKEN',
        },
      ),
      data: mydata,
    );

    print('addAdditionalRecord request data: $mydata');
    _alert(log: 'addAdditionalRecord success', user: '통증 기록 추가 성공');
    print('addAdditionalRecord response: ${response.data}');

  } catch (e) {
    print('Error in addAdditionalRecord: ${e.toString()}');
  }
}

/**
 * 4. 통증 기록 수정 함수 -> new_pain_register_frame.dart에 위치.
 * - 설명
 * -> 통증 기록을 수정하는 함수
 * - 파라미터
 * - 인증 토큰
 * - 그룹 아이디
 * */


/**
 * 6. 재기록 시 과거 통증 기록 가져오기.
 * - 설명
 * -> 재기록 시 과거 통증 기록을 가져오는 함수
 *
 * - 파라미터
 *  - 인증 토큰
 *  - groupId : 그룹 아이디
 * */
Future<List<Map<String, dynamic>>> getPastSymptoms(int groupId) async {
  try {
    final response = await dio.get(
      'http://10.10.7.26:8080/api/records/$groupId/symptoms',
      options: Options(
        headers: {
          'Authorization': 'Bearer $MYTOKEN',
        },
      ),
    );

    // response.data를 출력할 때 toString() 사용
    print('response: ${response.data.toString()}');
    print(
        '--------------------------alert at get Past Symptoms of record_request.dart--------------------------');
    _alert(log: response.data.toString(), user: "과거 통증 기록 가져오기 성공");

    // 반환값은 data 필드가 List<Map<String, dynamic>>인 경우
    if (response.data is Map<String, dynamic> &&
        response.data.containsKey('data')) {
      var data = response.data['data'];
      if (data is List) {
        // List<Map<String, dynamic>>로 변환
        return List<Map<String, dynamic>>.from(data);
      }
    }

    // data가 List가 아닌 경우 빈 리스트 반환
    return [];
  } catch (e) {
    print(
        '--------------------------alert at get Past Symptoms of record_request.dart--------------------------');
    _alert(log: 'error: ${e.toString()}', user: '과거 통증 기록 가져오기 실패');
    return []; // 에러 발생 시 빈 리스트 반환
  }
}

/**
 * 8. 통증 기록 메인 페이지 조회
 *
 * - 설명
 * -> 메인 화면 진입 시 통증 기록 조회하는 함수
 */

Future<Map<String, dynamic>> getMainPageInfo() async {
  try {
    final response = await dio.get(
      'http://10.10.7.26:8080/api/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $MYTOKEN', // MYTOKEN 사용
        },
      ),
    );
    print(response.data);
    _alert(log: 'success to getMainPageInfo', user: '메인 페이지 조회 성공');
    return response.data as Map<String, dynamic>;
  } catch (e) {
    print('TOKEN : $MYTOKEN');
    _alert(log: 'fail to getMainPageInfo: ${e}', user: '메인 페이지 조회 실패');
    throw Exception('Failed to load data: $e');
  }
}

void _alert({required String log, required String user}) {
  print('\n-\n-\n');
  print('alert at record_request.dart : ${log}');
  print('\n-\n-\n');
  Fluttertoast.showToast(
    msg: user,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}
