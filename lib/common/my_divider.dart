import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  final double indent;
  final double endIndent;
  final Color color;

  const MyDivider({
    super.key,
    required this.indent,
    required this.endIndent,
    this.color = const Color(0xFFE8E8E8),
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
