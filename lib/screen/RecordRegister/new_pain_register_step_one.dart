import 'package:flutter/material.dart';
import 'package:p2record/screen/RecordRegister/symtom_select_list.dart';
import '../../boxes/myCheckBox.dart';
import '../../common/next_save_button.dart';

/**
 * 통증 등록 1단계 페이지를 구성하는 위젯
 *
 * param
 * - isFirstStep : 1단계 선택 여부
 * - isSecondStep : 2단계 선택 여부
 * - onCheckboxChanged : 체크박스 변경 이벤트 핸들러
 * - symptomStates : 증상 상태
 * - handleSymptomTap : 증상 선택 이벤트 핸들러
 *
 * return : Scaffold
 */
class NewPainRegisterStepOne extends StatefulWidget {
  final bool isFirstStep;
  final bool isSecondStep;
  final void Function(bool?, String) onCheckboxChanged;
  final Map<String, bool> symptomStates;
  final void Function(String) handleSymptomTap;

  const NewPainRegisterStepOne({
    required this.isFirstStep,
    required this.isSecondStep,
    required this.onCheckboxChanged,
    required this.symptomStates,
    required this.handleSymptomTap,
    super.key,
  });

  @override
  State<NewPainRegisterStepOne> createState() => _NewPainRegisterStepOneState();
}

class _NewPainRegisterStepOneState extends State<NewPainRegisterStepOne> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MyCheckBox(
                text: '1단계',
                value: widget.isFirstStep,
                onChanged: (value) {
                  widget.onCheckboxChanged(value, '1');
                },
                isDeco: true,
              ),
              MyCheckBox(
                text: '2단계',
                value: widget.isSecondStep,
                onChanged: (value) {
                  widget.onCheckboxChanged(value, '2');
                },
                isDeco: true,
              ),
            ],
          ),
          Expanded(
            child: SymtomSelectList(
              symptomStates: widget.symptomStates,
              handleSymptomTap: widget.handleSymptomTap,
            ),
          ),
          NextSaveButton(
            text: '다음',
            onTap: () async {
              if (widget.isFirstStep) {
                widget.onCheckboxChanged(true, '2');
              }
            },
          ),
        ],
      ),
    );
  }
}
