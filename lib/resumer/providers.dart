import 'package:flutter_riverpod/legacy.dart';

// personal information---
final fullnameProvider = StateProvider((ref) => "");
final emailProvider = StateProvider((ref) => "");
final contactProvider = StateProvider((ref) => "");
final addressProvider = StateProvider((ref) => "");

//education---
final degreeProvider = StateProvider((ref) => "");
final uniProvider = StateProvider((ref) => "");
final passingYearProvider = StateProvider((ref) => "");
final gradeProvider = StateProvider((ref) => "");

//work experience---
final companyProvider = StateProvider((ref) => "");
final roleProvider = StateProvider((ref) => "");
final durationProvider = StateProvider((ref) => "");
final skillProvider = StateProvider((ref) => "");

// editing index---
final editingIndexProvider = StateProvider<int?>((ref) => null);

// page index provider---
