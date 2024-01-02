import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{

  // init hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Habit_Database");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habbit Tracker',
        home: const HomePage(),
        theme: ThemeData(primarySwatch: Colors.green),
      ),
    );
  }
}
