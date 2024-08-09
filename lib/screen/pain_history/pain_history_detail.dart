class PainHistoryDetail {
  final int id;
  final int userId;
  final String painArea;
  final int painAreaDetail;
  final int painIntensity;
  final String note;
  final DateTime? painStartTime;
  final DateTime? painEndTime;
  final DateTime? painStartDateTime;
  final String painDuration;

  PainHistoryDetail({
    required this.id,
    required this.userId,
    required this.painArea,
    required this.painAreaDetail,
    required this.painIntensity,
    required this.note,
    this.painStartTime,
    this.painEndTime,
    this.painStartDateTime,
    required this.painDuration,
  });

  factory PainHistoryDetail.fromJson(Map<String, dynamic> json) {
    return PainHistoryDetail(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      painArea: json['painArea'] ?? '',
      painAreaDetail: json['painAreaDetail'] ?? 0,
      painIntensity: json['painIntensity'] ?? 0,
      note: json['note'] ?? '',
      painStartTime: json['painStartTime'] != null ? DateTime.tryParse(json['painStartTime'].toString()) : null,
      painEndTime: json['painEndTime'] != null ? DateTime.tryParse(json['painEndTime'].toString()) : null,
      painStartDateTime: json['painStartDateTime'] != null ? DateTime.tryParse(json['painStartDateTime'].toString()) : null,
      painDuration: json['painDuration'] ?? '',
    );
  }
}
