import 'package:flutter/material.dart';

import 'screens/DashBorad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashBoard(),
      debugShowCheckedModeBanner: false,
    );
  }
}