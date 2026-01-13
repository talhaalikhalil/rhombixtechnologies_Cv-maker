import 'package:hive_flutter/adapters.dart';
part 'person.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String fullname;
  @HiveField(1)
  String email;
  @HiveField(2)
  String phone;
  @HiveField(3)
  String address;
  @HiveField(4)
  String degree;
  @HiveField(5)
  String uni;
  @HiveField(6)
  String year;
  @HiveField(7)
  String grade;
  @HiveField(8)
  String company;
    @HiveField(9)
  String role;
    @HiveField(10)
  String experience;
    @HiveField(11)
  String skills;
  Person({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.address,
    required this.degree,
    required this.uni,
    required this.year,
    required this.grade,
    required this.company,
    required this.role,
    required this.experience,
    required this.skills,
  });
}
