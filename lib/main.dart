import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:p2record/request_fuction/user_request.dart';
import 'package:p2record/screen/Login/login_screen.dart';
import 'package:p2record/screen/tapbar_screen.dart';
import 'UserData/MYTOKEN.dart';
import 'UserData/user_list.dart';

void main() async {
  //달력 한글화.
  await initializeDateFormatting('ko_KR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isTokenReady = false;
  bool isUserListReady = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleLoginStatus() {
    setState(() {
      isTokenReady = !isTokenReady;
    });
  }

  @override
  Widget build(BuildContext context,) {

    void _loadData() async {
      try {
        bool userListSuccess = await getUserList(userList: userList);

        if (userListSuccess) {
          // getUserList() 함수가 성공한 경우에 대한 처리
          setState(() {
            isUserListReady = true;
          });
        } else {
          print('____________________________________');
          print('alert at main : Failed to load user list');
          print('____________________________________');
          throw Exception('Failed to load user list');
        }
      } catch (e){
        // 예외 처리
        print('alert at main : 데이터 불러오기 오류: 앱을 종료합니다.');
        print('alert at main : $e');
        //exit(0);
      }
    }


    if(!isTokenReady){
      return Login(onLogin: _toggleLoginStatus,);
    }
    else if (!isUserListReady) {
      // User list not loaded yet, show loading indicator
      _loadData();
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // User list loaded, determine which screen to show
      return HomeScreen();
    }
  }
}
