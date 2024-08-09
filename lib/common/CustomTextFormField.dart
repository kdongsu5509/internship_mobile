import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;


  const CustomTextFormField({
    required this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //UnderlineInputBorder -> 밑줄로 구분되는 테두리
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
          width: 3,
          color: Colors.black,
      ),
    );

    return TextFormField(
      controller: controller,
      //비밀번호 입력할 때 * 로 표시되도록.
      obscureText: obscureText,
      autofocus: autofocus, // 자동으로 포커스를 줌
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        errorText: errorText,
        border: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: Colors.indigoAccent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black), // 오류 상태 보더 색상
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigoAccent, width: 3), // 포커스 시 오류 상태 보더 색상
        ),
        hoverColor: Colors.indigo,
      ),
    );
  }
}
