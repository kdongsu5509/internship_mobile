import 'package:flutter/material.dart';

class PainSelectBox extends StatefulWidget {
  final double fontSize;
  final String selectedValue; // Updated to non-nullable String
  final ValueChanged<String?> onChanged;

  const PainSelectBox({
    Key? key,
    required this.fontSize,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PainSelectBoxState createState() => _PainSelectBoxState();
}

class _PainSelectBoxState extends State<PainSelectBox> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue; // Initialize _selectedValue with widget.selectedValue
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      focusColor: Colors.black,
      alignment: Alignment.center,
      value: _selectedValue,
      hint: Text(
        '통증 부위 선택하기',
        style: TextStyle(fontSize: widget.fontSize),
      ),
      items: <String>['손 / 손가락', '목 / 어깨', '등 / 허리', '다리 / 발']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: value == _selectedValue
                  ? FontWeight.w600
                  : FontWeight.normal,
              color:
              value == _selectedValue ? Color(0xFF007EFF) : Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue!;
          widget.onChanged(newValue);
        });
      },
    );
  }
}
