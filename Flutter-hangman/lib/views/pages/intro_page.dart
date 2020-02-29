import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hangman/model/user.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../routing/routing_paths.dart';
import '../base_pages/base_page.dart';
import '../components/button.dart';
import '../mixins/appbar_page_mixin.dart';

class IntroPage extends BasePage {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends BasePageState <IntroPage> with AppbarPage {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User user = User();

  /*
  We create a model for our provider to pass on to the consumers.
  */
  @override
  Widget body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(),
          Text('Login', style: appTheme().textTheme.display3),
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0x10000000),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: usernameController,
                  maxLines: 1,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Username'
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0x10000000),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  maxLines: 1,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Password'
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
          
          Button(
            onPressed: () {
              login();
              Navigator.pushNamed(context, homePageRoute);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget title() => Text('Intro', 
    textAlign: TextAlign.center, 
    style: appTheme()
            .textTheme
            .headline
            .copyWith(color: appTheme().colorScheme.onPrimary)
    );

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  void login() async {
    var response;
    var apiUrl = 'http://130.225.170.204:8970/';

    try {
      response = await http.get(apiUrl);
      if(response.statusCode == 200) {
        userFromJson(response.body).forEach((u) {
          if(u.username == 'Kim') user = u;
        });
        Provider.of<UserProvider>(context, listen: false).setUser(user);
      } else {
        print("Got error status code: " + response.statusCode);
      }
    } catch(exception) {
      print(exception);
    }
  }  
}