import 'package:flutter/material.dart';

/**
 * 설명
 *  - 체크박스 위젯
 *  - 체크박스를 구성하는 위젯
 *
 *  param
 *  - value : 체크박스의 상태
 *  - onChanged : 체크박스 상태 변경 이벤트 핸들러
 *  - text : 체크박스 옆에 표시할 텍스트
 *
 * return : Container
 */

class MyCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final double ratio;
  final BoxDecoration boxDeco;
  final bool isCenter;
  final bool isDeco;

  const MyCheckBox({
    required this.onChanged,
    required this.text,
    this.value = false,
    this.ratio = 0.5,
    this.boxDeco = const BoxDecoration(
      color: Color(0xFFF5F5F5),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border(
        right: BorderSide(color: Colors.grey),
        left: BorderSide(color: Colors.grey),
        bottom: BorderSide(color: Colors.grey),
      ),
    ),
    this.isCenter = true,
    this.isDeco = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (widget.isDeco) ? widget.boxDeco : null,
      width: MediaQuery.of(context).size.width * widget.ratio,
      child: Row(
        mainAxisAlignment: widget.isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            checkColor: Colors.black,
            fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.blue;
                }
                return Colors.white;
              },
            ),
            value: widget.value,
            onChanged: (newValue) {
              widget.onChanged(newValue);
            },
          ),
          Text(widget.text),
        ],
      ),
    );
  }
}
