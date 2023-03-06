import 'package:flutter/material.dart';

import 'app/globals.dart';
import 'app/routes/app_routes.dart';
import 'app/ui/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratatouille',
      theme: myAppThemeData,
      home: myAppNavigator,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
