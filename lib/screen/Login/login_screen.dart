import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/CustomTextFormField.dart';
import '../../request_fuction/user_request.dart';
import 'register_screen.dart';

class Login extends StatefulWidget {
  final VoidCallback onLogin; // 로그인 성공 시 호출할 콜백 함수
  const Login({required this.onLogin, super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorTextOfEmail; // 에러 텍스트를 저장할 변수 추가
  String? _errorTextOfPassword; // 에러 텍스트를 저장할 변수 추가

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // 이메일 검증 함수
  void _validateEmail(String value) {
    setState(
      () {
        if (!_emailRegExp.hasMatch(value)) {
          _errorTextOfEmail = '유효한 이메일 주소를 입력하세요.';
        } else {
          _errorTextOfEmail = null;
        }
      },
    );
  }

  // 비밀번호 검증 함수
  void _validatePassword(String value) {
    setState(
      () {
        if (value.length < 6) {
          // 비밀번호 길이 검증
          _errorTextOfPassword = '비밀번호는 6자 이상이어야 합니다.';
        } else {
          _errorTextOfPassword = null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 화면을 가리지 않도록 설정
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loginTitle(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                controller: _emailController,
                onChanged: _validateEmail,
                hintText: '이메일을 입력해주세요',
                errorText: _errorTextOfEmail,
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                controller: _passwordController,
                onChanged: _validatePassword,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                errorText: _errorTextOfPassword,
              ),
              const SizedBox(height: 32),
              _Buttons(
                context: context,
                emailController: _emailController,
                passwordController: _passwordController,
                onLogin: widget.onLogin,
              ),
              const SizedBox(height: 48), // 여백을 추가하여 버튼이 잘리는 것을 방지
            ],
          ),
        ),
      ),
    );
  }
}

// 제목과 이미지를 가진 Column 위젯
Widget _loginTitle({required BuildContext context}) {
  return Center(
    child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Image(
            image: Svg('asset/img/silla_logo.svg'), // SVG 경로 수정
          ),
        ),
        Text(
          '통증 기록 관리',
          style: TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 16),
        Text(
          '※ 개인 정보 보호를 위해 앱 종료 시 사용자 정보가 삭제됩니다. \n ※ 그로 인해 앱 재실행 시 다시 로그인하셔야 합니다.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        )
      ],
    ),
  );
}

// 로그인, 회원가입 버튼을 가진 Row 위젯
Widget _Buttons({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required VoidCallback onLogin,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextButton(
            onPressed: () async {
              try {
                await login(
                    emailController: emailController,
                    passwordController: passwordController,
                    context: context,
                    onLogin: onLogin); // Correctly await the async operation
                // Handle post-login actions here (e.g., navigate to a new page)
              } catch (e) {
                // Handle any errors that occurred during login
                Fluttertoast.showToast(msg: '로그인 실패');
                print('Login failed: $e');
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('로그인'),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MemberRegister()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text('회원가입'),
          ),
        ),
      ],
    ),
  );
}
