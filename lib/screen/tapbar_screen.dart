import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:p2record/screen/pain_history/pain_history.dart';
import 'package:p2record/screen/pain_record/pain_record.dart';
import 'package:p2record/screen/pain_report/pain_report.dart';
import 'package:p2record/screen/user_select_screen.dart';
import 'hospital_map.dart';

// HomeScreen Main
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, bool? moveToHistory}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController tabController; // TabController 선언
  TextStyle textStyle = TextStyle(fontSize: 20);
  bool shouldRebuildPainRecord = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 5,
      vsync: this,
    );

    // 상태 변경을 감지하여 setState 호출
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  void triggerPainRecordRebuild() {
    setState(() {
      shouldRebuildPainRecord = !shouldRebuildPainRecord;
    });
  }

  @override
  Widget build(BuildContext context) {
    int choosedIdx = tabController.index; // 현재 선택된 탭의 인덱스

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        title: MainTitle(context: context),
        bottom: MainTabBar(tabController: tabController),
      ),
      body: _SelectedView(choosedIdx: choosedIdx, context: context, triggerPainRecordRebuild: triggerPainRecordRebuild,),
    );
  }
}

// 제목과 이미지를 가진 Row 위젯
Row MainTitle({
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '통증기록관리',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      Image(
        image: Svg('asset/img/silla_logo.svg'),
        width: MediaQuery.of(context).size.width * 0.1,
      ),
    ],
  );
}

// TabBar의 Bottom을 관리.
TabBar MainTabBar({required TabController tabController}) {
  List<Widget> tabsList = [
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('통증 기록'),
    ),
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('통증 이력'),
    ),
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('통증 그래프'),
    ),
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('병원 찾기'),
    ),
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('사용자 등록'),
    ),
  ];

  return TabBar(
    isScrollable: true,
    tabAlignment: TabAlignment.start,
    unselectedLabelStyle: TextStyle(color: Colors.black26),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    indicatorColor: Colors.black,
    labelColor: Colors.black,
    labelPadding: EdgeInsets.symmetric(horizontal: 8),
    controller: tabController,
    tabs: tabsList,
  );
}

// 선택된 탭에 따라 보여지는 화면을 관리
Widget _SelectedView({
  required int choosedIdx,
  required BuildContext context,
  required VoidCallback triggerPainRecordRebuild,
}) {
  switch (choosedIdx) {
    case 0:
      return PainRecord(addfunc: triggerPainRecordRebuild);
    case 1:
      return PainHistory();
    case 2:
      return PainReport(context: context);
    case 3:
      return HospitalMap();
    case 4:
      return UserSelectScreen(addfunc: triggerPainRecordRebuild);
    default:
      return SizedBox.shrink(); // 기본 빈 위젯 반환
  }
}
