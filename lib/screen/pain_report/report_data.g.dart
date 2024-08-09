// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
      id: (json['id'] as num).toInt(),
      note: json['note'] as String,
      painIntensity: (json['painIntensity'] as num).toInt(),
      painMood: json['painMood'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'painIntensity': instance.painIntensity,
      'painMood': instance.painMood,
      'createdAt': instance.createdAt,
    };
