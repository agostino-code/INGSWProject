import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:ratatouillestaff/app/globals.dart';
import 'package:ratatouillestaff/app/ui/views/home.dart';
import 'package:ratatouillestaff/app/ui/views/orderhistory.dart';
import 'package:ratatouillestaff/app/ui/views/sendendorder.dart';

import '../../middleware/auth_middleware.dart';
import '../controllers/home_controller.dart';
import '../data/models/user_model.dart';
import '../ui/views/benvenuto.dart';
import '../ui/views/changepassword.dart';
import '../ui/views/login.dart';
import '../ui/views/menu.dart';
import '../ui/views/neworder.dart';
import '../ui/views/pendingorders.dart';
import '../ui/views/profile.dart';

AuthMiddleware authMiddleware = AuthMiddleware();
Navigator myAppNavigator = Navigator(
  initialRoute: '/',
  key: myAppNavigatorKey,
  observers: [
    FirebaseAnalyticsObserver(analytics: analytics),
  ],
  onGenerateRoute: (RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case '/':
        builder = (BuildContext context) => const BenvenutoView();
        break;
      case '/login':
        builder = (BuildContext context) => FutureBuilder<bool>(
              future: authMiddleware.isAlreadyLogIn(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return FutureBuilder<User?>(
                      future: authMiddleware.checkFirstLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.firstlogin == true) {
                            return ChangePasswordView(firstLogin: true);
                          } else {
                            if (snapshot.data!.role == 'kitchen') {
                              return const KitchenHome();
                            } else {
                              if (snapshot.data!.role == 'waiter') {
                                return const MenuView();
                              }
                            }
                          }
                        } else {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return LoginView();
                      },
                    );
                  } else {
                    return LoginView();
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
        break;
      case '/menu':
        builder = (BuildContext context) => const MenuView();
        break;
      case '/changepassword':
        builder = (BuildContext context) => ChangePasswordView(firstLogin: settings.arguments as bool);
        break;
      case '/neworder':
        builder = (BuildContext context) =>
            NewOrderView(controller: settings.arguments as HomeController);
        break;
      case '/pendingorders':
        builder = (BuildContext context) => const PendingOrders();
        break;
      case '/orderhistory':
        builder = (BuildContext context) => OrderHistory();
        break;
      case '/sendendorder':
        builder = (BuildContext context) =>
            SendendOrder(table: settings.arguments as int);
        break;
      case '/kitchenhome':
        builder = (BuildContext context) => const KitchenHome();
        break;
      case '/profile':
        builder = (BuildContext context) => Profile();
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
    return MaterialPageRoute(builder: builder, settings: settings);
  },
);
