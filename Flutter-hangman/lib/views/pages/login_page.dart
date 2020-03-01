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
    _userNameController.text = "s160198";
    _passwordController.text = "densikkrestekode";
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
  Widget title() {
    return null;
  }

  /*
  We create a model for our provider to pass on to the consumers.
  */
  @override
  Widget body() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Visibility(
          child: CircularProgressIndicator(),
          visible: _loading,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(),
              Text('Login', style: appTheme().textTheme.display3),
              Text('Please login with your credentials below',
                  style: appTheme().textTheme.caption),
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
                            InputDecoration.collapsed(hintText: 'Username'),
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
                            InputDecoration.collapsed(hintText: 'Password'),
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
              Button(
                  title: 'Login', onPressed: _loading ? null : _validateInputs),
            ],
          ),
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

        if (response.statusCode == 200) {
          user.token = response.body;
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.pushNamedAndRemoveUntil(context, homePageRoute,
              ModalRoute.withName(Navigator.defaultRouteName));
        } else {
          print(
              'An error occured: \n${response.statusCode} - ${response.reasonPhrase}');
          showPopupDialog(
            context,
            'An error occured',
            '${response.statusCode} - ${response.reasonPhrase}\n${response.body}',
            {
              Text(
                "Ok",
              ): null,
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
          '$error',
          {
            Text(
              "Ok",
            ): null,
          },
        );
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
