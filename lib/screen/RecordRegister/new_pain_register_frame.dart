import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../UserData/MYTOKEN.dart';
import '../../common/only_title_appbar.dart';
import '../pain_record/pain_record_page_title.dart';
import 'new_pain_register_step_one.dart';
import 'new_pain_register_step_two.dart';

/**
 * 설명
 * - 통증 조사를 하기 위한 화면의 틀입니다.
 * - 이 화면에서는 부위별 통증을 조사할 수 있습니다.
 *
 *  return : Scaffold
 */

class NewPainRegisterFrame extends StatefulWidget {
  const NewPainRegisterFrame({required this.part, super.key});

  final String part; // part를 final로 설정

  @override
  State<NewPainRegisterFrame> createState() => _NewPainRegisterFrameState();
}

class _NewPainRegisterFrameState extends State<NewPainRegisterFrame> {
  bool isFirstStep = true;
  bool isSecondStep = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? painStartSelected;
  int? painPersistSelected;

  Map<String, bool> _symptomStates = {}; // 초기값을 빈 맵으로 설정
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchSymptoms();
  }

  Future<void> _fetchSymptoms() async {
    try {
      final response = await _dio.get(
        'http://10.10.7.26:8080/api/symptoms',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${MYTOKEN}',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> symptomsData = response.data['data'];
        setState(() {
          _symptomStates = {
            for (var item in symptomsData) item['symptom']: false,
          };
        });
      } else {
        print('Failed to load symptoms');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleSymptomTap(String text) {
    setState(() {
      _symptomStates[text] = !_symptomStates[text]!;
    });
  }

  void _handleCheckboxChanged(bool? value, String step) {
    setState(() {
      if (step == '1') {
        if (value == true) {
          isFirstStep = true;
          isSecondStep = false;
        } else {
          isFirstStep = false;
          isSecondStep = false;
        }
      } else if (step == '2') {
        if (value == true) {
          isFirstStep = false;
          isSecondStep = true;
        } else {
          isFirstStep = false;
          isSecondStep = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnlyTitleAppbar.createAppBar("새로운 통증"),
      body: _symptomStates.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                PainRecordPageTitle(
                  explainText: isFirstStep
                      ? "님과 관련이 있는 증상을 모두 선택하세요"
                      : '님이 아픈 위치와 추가 정보를 입력하세요',
                  explain_text_fontSize: 12.0,
                ),
                isFirstStep
                    ? NewPainRegisterStepOne(
                        isFirstStep: isFirstStep,
                        isSecondStep: isSecondStep,
                        onCheckboxChanged: _handleCheckboxChanged,
                        symptomStates: _symptomStates,
                        handleSymptomTap: _handleSymptomTap,
                      )
                    : NewPainRegisterStepTwo(
                        isFirstStep: isFirstStep,
                        isSecondStep: isSecondStep,
                        onCheckboxChanged: _handleCheckboxChanged,
                        symptoms: _symptomStates,
                        handleSymptomTap: _handleSymptomTap,
                        painArea: widget.part,
                      ),
              ],
            ),
    );
  }
}
