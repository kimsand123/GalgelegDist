import 'package:flutter/material.dart';

import '../views/pages/home_page.dart';
import '../views/pages/login_page.dart';
import 'routing_paths.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPageRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: loginPageRoute),
            builder: (_) => LoginPage());

      case homePageRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: homePageRoute),
            builder: (_) => HomePage());

      default:
        return MaterialPageRoute(
            settings: RouteSettings(name: 'Error/${settings.name}'),
            builder: (_) {
              return Scaffold(
                appBar: AppBar(title: Text(settings.name)),
                body: Center(
                    child: Text(
                        'The page \'${settings.name}\' \nIs not implemented yet.')),
              );
            });
    }
  }
}
