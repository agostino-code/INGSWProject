import 'package:flutter/material.dart';
import 'package:ratatouillestaff/benvenuto.dart';
import 'package:ratatouillestaff/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Ratatouille',
      theme: ThemeData(
        primaryColor: const Color(0xFF00bb00),
        backgroundColor: Colors.grey[200],
        primaryColorDark: const Color(0xFF009900),
        cardColor: const Color(0xFFFFFFFF),
        ),
      home: const BenvenutoScreen(),
      routes: mainRouting(),
    );
  }
}
