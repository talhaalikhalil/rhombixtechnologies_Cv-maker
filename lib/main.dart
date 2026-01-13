import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_app/model/person.dart';
import 'package:my_app/resumer/boarding.dart';
import 'package:my_app/resumer/cv.dart';
import 'package:my_app/resumer/fill_form.dart';
import 'package:my_app/resumer/page_one.dart';
import 'package:my_app/resumer/page_three.dart';
import 'package:my_app/resumer/page_two.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // initialize Hive
  Hive.registerAdapter(PersonAdapter());
  await Hive.openBox<Person>('cvDB');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: FillForm(),
      initialRoute: '/boarding',
      routes: {
        '/boarding': (context) => const BoardingScreen(),
        '/personal_info': (context) => const ScreenOne(),
        '/education': (context) => const ScreenTwo(),
        '/experience': (context) => const ScreenThree(),
        '/cv': (context) => const MyCvScreen(),
      },
    );
  }
}
