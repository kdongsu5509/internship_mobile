import 'package:flutter/material.dart';

/**
 * 설명
 * - 증상 선택 화면의 증상 선택 박스 위젯을 설정한 클래스
 * - 해당 파일은 symtom_select_list.dart 파일에서 사용되는 파일입니다.
 *
 *
 * param
 * - text : 증상 선택 박스에 표시할 텍스트
 * - onTap : 증상 선택 박스를 클릭했을 때 실행할 함수
 * - basic : 증상 선택 박스의 기본 디자인
 * - selected : 증상 선택 박스의 선택된 디자인
 * - textStyle : 증상 선택 박스의 텍스트 스타일
 * - isSelected : 증상 선택 박스의 선택 여부
 *
 *
 * return : State<SymtomBox>
 */



class SymtomBox extends StatefulWidget {
  const SymtomBox({
    required this.text,
    required this.onTap,
    required this.basic,
    required this.selected,
    required this.textStyle,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final BoxDecoration basic;
  final BoxDecoration selected;
  final TextStyle textStyle;
  final String text;
  final bool isSelected;

  @override
  _SymtomBoxState createState() => _SymtomBoxState();
}

class _SymtomBoxState extends State<SymtomBox> {
  late bool _isSelected;
  late BoxDecoration _boxDecoration = BoxDecoration(
    color: Colors.white60,
    border: Border.all(
      color: Colors.blue,
    ),
  );
  late TextStyle _textStyle = TextStyle(fontSize: 20, color: Colors.black);

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    _updateDecorationAndStyle();
  }

  void _updateDecorationAndStyle() {
    _boxDecoration = _isSelected ? widget.selected : widget.basic;
    _textStyle = _isSelected
        ? widget.textStyle.copyWith(color: Colors.white)
        : widget.textStyle.copyWith(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            _updateDecorationAndStyle();
          });
          widget.onTap?.call();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: _boxDecoration,
          child: Center(
            child: Text(
              '# ${widget.text}',
              style: _textStyle,
            ),
          ),
        ),
      ),
    );
  }

  bool get isSelected => _isSelected;
}
