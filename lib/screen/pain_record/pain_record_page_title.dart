import 'package:flutter/material.dart';
import 'package:p2record/UserData/selected_user.dart';

/**
 * 설명
 *  - 통증 기록 페이지의 타이틀 위젯 " 엄소민 님과 관련 있는 증상을 모두 선택하세요 "
 *  - 이름 뒤에 설명 텍스트를 추가하여 통증 기록 페이지의 타이틀을 구성하는 위젯
 *
 * param
 *  - explainText : 이름 뒤 설명 텍스트
 *  - explain_text_fontSize : 설명 텍스트 폰트 크기 -> default : 15.0
 *
 * return : Expanded widget
 */

class PainRecordPageTitle extends StatelessWidget {
  final String explainText;
  final double? explain_text_fontSize;

  const PainRecordPageTitle({
    required this.explainText,
    this.explain_text_fontSize = 15.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                selectedUser.name,
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFF007EFF),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                    explainText,
                  style: TextStyle(fontSize: explain_text_fontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
