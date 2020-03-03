import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hangman/model/user.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:hangman/remote/http_remote.dart';
import 'package:hangman/routing/routing_paths.dart';
import 'package:hangman/views/components/popupComponent.dart';
import 'package:provider/provider.dart';

import '../base_pages/base_page.dart';
import '../components/button.dart';
import '../mixins/appbar_page_mixin.dart';
import 'package:http/http.dart' as http;

class LoginPage extends BasePage {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends BasePageState<LoginPage> with AppbarPage {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate, _loading;

  TextEditingController _userNameController;
  TextEditingController _passwordController;

  FocusNode _userNameFocus;
  FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _autoValidate = false;
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();

    if (kDebugMode) {
      _userNameController.text = "s160198";
      _passwordController.text = "densikkrestekode";
    }

    _userNameFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget title() => Text('');

  @override
  Widget body() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          height: contentHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Login',
                  style: appTheme()
                      .textTheme
                      .display3
                      .copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0x10000000),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _userNameController,
                        maxLines: 1,
                        decoration:
                            InputDecoration.collapsed(hintText: 's170000'),
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        validator: _validateEmail,
                        textInputAction: TextInputAction.next,
                        focusNode: _userNameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _userNameFocus, _passwordFocus);
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0x10000000),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        maxLines: 1,
                        decoration:
                            InputDecoration.collapsed(hintText: '************'),
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (term) {
                          setState(() {
                            _autoValidate = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Button(
                      title: 'Login',
                      onPressed: _loading ? null : _validateInputs),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'The app is made during the course: 62597 at DTU \n' +
                        '\nCreated by: \n ' +
                        's163290 - (Kim Bossen) \n' +
                        's170423 - (Sebastian Sørensen) \n' +
                        's160198 - (Niklaes Jacobsen) \n' +
                        '\nThis app was made with Flutter <3',
                    style: appTheme().textTheme.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
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

  String _validateEmail(String value) {
    if (value.length == 0)
      return 'Enter a username';
    else
      return null;
  }

  String _validatePassword(String arg) {
    if (arg.length == 0)
      return 'Enter a password';
    else
      return null;
  }

  _validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _loading = true;
      });

      String username = _userNameController.text;
      String password = _passwordController.text;
      User user = User(username: username, password: password);

      try {
        http.Response response = await HttpRemote().login(user);

        print(
            'Auth: \n${response.statusCode} - ${response.reasonPhrase} - ${response.body}');

        if (response.statusCode == 200) {
          user.token = json.decode(response.body);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.pushNamedAndRemoveUntil(context, homePageRoute,
              ModalRoute.withName(Navigator.defaultRouteName));
        } else {
          print(
              'An error occured: \n${response.statusCode} - ${response.reasonPhrase}');
          var errorResponse;
          if (response.statusCode == 403) {
            errorResponse = json.decode(response.body)["error"];
          } else {
            errorResponse = 'Something went wrong';
          }

          showPopupDialog(
            context,
            'An error occured',
            '$errorResponse',
            {
              Text(
                "Ok",
              ): () {},
            },
          );
        }
        setState(() {
          _loading = false;
        });
      } catch (error) {
        print('An error occured: \n$error');
        showPopupDialog(
          context,
          'An error occured',
          'Try to check your internet connection, and try again',
          {
            Text(
              "Ok",
            ): () {},
          },
        );
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode newFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(newFocus);
  }
}
