// lib/UserData/user.dart
class User {
  final int id;
  final String? image;
  final String name;
  final String gender;
  final String birthDate;
  final int groupId;

  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.groupId,
    required this.image,
  });

  String get getName => name;
  int get getId => id;
}
