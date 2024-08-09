import 'package:flutter/material.dart';
import '../common/my_divider.dart';
import '../screen/RecordRegister/new_rocord_add.dart';

class NewRecordBox extends StatelessWidget {
  final BuildContext context;
  final String topLeftText;
  final String topRightText;
  final String bottomLeftText;
  final String bottomMiddleText;
  final String bottomRightText;
  final VoidCallback addfunc;
  final Map<String, dynamic> rawData;

  NewRecordBox({
    required this.context,
    required this.topLeftText,
    required this.topRightText,
    required this.bottomLeftText,
    required this.bottomMiddleText,
    required this.bottomRightText,
    required this.addfunc,
    required this.rawData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _middleTopPadding(
              leftText: topLeftText,
              rightText: topRightText,
            ),
            MyDivider(indent: 20, endIndent: 20),
            _middleBottomPadding(
              leftText: bottomLeftText,
              middleText: bottomMiddleText,
              rightText: bottomRightText,
            )
          ],
        ),
      ),
    );
  }

  Padding _middleTopPadding({
    required String leftText,
    required String rightText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${leftText}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => newRecordAdd(addfunc)),
              );
            },
            child: Text(
              '${rightText}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF007EFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _middleBottomPadding({
    required String leftText,
    required String middleText,
    required String rightText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '${leftText}',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  '${middleText}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${rightText}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
