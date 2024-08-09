import 'package:flutter/material.dart';
import '../../boxes/pain_select_box.dart';

class PainHistoryPainareaSelect extends StatefulWidget {
  final String painArea;
  final ValueChanged<String> onChanged;

  PainHistoryPainareaSelect({
    required this.painArea,
    required this.onChanged,
  });

  @override
  State<PainHistoryPainareaSelect> createState() => _PainHistoryTopState();
}

class _PainHistoryTopState extends State<PainHistoryPainareaSelect> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '통증 부위 : ',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 10),
              PainSelectBox(
                fontSize: 22.0,
                selectedValue: widget.painArea,
                onChanged: (String? value) {
                  if (value != null) {
                    widget.onChanged(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}