import 'dart:ui';

import 'package:flutter/material.dart';
import '../../common/only_title_appbar.dart';
import '../pain_record/pain_record_page_title.dart';
import '../user_select_screen.dart';
import 'new_pain_register_frame.dart';

class newRecordAdd extends StatelessWidget {
  newRecordAdd(VoidCallback addfunc, {Key? key}) : addfunc = addfunc, super(key: key);

  final VoidCallback addfunc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnlyTitleAppbar.createAppBar("새로운 통증 등록"),
      body: _body(context, addfunc),
    );
  }
}

//----------------------------------------------------Body---------------------------------------
Widget _body(
  BuildContext context,
    VoidCallback addfunc,
) {
  return Container(
    child: Column(
      children: [
        PainRecordPageTitle(explainText: "님이 아픈 부위를 선택하세요",),
        _bodyContent(context, addfunc),
      ],
    ),
  );
}

Widget _bodyContent(
  BuildContext context,
    VoidCallback addfunc,
) {
  List<String> _painList = [
    '손/손가락',
    '목/어깨',
    '등/허리',
    '다리/발',
  ];
  return Expanded(
    flex: 9,
    child: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: _userSelect(context, addfunc),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _painList
                .map(
                  (e) => _painBox(e, context), // 통증 부위 선택 상자(아래에 위치)
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
}

//---통증 부위 선택 상자---
Widget _painBox(String painName, BuildContext context) {
  late Widget _painSurveyPage;
  switch(painName){
    case '손/손가락':
      _painSurveyPage = NewPainRegisterFrame(
        part: '손/손가락',
      );
      break;
    case '목/어깨':
      _painSurveyPage = NewPainRegisterFrame(
        part: '목/어깨',
      );
      break;
    case '등/허리':
      _painSurveyPage = NewPainRegisterFrame(
        part: '등/허리',
      );
      break;
    case '다리/발':
      _painSurveyPage = NewPainRegisterFrame(
        part: '다리/발',
      );
      break;
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _painSurveyPage,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: Colors.white60,
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            painName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 45,
              color: Color(0xFF007EFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );
}

//--- 사용자 선택---
Widget _userSelect(BuildContext context, VoidCallback addfunc) {
  return Row(
    children: [
      Text(
        '다른 사용자의 증상을 기록하고 싶으세요 ?',
        style: TextStyle(fontSize: 12),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserSelectScreen(addfunc: addfunc),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            '사용자 선택',
            style: TextStyle(
              fontSize: 15,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ],
  );
}
