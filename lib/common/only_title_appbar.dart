import 'package:flutter/material.dart';

/**
 * 설명
 *  - 통증 기록 페이지의 AppBar 위젯
 *  - 통증 기록 페이지의 AppBar를 구성하는 위젯
 *
 *  param
 *  - appbarTitle : AppBar 타이틀 -> 새로운 통증, 새로운 통증 기록하기 같은 거
 *
 * return : AppBar
 */

class OnlyTitleAppbar {
  // Static method to create an AppBar
  static AppBar createAppBar(String appbarTitle) {
    return AppBar(
      backgroundColor: Colors.grey[200],
      title: Text(
        appbarTitle,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
