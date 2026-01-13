import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_app/model/person.dart';
import 'package:my_app/resumer/providers.dart';

void deleteAllDB() {
  final box = Hive.box<Person>('cvDB');
  box.clear(); // 🧹 Deletes all records from the Hive box
  print("🗑️ All data deleted from Hive box!");
}

void deleteSingleCV(int index) {
  final box = Hive.box<Person>('cvDB');
  box.deleteAt(index); // 🗑️ Deletes a single CV at the specified index
  print("🗑️ CV deleted at index $index!");
}

void saveDB(WidgetRef ref) {
  final box = Hive.box<Person>('cvDB');

  final fullname = ref.read(fullnameProvider);
  final email = ref.read(emailProvider);
  final contact = ref.read(contactProvider);
  final address = ref.read(addressProvider);
  final degree = ref.read(degreeProvider);
  final uni = ref.read(uniProvider);
  final year = ref.read(passingYearProvider);
  final grade = ref.read(gradeProvider);
  final company = ref.read(companyProvider);
  final role = ref.read(roleProvider);
  final experience = ref.read(durationProvider);
  final skills = ref.read(skillProvider);

  final person = Person(
    fullname: fullname,
    email: email,
    address: address,
    phone: contact,
    degree: degree,
    uni: uni,
    year: year,
    grade: grade,
    company: company,
    experience: experience,
    role: role,
    skills: skills,
  );

  box.add(person); // ✅ save to Hive

  if (box.isNotEmpty) {
    print("✅ Successfully added data to Hive.\n");
  }
}

void updateDB(WidgetRef ref, int index) {
  final box = Hive.box<Person>('cvDB');

  final person = Person(
    fullname: ref.read(fullnameProvider),
    email: ref.read(emailProvider),
    address: ref.read(addressProvider),
    phone: ref.read(contactProvider),
    degree: ref.read(degreeProvider),
    uni: ref.read(uniProvider),
    year: ref.read(passingYearProvider),
    grade: ref.read(gradeProvider),
    company: ref.read(companyProvider),
    experience: ref.read(durationProvider),
    role: ref.read(roleProvider),
    skills: ref.read(skillProvider),
  );

  box.putAt(index, person); // ✅ update in Hive
  print("✅ Successfully updated data in Hive at index $index.\n");
}

void clearProviders(WidgetRef ref) {
  ref.read(fullnameProvider.notifier).state = "";
  ref.read(emailProvider.notifier).state = "";
  ref.read(contactProvider.notifier).state = "";
  ref.read(addressProvider.notifier).state = "";
  ref.read(degreeProvider.notifier).state = "";
  ref.read(uniProvider.notifier).state = "";
  ref.read(passingYearProvider.notifier).state = "";
  ref.read(gradeProvider.notifier).state = "";
  ref.read(companyProvider.notifier).state = "";
  ref.read(roleProvider.notifier).state = "";
  ref.read(durationProvider.notifier).state = "";
  ref.read(skillProvider.notifier).state = "";
  ref.read(editingIndexProvider.notifier).state = null;
}
