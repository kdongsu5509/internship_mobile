import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2record/UserData/user_list.dart';
import '../UserData/MYTOKEN.dart';
import '../UserData/User.dart';
import '../UserData/selected_user.dart';

/** 로그인 관련 함수
 *로그인 관련 함수들은 모두 이곳에 정의되어 있습니다.*/

final dio = Dio();

/**
 * 1. 회원가입
 *
 * 설명 : 회원가입을 하는 함수입니다.
 *
 * parameter
 * - emailController : TextEditingController : 이메일 입력을 받는 컨트롤러
 * - passwordController : TextEditingController : 비밀번호 입력을 받는 컨트롤러
 * - nameController : TextEditingController : 이름 입력을 받는 컨트롤러
 * - genderController : TextEditingController : 성별 입력을 받는 컨트롤러
 * - birthController : TextEditingController : 생년월 입력을 받는 컨트롤러
 * - errorTextOfEmail : String : 이메일 에러 텍스트
 * - errorTextOfPassword : String : 비밀번호 에러 텍스트
 * - errorTextOfName : String : 이름 에러 텍스트
 * - errorTextOfGender : String : 성별 에러 텍스트
 * - errorTextOfBirth : String : 생년월 에러 텍스트
 * - context : BuildContext : 현재 화면의 context
 * */
Future<void> register({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController nameController,
  required TextEditingController genderController,
  required TextEditingController birthController,
  String? errorTextOfEmail,
  String? errorTextOfPassword,
  String? errorTextOfName,
  String? errorTextOfGender,
  String? errorTextOfBirth,
  required BuildContext context,
}) async {
  final String email = emailController.text;
  final String password = passwordController.text;
  final String name = nameController.text;
  final String gender = genderController.text;
  final String birth = birthController.text;

  late final response;
  if (errorTextOfEmail == null &&
      errorTextOfPassword == null &&
      errorTextOfName == null &&
      errorTextOfGender == null &&
      errorTextOfBirth == null) {
    try {
      response = await Dio().post(
        'http://10.10.7.26:8080/api/user/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'gender': gender,
          'birthDate': birth,
        },
      );

      if (response.statusCode == 200) {
        _alert(log: 'Register successful', user: '회원 가입 성공');
        Navigator.pop(context);
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        _alert(
            log: 'Register fail : Client Error',
            user: '회원 가입 실패. 입력 정보를 확인해주세요.');
      } else if (response.statusCode! >= 500) {
        _alert(
            log: 'Register fail : Server Error', user: '회원 가입 실패. 잠시 후 시도하세요.');
      }
    } catch (e) {
      print(
          '------------------alert at register : Error: $e----------------------');
      _alert(
          log: 'Register fail : Server Error', user: '회원 가입 실패. 잠시 후 시도하세요.');
    }
  } else {
    print(
        '------------------alert at register : Plz Check Error----------------------');
    Fluttertoast.showToast(msg: '입력한 정보를 확인해주세요.');
  }
}

/**
 * 2. 로그인
 *
 * 설명 : 로그인을 하는 함수입니다.
 *
 * parameter
 * - emailController : TextEditingController : 이메일 입력을 받는 컨트롤러
 * - passwordController : TextEditingController : 비밀번호 입력을 받는 컨트롤러
 * - context : BuildContext : 현재 화면의 context
 * - onLogin : VoidCallback : 로그인 성공 시 실행할 콜백 함수
 * */
Future<void> login({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required BuildContext context,
  required VoidCallback onLogin,
}) async {
  final String email = emailController.text
      .trim(); // Trim to remove any leading/trailing whitespace
  final String password = passwordController.text.trim();

  try {
    final response = await dio.post(
      'http://10.10.7.26:8080/api/user/login',
      data: {'email': email, 'password': password},
    );

    _alert(log: 'Login successful', user: '로그인 성공');
    // Login successful
    MYTOKEN = response.data; // Assuming response.data contains a token field
    onLogin(); // Call the success callback
  } catch (e) {
    _alert(log: 'Login fail : Server Error', user: '로그인 실패. 잠시 후 시도하세요.');
    print(
        '------------------alert at login : Error: $e--------------------------');
  }
}

/**
 * 3. 사용자 생성
 *
 * 설명 : 사용자를 생성하는 함수입니다.
 *
 * parameter
 * - name : String : 사용자 이름
 * - gender : String : 사용자 성별
 * - birthDate : String : 사용자 생년월
 *
 * */
