import 'package:flutter/material.dart';
import 'package:p2record/boxes/user_commnet_box.dart';

import '../../boxes/myCheckBox.dart';
import '../../common/questionTextStyle.dart';
import '../../picker/myDateTimePicker.dart';


class NewPainRegisterStepTwoMain extends StatefulWidget {
  final String part;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final void Function(DateTime) onDateChanged_f;
  final void Function(TimeOfDay) onTimeChanged_f;
  final ValueChanged<double>? onSliderChanged;
  final double slideValue;
  final int? painStartSelected;
  final int? painPersistSelected;
  final int? imageCheckedState; // 변경된 부분
  final void Function(int) onPainStartSelectedChanged;
  final void Function(int) onPainPersistSelectedChanged;
  final void Function(int) onImageCheckboxChanged; // 변경된 부분
  final TextEditingController noteController;

  NewPainRegisterStepTwoMain({
    required this.part,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged_f,
    required this.onTimeChanged_f,
    required this.slideValue,
    required this.onSliderChanged,
    required this.painStartSelected,
    required this.painPersistSelected,
    required this.imageCheckedState, // 변경된 부분
    required this.onPainStartSelectedChanged,
    required this.onPainPersistSelectedChanged,
    required this.onImageCheckboxChanged, // 변경된 부분
    required this.noteController,
    Key? key,
  }) : super(key: key);

  @override
  State<NewPainRegisterStepTwoMain> createState() =>
      _NewPainRegisterStepTwoMainState();
}

class _NewPainRegisterStepTwoMainState
    extends State<NewPainRegisterStepTwoMain> {
  late List<String> imagePaths;

  @override
  void initState() {
    super.initState();

    String? mypart;

    switch (widget.part) {
      case '손/손가락':
        mypart = 'hand';
        break;
      case '목/어깨':
        mypart = 'neck';
        break;
      case '등/허리':
        mypart = 'back';
        break;
      case '다리/발':
        mypart = 'foot';
        break;
      default:
        mypart = 'default';
        break;
    }

    imagePaths = (mypart == 'neck')
        ? [
            'asset/img/${mypart}/${mypart}_1.png',
            'asset/img/${mypart}/${mypart}_2.png',
            'asset/img/${mypart}/${mypart}_3.png',
            // 필요에 따라 추가 이미지 경로를 나열합니다.
          ]
        : [
            'asset/img/${mypart}/${mypart}_1.png',
            'asset/img/${mypart}/${mypart}_2.png',
            'asset/img/${mypart}/${mypart}_3.png',
            'asset/img/${mypart}/${mypart}_4.png',
            // 필요에 따라 추가 이미지 경로를 나열합니다.
          ];
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          '가장 아픈 위치를 선택하세요',
          style: questionStyle,
        ),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Stack(
                  children: [
                    Image.asset(
                      imagePaths[index],
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          widget.imageCheckedState == index
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: widget.imageCheckedState == index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        onPressed: () => widget.onImageCheckboxChanged(index),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30),
        Text(
          '통증이 언제부터 시작된 것 같나요?',
          style: questionStyle,
        ),
        MyDateTimePicker(
          onDateChanged: widget.onDateChanged_f,
          onTimeChanged: widget.onTimeChanged_f,
          startDate: widget.selectedDate,
          startTime: widget.selectedTime,
        ),
        SizedBox(height: 30),
        Text(
          '통증이 어떻게 시작되었나요?',
          style: questionStyle,
        ),
        _painStart(),
        SizedBox(height: 30),
        Text(
          '얼마나 아픈지 위치를 이동해 주세요',
          style: questionStyle,
        ),
        Slider(
          value: widget.slideValue,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: widget.onSliderChanged,
          activeColor: Colors.blue,
          thumbColor: Colors.blue,
        ),
        SizedBox(height: 30),
        Text(
          '통증이 얼마나 지속되나요?',
          style: questionStyle,
        ),
        _painPersist(),
        SizedBox(height: 30),
        Text(
          '더 자세한 정보가 있으면 입력하세요',
          style: questionStyle,
        ),
        SizedBox(height: 10),
        UserCommentBox(
          noteController: widget.noteController,
          hintText: '통증에 대한 추가 정보를 입력하세요',
        ),
      ],
    );
  }

  Widget _painStart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MyCheckBox(
          text: '급격히',
          value: widget.painStartSelected == 0,
          onChanged: (value) => widget.onPainStartSelectedChanged(0),
          ratio: 0.4,
          isCenter: false,
        ),
        MyCheckBox(
          text: '서서히',
          value: widget.painStartSelected == 1,
          onChanged: (value) => widget.onPainStartSelectedChanged(1),
          ratio: 0.4,
          isCenter: false,
        ),
      ],
    );
  }

  Widget _painPersist() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MyCheckBox(
            text: '일시적',
            value: widget.painPersistSelected == 0,
            onChanged: (value) => widget.onPainPersistSelectedChanged(0),
            ratio: 0.3,
            isCenter: false,
          ),
          MyCheckBox(
            text: '3분 이내',
            value: widget.painPersistSelected == 1,
            onChanged: (value) => widget.onPainPersistSelectedChanged(1),
            ratio: 0.3,
            isCenter: false,
          ),
          MyCheckBox(
            text: '5분 이상',
            value: widget.painPersistSelected == 2,
            onChanged: (value) => widget.onPainPersistSelectedChanged(2),
            ratio: 0.3,
            isCenter: false,
          ),
          MyCheckBox(
            text: '항상',
            value: widget.painPersistSelected == 3,
            onChanged: (value) => widget.onPainPersistSelectedChanged(3),
            ratio: 0.3,
            isCenter: false,
          ),
        ],
      ),
    );
  }
}
