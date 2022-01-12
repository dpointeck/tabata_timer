import 'package:flutter/material.dart';
import 'package:tabata_timer/home_page.dart';
import './theme/custom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabata Timer',
      debugShowCheckedModeBanner: false,
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: ThemeMode.dark,
      home: const HomePage(title: 'Tabata Timer'),
    );
  }
}


