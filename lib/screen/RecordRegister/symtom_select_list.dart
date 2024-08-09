import 'package:flutter/material.dart';
import 'package:p2record/boxes/symtom_box.dart';

/**
 * 설명
 *  - 증상 선택 화면
 *  - 증상 선택 화면을 구성하는 위젯
 *
 *  param
 *  - symptomStates : 증상 상태
 *  - handleSymptomTap : 증상 선택 이벤트 핸들러
 *
 * return : Expanded(ListView)
 */


class SymtomSelectList extends StatelessWidget {
  const SymtomSelectList({
    required this.symptomStates,
    required this.handleSymptomTap,
    Key? key,
  }) : super(key: key);

  final Map<String, bool> symptomStates;
  final Function(String) handleSymptomTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: symptomStates.keys.map((text) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SymtomBox(
              text: text,
              isSelected: symptomStates[text]!,
              onTap: () => handleSymptomTap(text),
              basic: BoxDecoration(
                color: Colors.white60,
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              selected: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              textStyle: TextStyle(
                fontSize: 20,
                color: symptomStates[text]! ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}