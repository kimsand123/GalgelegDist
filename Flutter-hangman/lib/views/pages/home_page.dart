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
  Widget title() => Text('Home');

  @override
  Widget body() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: contentHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Consumer<UserProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '${provider.user.username} is logged in with token: ',
                            style: appTheme().textTheme.caption),
                      ),
                      Text(
                        '${provider.user.token}',
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
        ),
        Visibility(
          child: Container(
              height: contentHeight,
              width: screenWidth(),
              alignment: Alignment.center,
              child: CircularProgressIndicator()),
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
    Navigator.pushReplacementNamed(context, gamePageRoute);
  }
}
