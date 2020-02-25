import 'package:flutter/widgets.dart';
import 'package:hangman/model/user.dart';


class UserProvider extends ChangeNotifier {
  User _user = User();

  User get user => _user;

  void setUser(User user) {
    _user = user;

    notifyListeners();
  }
}