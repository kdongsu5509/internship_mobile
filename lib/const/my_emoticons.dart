import 'package:flutter/material.dart';

class MyEmoticons extends StatelessWidget {
  final condition;

  const MyEmoticons({
    required this.condition,
    super.key});

  @override
  Widget build(BuildContext context) {
    List<Icon> emoticons = [
      Icon(
        Icons.insert_emoticon, // very_happy(8-10)
      ),
      Icon(
        Icons.sentiment_neutral, // normal(5-7)
        size: 30,
      ),
      Icon(
        Icons.sentiment_dissatisfied_rounded, // not bad(3-4)
        size: 30,
      ),
      Icon(
        Icons.sentiment_very_dissatisfied_outlined, // bad(1-2)
        size: 30,
      ),
    ];

    if(condition >= 8)
      return emoticons[0];
    else if(condition >= 5)
      return emoticons[1];
    else if(condition >= 3)
      return emoticons[2];
    else if(condition >= 0)
      return emoticons[3];
    else
      return Icon(Icons.adb_outlined);
  }
}
