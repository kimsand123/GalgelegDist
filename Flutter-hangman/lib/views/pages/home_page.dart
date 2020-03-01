import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:hangman/routing/routing_paths.dart';
import 'package:hangman/views/components/popupComponent.dart';
import 'package:provider/provider.dart';

import '../base_pages/base_page.dart';
import '../components/button.dart';
import '../mixins/appbar_page_mixin.dart';

class HomePage extends BasePage {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> with AppbarPage {
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget title() => null;

  @override
  Widget body() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text('Welcome', style: appTheme().textTheme.display3),
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: <Widget>[
                    Text('${provider.user.username}',
                        style: appTheme().textTheme.display1),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Token:\n${provider.user.token}',
                      style: appTheme().textTheme.subhead,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                      title: 'Start game',
                      onPressed: _loading ? null : _startGame),
                  SizedBox(
                    height: 10,
                  ),
                  Button(
                      title: 'Log out', onPressed: _loading ? null : _logout),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
        Visibility(
          child: CircularProgressIndicator(),
          visible: _loading,
        ),
      ],
    );
  }

  void _logout() {
//TODO Send logout to server to remove token from active-list
    setState(() {
      _loading = true;
    });

    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.pushNamedAndRemoveUntil(context, loginPageRoute,
          ModalRoute.withName(Navigator.defaultRouteName));
      setState(() {
        _loading = false;
      });
    });
  }

  void _startGame() {
    //TODO: Implement gameflow
    showPopupDialog(
      context,
      'This is not implemented yet',
      'Relax dude',
      {
        Text(
          "Ok, i will relax",
        ): null,
      },
    );
  }
}
