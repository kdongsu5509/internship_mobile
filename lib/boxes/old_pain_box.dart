import 'package:flutter/material.dart';
import '../UserData/last_group.dart';
import '../common/my_divider.dart';
import '../screen/RecordRegister/add_pain_frame.dart';
import '../screen/RecordRegister/new_rocord_add.dart';

class OldPainBox extends StatelessWidget {
  final String topLeftText;
  final String topRightText;
  final String bottomLeftFirstText;
  final String bottomLeftSecondText;
  final String bottomRightFirstText;
  final String bottomRightSecondText;
  BuildContext context;
  int groupId;

  OldPainBox({
    required this.topLeftText,
    required this.topRightText,
    required this.bottomLeftFirstText,
    required this.bottomLeftSecondText,
    required this.bottomRightFirstText,
    required this.bottomRightSecondText,
    required this.context,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.grey[300]!,
        ),
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
              groupId: groupId,
              addfunc: (int id) {
                print('groupId: $id');
              },
            ),
            MyDivider(
              indent: 20,
              endIndent: 20,
              color: Colors.black12,
            ),
            _middleBottomPadding(
              LeftFirstText: bottomLeftFirstText,
              LeftSecondText: bottomLeftSecondText,
              RightFirstText: bottomRightFirstText,
              RightSecondText: bottomRightSecondText,
              id: groupId,
            )
          ],
        ),
      ),
    );
  }

  Padding _middleTopPadding({
    required String leftText,
    required String rightText,
    required int groupId,
    required Function(int) addfunc,
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddPainFrame(
                    painArea: lastgroupPainArea,
                    groupId: lastgroup,
                  )));
            }, // 통증 기록 추가 버튼 클릭 시 실행되는 함수입니다.
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
    required LeftFirstText,
    required LeftSecondText,
    required RightFirstText,
    required RightSecondText,
    required int id,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  '${LeftFirstText}',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  '${LeftSecondText}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${RightFirstText}',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Row(
                    children: [
                      Text(
                        '${RightSecondText}',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
