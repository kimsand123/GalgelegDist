import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../base_pages/base_page.dart';
import '../mixins/appbar_page_mixin.dart';

class HomePage extends BasePage {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> with AppbarPage {
  /*
  Content goes here.
  This is an example of the provider/consumer pattern.
  This screen consumes whatever is provided by the "AnyProvider".
  */
  @override
  Widget body() {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Welcome', style: appTheme().textTheme.display3),
          Consumer<UserProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [ 
                  Text('${provider.user.username}', style: appTheme().textTheme.body2),
                  Text('\'${provider.user.alias}\'', style: appTheme().textTheme.body1)
              ]);
            },
          ),
        ],
      )
    );
  }

  @override
  Widget title() => Text('Home page', 
    textAlign: TextAlign.center, 
    style: appTheme()
            .textTheme
            .headline
            .copyWith(color: appTheme().colorScheme.onPrimary)
    );

}