import 'package:flutter/material.dart';

class DateSelectorBox extends StatefulWidget {
  @override
  _DateSelectorBoxState createState() => _DateSelectorBoxState();
}

class _DateSelectorBoxState extends State<DateSelectorBox> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pain Selector'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Material(
            child: DropdownButton<String>(
              focusColor: Colors.black,
              alignment: Alignment.topLeft,
              value: _selectedValue,
              hint: Text('통증 부위 선택하기', style: TextStyle(fontSize: 22)),
              items: <String>['손 / 손가락', '목 / 어깨', '등 / 허리', '다리 / 발']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: value == _selectedValue
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: value == _selectedValue ? Color(0xFF007EFF) : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DateSelectorBox(),
  ));
}
