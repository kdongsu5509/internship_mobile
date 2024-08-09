import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:p2record/screen/pain_report/report_data.dart';
import '../../UserData/MYTOKEN.dart';

class MyLineChart extends StatefulWidget {
  final String painArea;
  final String startDate;
  final String endDate;
  List<ReportData> reportData;

  MyLineChart({
    required this.painArea,
    required this.startDate,
    required this.endDate,
    required this.reportData,
    super.key,
  });

  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  final Dio dio = Dio();
  late Future<void> _dataFuture;

  Future<void> requestSpecificRecordList({
    required String painArea,
    required String startDate,
    required String endDate,
  }) async {
    switch (widget.painArea) {
      case '손 / 손가락':
        painArea = '손/손가락';
        break;
      case '목 / 어깨':
        painArea = '목/어깨';
        break;
      case '등 / 허리':
        painArea = '등/허리';
        break;
      case '다리 / 발':
        painArea = '다리/발';
        break;
    }

    String encodedString = Uri.encodeComponent(painArea);

    startDate = widget.startDate;
    endDate = widget.endDate;

    try {
      Response resp = await dio.get(
        'http://10.10.7.26:8080/api/records/report?painArea=$encodedString&startDate=$startDate&endDate=$endDate',
        options: Options(
          headers: {
            'Authorization': 'Bearer $MYTOKEN',
          },
        ),
      );
      print('Response received: ${resp.data}');

      List<Map<String, dynamic>> temp =
          List<Map<String, dynamic>>.from(resp.data['data']);
      if (mounted) {
        setState(() {
          widget.reportData = temp.map((e) => ReportData.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print('http://10.10.7.26:8080/api/records/report?painArea=$encodedString&startDate=$startDate&endDate=$endDate');
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = requestSpecificRecordList(
      painArea: widget.painArea,
      startDate: widget.startDate,
      endDate: widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Waiting for future to complete...');
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Snapshot error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    exit(1);
                  },
                  child: Text('Exit'),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          print('Data length: ${widget.reportData.length}');
          if (widget.reportData.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          Set<DateTime> dateSet = widget.reportData
              .map((e) => DateTime.parse(e.createdAt.substring(0, 10)))
              .toSet();
          List<DateTime> dateList = dateSet.toList(); // 중복이 제거된 날짜 리스트

          // 날짜 변환 및 x축 값 생성
          final List<FlSpot> real_spots =
              _toLineGraphDate(dateList: dateList); // 그래프에 표시할 데이터

          bool isFirstDayMark = false;

          return Container(
            padding: EdgeInsets.fromLTRB(0, 8, 16, 16),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: real_spots,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minY: 0,
                maxY: 10,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        print('date: $date');
                        // 매 5일마다 타이틀을 표시
                        if (!isFirstDayMark || date == dateList.first) {
                          print(
                              'date ****************************************** $date');
                          isFirstDayMark = true;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '', // 원하는 날짜 포맷으로 수정
                            ),
                          );
                        } else if (isFirstDayMark || date == dateList.first) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${date.month}/${date.day}', // 원하는 날짜 포맷으로 수정
                            ),
                          );
                        } else if (date.day != dateList.first.day &&
                            isFirstDayMark) {
                          print('date ==> $date');
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${date.month}/${date.day}', // 원하는 날짜 포맷으로 수정
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('Unexpected state.'));
        }
      },
    );
  }

  List<FlSpot> _toLineGraphDate({
    required List<DateTime> dateList,
  }) {
    List<FlSpot> spots = [];

    // 정렬
    dateList.sort((a, b) => a.compareTo(b));

    // 날짜별로 통증 정도를 평균 내어 그래프에 표시할 데이터로 변환
    for (var temp in dateList) {
      List<int> painIntensityList = widget.reportData
          .where((e) => DateTime.parse(e.createdAt.substring(0, 10)) == temp)
          .map((e) => e.painIntensity)
          .toList();

      if (painIntensityList.isNotEmpty) {
        // 리스트가 비어있지 않은 경우에만 평균 계산
        double averagePainIntensity =
            painIntensityList.reduce((a, b) => a + b) /
                painIntensityList.length; //여기서 중복 발생!!!!!!!!
        spots.add(FlSpot(
            temp.millisecondsSinceEpoch.toDouble(), averagePainIntensity));
      }
    }

    print("the result");
    for (var x in spots) {
      print('x: ${x.x}, y: ${x.y}');
    }

    return spots;
  }


}