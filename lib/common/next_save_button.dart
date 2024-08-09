import 'dart:async';
import 'package:flutter/material.dart';

class NextSaveButton extends StatelessWidget {
  const NextSaveButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await onTap!(); // Future<void>를 처리
        } catch (e) {
          print('Error: $e'); // 예외 처리를 할 수 있음
        }
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.065,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0), // 선택적으로 둥근 모서리 추가
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 21,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
