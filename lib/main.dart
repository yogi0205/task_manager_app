import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:daily_do/pages/home_page.dart'; // Make sure this path is correct!

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox'); // lowercase 'mybox'
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
