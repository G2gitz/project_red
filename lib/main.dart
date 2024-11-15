import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_red/screens/DashBoardjA.dart';

import 'screens/DashBorad.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with web options (for desktop workaround)
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBNIO3qM75uOyNQdnYMRHvTXTR9NpDTva8",
        authDomain: "prored004.firebaseapp.com",
        projectId: "prored004",
        storageBucket: "prored004.firebasestorage.app",
        messagingSenderId: "706031752598",
        appId: "1:706031752598:web:e7da69b3d570e6b076f9b7"),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}