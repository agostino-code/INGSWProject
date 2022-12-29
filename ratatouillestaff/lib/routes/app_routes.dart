import 'package:flutter/material.dart';

import '../benvenuto.dart';
import '../login.dart';

String benvenutoScreen = '/benvenuto';

String loginScreen = '/login';

Map<String, WidgetBuilder> mainRouting() {
  return {
    benvenutoScreen: (context) => const BenvenutoScreen(),
    loginScreen: (context) => const LoginScreen(),
  };
}
