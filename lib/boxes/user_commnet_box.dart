import 'package:flutter/material.dart';

class UserCommentBox extends StatelessWidget {
  final TextEditingController noteController;
  final String? hintText; // 매개변수 이름을 좀 더 명확하게 수정했습니다.

  // 생성자에서 key 매개변수의 위치와 사용법 수정
  const UserCommentBox({
    required this.noteController,
    this.hintText, // nullable hintText를 기본값을 null로 설정
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: noteController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintText: hintText, // hintText 사용
        hintStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          height: 1.2, // 줄 간격 조정
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontSize: 14,
      ),
      maxLines: null, // 필드 내용에 따라 자동으로 줄 바꿈
      minLines: 2, // 최소한 두 줄을 표시하도록 설정
    );
  }
}
