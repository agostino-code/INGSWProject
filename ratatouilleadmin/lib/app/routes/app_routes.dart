import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/globals.dart';
import 'package:ratatouilleadmin/app/ui/views/items.dart';
import 'package:ratatouilleadmin/app/ui/views/restaurants.dart';

import '../../middleware/auth_middleware.dart';
import '../data/models/category_model.dart';
import '../ui/views/adduser.dart';
import '../ui/views/benvenuto.dart';
import '../ui/views/categories.dart';
import '../ui/views/changepassword.dart';
import '../ui/views/login.dart';
import '../ui/views/menu.dart';
import '../ui/views/profile.dart';
import '../ui/views/statistics.dart';
import '../ui/views/users.dart';

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
                    return FutureBuilder<dynamic>(
                      future: authMiddleware.checkFirstLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.firstlogin == true) {
                            return ChangePasswordView(firstLogin: true);
                          } else {
                            if (snapshot.data!.role == 'admin') {
                              return RestaurantsView();
                            } else {
                              if (snapshot.data!.role == 'supervisor') {
                                return const MenuView(supervisor: true);
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
      case '/restaurants':
        builder = (BuildContext context) => RestaurantsView();
        break;
      case '/menu':
        builder = (BuildContext context) => MenuView(supervisor: settings.arguments as bool);
        break;
      case '/changepassword':
        builder = (BuildContext context) =>
            ChangePasswordView(firstLogin: settings.arguments as bool);
        break;
      case '/statistics':
        builder = (BuildContext context) => StatisticsView();
        break;
      case '/categories':
        builder = (BuildContext context) => CategoriesView(supervisor: settings.arguments as bool);
        break;
      case '/items':
        builder = (BuildContext context) => ItemsView(
              currentCategory: settings.arguments as Categories,
            );
        break;
      case '/profile':
        builder = (BuildContext context) => Profile(supervisor: settings.arguments as bool);
        break;
      case '/users':
        builder = (BuildContext context) => const UserView();
        break;
      case '/adduser':
        builder = (BuildContext context) => const AddUserView();
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
    return MaterialPageRoute(builder: builder, settings: settings);
  },
);
