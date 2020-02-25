import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'routing/router.dart';
import 'routing/routing_paths.dart';
import 'views/themes/light_theme.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider()
      )
    ],
    child: Hangman(),
  )
);

class Hangman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman app',
      theme: LightTheme.themeData,
      onGenerateRoute: Router.generateRoute,
      initialRoute: introPageRoute,
    );
  }
}
