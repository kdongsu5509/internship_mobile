import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2record/UserData/selected_user.dart';
import '../UserData/user_list.dart';
import '../request_fuction/user_request.dart';

class UserSelectScreen extends StatefulWidget {
  const UserSelectScreen({required this.addfunc, Key? key}) : super(key: key);

  final VoidCallback addfunc;

  @override
  _UserSelectScreenState createState() => _UserSelectScreenState();
}

class _UserSelectScreenState extends State<UserSelectScreen> {
  int selectedValue = selectedUser.id;
  int beforeSelectedValue = selectedUser.id;

  void userIdChange(int value) async {
    setState(() {
      if (selectedValue == value) {
        // 이미 선택된 값일 때 선택 해제
        selectedValue = selectedUser.id;
      } else {
        // 새로운 값을 선택
        selectedValue = value;
        print('\n\n\n\nselectedValue: ${selectedUser.name}');
        selectedUser = userList[value]!;
        print('selectedValue: ${selectedUser.name}\n\n\n\n\n');
        widget.addfunc();
      }
    });

    // 비동기 작업은 setState 외부에서 수행
    await changeUser(newVal: selectedValue);
    beforeSelectedValue = selectedValue;
  }

  String? _name;
  String? _gender;
  String? _birthDate;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Text('현재'),
                  expandedHeight: MediaQuery.of(context).size.height * 0.17,
                  flexibleSpace: FlexibleSpaceBar(
                    background: selectedUser.id != null &&
                        userList.containsKey(selectedUser.id)
                        ? userBox(
                      context: context,
                      userId: selectedUser.id,
                      isSelected: selectedValue == selectedUser.id,
                      onChanged: (int? value) {
                        if (value != null) {
                          userIdChange(value); // 수정된 함수 호출
                        }
                      },
                      isFixed: true,
                    )
                        : Center(child: Text('사용자를 선택해주세요')),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      int userId = userList.keys.elementAt(index);
                      return userBox(
                        context: context,
                        userId: userId,
                        isSelected: selectedValue == userId,
                        onChanged: (int? value) {
                          if (value != null) {
                            userIdChange(value); // 수정된 함수 호출
                          }
                        },
                      );
                    },
                    childCount: userList.length,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('사용자 추가'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              onChanged: (value) {
                                _name = value;
                              },
                              decoration: InputDecoration(
                                hintText: '이름(한글 2~4자)',
                              ),
                            ),
                            TextFormField(
                              controller: _genderController,
                              onChanged: (value) {
                                _gender = value;
                              },
                              decoration: InputDecoration(
                                hintText: '성별(남자 또는 여자로 입력)',
                              ),
                            ),
                            TextFormField(
                              controller: _birthDateController,
                              onChanged: (value) {
                                _birthDate = value;
                              },
                              decoration: InputDecoration(
                                hintText: '생년월(YYYY-MM 형식으로 입력 ex. 2000-01)',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              if (_name != null &&
                                  _gender != null &&
                                  _birthDate != null) {
                                try {
                                  await createUser(
                                    name: _name!,
                                    gender: _gender!,
                                    birthDate: _birthDate!,
                                  );
                                  await getUserList(
                                      userList: userList); // 데이터 갱신 후 상태 업데이트
                                  setState(() {});
                                  Navigator.of(context).pop(); // 화면 닫기
                                } catch (e) {
                                  print("Error: $e");
                                  Fluttertoast.showToast(
                                      msg: "사용자 추가에 실패했습니다. 다시 시도해주세요.");
                                }
                              }
                            },
                            child: Text('추가'),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Text('추가'),
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.indigo,
                      size: MediaQuery.of(context).size.height * 0.065,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userBox({
  required BuildContext context,
  required int userId,
  required bool isSelected,
  required void Function(int?) onChanged,
  bool isFixed = false,
  bool isUserAddBox = false,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
    child: Container(
      decoration: BoxDecoration(
        color: !isFixed ? Colors.white : Color(0x3F3F51B5),
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: !isUserAddBox
          ? Stack(
        children: [
          if (!isFixed)
            Positioned(
              left: 8.0,
              top: 8.0,
              child: Checkbox(
                value: isSelected,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    onChanged(userId); // 체크박스 클릭 시 userId 전달
                  }
                },
              ),
            ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isFixed)
                  userList[userId]?.image != ""
                      ? Image.network(
                    userList[userId]!.image!,
                    height: MediaQuery.of(context).size.height * 0.15,
                  )
                      : Icon(
                    Icons.account_circle_rounded,
                    size: MediaQuery.of(context).size.height * 0.15,
                    color: userList[userId]!.gender == '남자'
                        ? Colors.indigo
                        : Colors.pink,
                  ),
                Text(
                  '${userList[userId]!.name}님',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '성별 : ${userList[userId]!.gender}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                Text(
                  '나이(생년월) : ${DateTime.now().year - int.parse(userList[userId]!.birthDate.substring(0, 4)) + 1}세 (${userList[userId]!.birthDate.substring(0, 4)}년 ${userList[userId]!.birthDate.substring(5, 7)}월)',
                ),
              ],
            ),
          ),
        ],
      )
          : Text("사용자 추가"),
    ),
  );
}
