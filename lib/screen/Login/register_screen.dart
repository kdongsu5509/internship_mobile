import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 로딩 패키지 수정
import '../../common/CustomTextFormField.dart';
import '../../request_fuction/user_request.dart';

class MemberRegister extends StatefulWidget {
  const MemberRegister({super.key});

  @override
  State<MemberRegister> createState() => _MemberRegisterState();
}

class _MemberRegisterState extends State<MemberRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  String? _errorTextOfEmail;
  String? _errorTextOfPassword;
  String? _errorTextOfName;
  String? _errorTextOfGender;
  String? _errorTextOfBirth;

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorTextOfEmail = '이메일을 입력해주세요';
      } else if (!_emailRegExp.hasMatch(value)) {
        _errorTextOfEmail = '유효한 이메일 주소를 입력하세요.';
      } else {
        _errorTextOfEmail = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorTextOfPassword = '비밀번호를 입력해주세요';
      } else if (value.length < 6) {
        _errorTextOfPassword = '비밀번호는 6자 이상이어야 합니다.';
      } else {
        _errorTextOfPassword = null;
      }
    });
  }

  String nameRegex = r'^[가-힣]{2,4}$';

  void validateName(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorTextOfName = '이름을 입력해주세요';
      } else if (!RegExp(nameRegex).hasMatch(value)) {
        _errorTextOfName = '이름은 한글 2~4자로 입력해주세요';
      } else {
        _errorTextOfName = null;
      }
    });
  }

  void validateGender(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorTextOfGender = '성별을 입력해주세요';
      } else if (value != '남자' && value != '여자') {
        _errorTextOfGender = '유효한 입력값 : 남자 or 여자';
      } else {
        _errorTextOfGender = null;
      }
    });
  }

  String birthRegex = r'^[0-9]{4}-[0-9]{2}$';

  void validateBirth(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorTextOfBirth = '생년 월을 입력해주세요';
      } else if (!RegExp(birthRegex).hasMatch(value)) {
        _errorTextOfBirth = '입력 양식 : 출생년도-출생월 \n 입력 예시 : 2024-01';
      } else {
        _errorTextOfBirth = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _loginTitle(context: context),
            ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  infoInputBox(
                    title: '1. 이메일',
                    explainText: '이메일은 아이디로 사용됩니다. \n이메일은 중복가입이 불가능합니다',
                    hintText: '이메일을 입력해주세요',
                    errorText: _errorTextOfEmail ?? '',
                    controller: _emailController,
                    onChanged: _validateEmail,
                    context: context,
                  ),
                  infoInputBox(
                    title: '2. 비밀번호',
                    explainText: '비밀번호는 6자 이상이어야 합니다.',
                    hintText: '비밀번호를 입력해주세요',
                    errorText: _errorTextOfPassword ?? '',
                    controller: _passwordController,
                    onChanged: _validatePassword,
                    context: context,
                    obscureText: true,
                  ),
                  infoInputBox(
                    title: '3. 이름',
                    explainText: '이름은 본인을 식별하기 위한 용도입니다. \n 이름은 한글 2~4자로 입력해주세요',
                    hintText: '이름을 입력해주세요',
                    errorText: _errorTextOfName ?? '',
                    controller: _nameController,
                    onChanged: validateName,
                    context: context,
                  ),
                  infoInputBox(
                    title: '4. 성별',
                    explainText: '한글로 본인의 성별을 적어주세요. \n 유효한 입력값 : 남자 or 여자 \n',
                    hintText: '성별을 입력해주세요',
                    errorText: _errorTextOfGender ?? '',
                    controller: _genderController,
                    onChanged: validateGender,
                    context: context,
                  ),
                  infoInputBox(
                    title: '5. 생년 월을 입력해주세요',
                    explainText: '차후 의사와 공유할 보고서 작성 시 나이 파악에 사용됩니다.\n 입력 양식 : 출생년도-출생월 \n 입력 예시 : 2024-01',
                    hintText: '생년 월을 입력해주세요',
                    errorText: _errorTextOfBirth ?? '',
                    controller: _birthController,
                    onChanged: validateBirth,
                    context: context,
                  ),
                  Buttons(
                    context: context,
                    onRegister: () async {
                      await register(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        nameController: _nameController,
                        genderController: _genderController,
                        birthController: _birthController,
                        errorTextOfEmail: _errorTextOfEmail ?? null,
                        errorTextOfPassword: _errorTextOfPassword ?? null,
                        errorTextOfName: _errorTextOfName ?? null,
                        errorTextOfGender: _errorTextOfGender ?? null,
                        errorTextOfBirth: _errorTextOfBirth ?? null,
                        context: context,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _loginTitle({required BuildContext context}) {
  return SizedBox(
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SvgPicture.asset('asset/img/silla_logo.svg'), // SVG 로딩 수정
        ),
        Text(
          '회원 가입',
          style: TextStyle(fontSize: 40),
        ),
      ],
    ),
  );
}

Widget Buttons({
  required BuildContext context,
  required VoidCallback onRegister,
}) {
  return TextButton(
    onPressed: onRegister,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    child: Text('가입 하기'),
  );
}

Widget infoInputBox({
  required String title,
  required String explainText,
  required String hintText,
  required String errorText,
  required TextEditingController controller,
  required Function(String) onChanged,
  required BuildContext context,
  bool obscureText = false,
}) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
              Text(explainText),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomTextFormField(
            obscureText: obscureText,
            controller: controller,
            onChanged: onChanged,
            hintText: hintText,
            errorText: errorText,
          ),
        ),
      ],
    ),
  );
}