Future<void> createUser({
  required String name,
  required String gender,
  required String birthDate,
}) async {
  Map<String, String> data = {
    'name': name,
    'gender': gender,
    'birthDate': birthDate,
  };

  try {
    final response = await dio.post(
      'http://10.10.7.26:8080/api/user/createUser',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${MYTOKEN}',
        },
      ),
      data: data,
    );

    print('response: ${response.data}');
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      _alert(log: 'Create user successful', user: '사용자 생성 성공');
      // Login successful
      MYTOKEN = response.data; // Assuming response.data contains a token field
    } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
      _alert(
          log: 'Create user fail : Client Error',
          user: '사용자 생성 실패. 입력 정보를 확인해주세요.');
    } else if (response.statusCode! >= 500) {
      _alert(
          log: 'Create user fail : Server Error',
          user: '사용자 생성 실패 실패. 잠시 후 시도하세요.');
    }
  } catch (e) {
    _alert(
        log: 'Create user fail : Server Error',
        user: '사용자 생성 실패 실패. 잠시 후 시도하세요.');
    print(
        '------------------alert at user_request : Error: $e--------------------------');
  }
}

Future<void> changeUser({
  required int newVal,
}) async {
  Map<String, dynamic> data = {
    'groupId': selectedUser.groupId,
    'userId': selectedUser.id,
  };

  print('groupId : ${selectedUser.groupId}');
  print('userId : $newVal');
  print('past userID : ${selectedUser.id}');
  print('PAST TOKEN : $MYTOKEN');
  try {
    final response = await dio.post(
      'http://10.10.7.26:8080/api/user/changeUser',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${MYTOKEN}',
        },
      ),
      data: data,
    );

    print('newTOKEN : ${response.data}');

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      selectedUser = userList[newVal]!;
      _alert(log: 'Change user successful', user: '사용자 변경 성공');
      // Login successful
      // MYTOKEN = response.data; // Assuming response.data contains a token field
      setMYTOKEN(response.data);
      print('NEW TOKEN : $MYTOKEN');
    } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
      _alert(log: 'Change user fail : Client Error', user: '사용자 변경 실패.');
    } else if (response.statusCode! >= 500) {
      _alert(
          log: 'Change user fail : Server Error',
          user: '사용자 변경 실패. 관리자에게 문의하세요.');
    }
  } catch (e) {
    _alert(
        log: 'Change user fail : Server Error',
        user: '사용자 변경 실패. 관리자에게 문의하세요.');
    print(
        '------------------alert at user_request : Error: $e--------------------------');
  }
}

/**
 * 5. 사용자 목록 가져오기
 *
 * 설명 : 사용자 목록을 가져오는 함수입니다.
 *
 * parameter
 * - userList : 사용자 목록을 저장할 Map
 * */
Future<bool> getUserList({
  required Map<int, User> userList,
}) async {
  dio.options.connectTimeout = Duration(seconds: 5); // Set timeout to 5 seconds

  try {
    final response = await dio.get(
      'http://10.10.7.26:8080/api/user/userList',
      options: Options(
        headers: {
          'Authorization': 'Bearer $MYTOKEN',
        },
      ),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      List<dynamic> data = response.data;
      print('data\n\n\n');
      print(data);
      int temp = 0;

      for (var element in data) {
        if (element is Map<String, dynamic>) {
          // Create a User object from the map
          User user = User(
            id: element['id'] as int,
            name: element['name'] as String? ?? "",
            gender: element['gender'] as String? ?? "",
            birthDate: element['birthDate'] as String? ?? "",
            groupId: element['groupId'] as int? ?? 0,
            image: element['image'] as String? ?? "", // Handle null image or provide default value
          );

          // Add User object to userList
          userList[user.id] = user;

          // Set selectedUser to the newly created User object
          if (temp == 0) {
            selectedUser = user; // Assign User object, not Map
            temp += 1000;
          }
        } else {
          print('Unexpected element type: ${element.runtimeType}');
        }
      }
      _alert(log: 'Get user list successful', user: '사용자 목록 가져오기 성공');
      return true;
    } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
      _alert(log: 'Get user list fail : Client Error', user: '사용자 목록 가져오기 실패.');
      return false;
    } else if (response.statusCode! >= 500) {
      _alert(
          log: 'Get user list fail : Server Error',
          user: '사용자 목록 가져오기 실패. 관리자에게 문의하세요.');
      return false;
    } else {
      return false;
    }
  } catch (e) {
    _alert(
        log: 'Get user list fail : Server Error',
        user: '사용자 목록 가져오기 실패. 관리자에게 문의하세요.');
    print(
        '------------------alert at user_request : Error: $e--------------------------');
    return false;
  }
}

/**
 * 메세지 출력 함수
 *
 * 설명
 *  - 상태를 터미널에 출력하고, 사용자에게 메세지를 출력합니다.
 *
 * parameter
 * - log : String : 터미널에 출력할 메세지
 * - user : String : 사용자에게 출력할 메세지
 * */
void _alert({required String log, required String user}) {
  print('\n-\n-\n');
  print('alert at user_request.dart : ${log}');
  print('\n-\n-\n');
  Fluttertoast.showToast(
    msg: user,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}
