import 'package:json_annotation/json_annotation.dart';

part 'report_data.g.dart';

@JsonSerializable() // 일단 json serializable만/ retrofit은 나중에
class ReportData {
  final int id;
  final String note;
  final int painIntensity;
  final String painMood;
  final String createdAt;

  ReportData({
    required this.id,
    required this.note,
    required this.painIntensity,
    required this.painMood,
    required this.createdAt,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);
}