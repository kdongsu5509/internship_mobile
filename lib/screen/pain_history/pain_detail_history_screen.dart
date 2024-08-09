import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:p2record/screen/pain_history/pain_history_detail.dart';
import '../../UserData/MYTOKEN.dart';

class PainDetailHistoryScreen extends StatefulWidget {
  final int id;

  const PainDetailHistoryScreen({required this.id});

  @override
  _PainDetailHistoryScreenState createState() => _PainDetailHistoryScreenState();
}

class _PainDetailHistoryScreenState extends State<PainDetailHistoryScreen> {
  PainHistoryDetail? painHistoryDetail;
  bool isLoading = false;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getPainHistory();
  }

  Future<void> getPainHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await dio.get(
        'http://10.10.7.26:8080/api/records/${widget.id}',
        options: Options(
          headers: {
            'authorization': 'Bearer $MYTOKEN',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Check if response.data is not null
        if (response.data != null) {
          setState(() {
            painHistoryDetail = PainHistoryDetail.fromJson(response.data['data']);
          });
        } else {
          throw Exception('Empty response data');
        }
      } else {
        throw Exception('Failed to load pain history');
      }
    } catch (e) {
      print('Error fetching pain history: $e');
      // Handle error gracefully, e.g., show error message to user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('통증 상세'),
    ),
    body: Center(
    child: isLoading
    ? CircularProgressIndicator()
        : (painHistoryDetail != null
    ? Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('통증 부위: ${painHistoryDetail!.painArea}'),
    Text('통증 시작일: ${painHistoryDetail!.painStartDateTime}'),
    Text('통증 강도: ${painHistoryDetail!.painIntensity}'),
    Text('메모: ${painHistoryDetail!.note}'),
    ],
    )
        : Text('데이터를 불러올 수 없습니다.')), // Handle no data scenario
    ),
    );
  }
}
