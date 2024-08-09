import 'package:flutter/material.dart';
import '../../boxes/myCheckBox.dart';
import '../../common/next_save_button.dart';
import '../../request_fuction/record_request.dart';
import '../tapbar_screen.dart';
import 'new_pain_register_step_two_main.dart';

class NewPainRegisterStepTwo extends StatefulWidget {
  final bool isFirstStep;
  final bool isSecondStep;
  final void Function(bool?, String) onCheckboxChanged;
  final Map<String, bool> symptoms;
  final void Function(String) handleSymptomTap;
  final String painArea;

  NewPainRegisterStepTwo({
    required this.isFirstStep,
    required this.isSecondStep,
    required this.onCheckboxChanged,
    required this.symptoms,
    required this.handleSymptomTap,
    required this.painArea,
    Key? key,
  }) : super(key: key);

  @override
  State<NewPainRegisterStepTwo> createState() => _NewPainRegisterStepTwoState();
}

class _NewPainRegisterStepTwoState extends State<NewPainRegisterStepTwo> {
  int? painAreaDetail = 1;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? painStartPattern;
  double painIntensity = 0;
  int? painDuration;
  String? painNote;
  TextEditingController noteController = TextEditingController();

  void _onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      selectedTime = time;
    });
  }

  void _togglePainStart(int index) {
    setState(() {
      painStartPattern = index;
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      painIntensity = value;
    });
  }

  void _togglePainPersist(int index) {
    setState(() {
      painDuration = index;
    });
  }

  List<int> _getSelectedIndexes() {
    List<int> indexes = [];
    int index = 0;

    for (var entry in widget.symptoms.entries) {
      if (entry.value) {
        indexes.add(index);
      }
      index++;
    }

    return indexes;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Column(
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
            child: NewPainRegisterStepTwoMain(
              part: widget.painArea,
              selectedDate: selectedDate,
              selectedTime: selectedTime,
              onDateChanged_f: _onDateChanged,
              onTimeChanged_f: _onTimeChanged,
              slideValue: painIntensity,
              onSliderChanged: _onSliderChanged,
              painStartSelected: painStartPattern,
              onPainStartSelectedChanged: _togglePainStart,
              painPersistSelected: painDuration,
              onPainPersistSelectedChanged: _togglePainPersist,
              imageCheckedState: painAreaDetail,
              noteController: noteController,
              onImageCheckboxChanged: (index) {
                setState(() {
                  painAreaDetail = index;
                });
              },
            ),
          ),
          NextSaveButton(
            text: '저장',
            onTap: () async {
              await saveData(
                painArea: widget.painArea,
                getSelectedIndexes: _getSelectedIndexes(),
                painAreaDetail: painAreaDetail!,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                painIntensity: painIntensity,
                painStartPattern: painStartPattern!,
                painDuration: painDuration!,
                noteController: noteController,
                context: context,
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(), // 여기에 첫 페이지 위젯을 전달합니다
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
