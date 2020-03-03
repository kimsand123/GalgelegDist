import 'package:flutter/material.dart';
import 'package:hangman/model/user.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:hangman/remote/http_remote.dart';
import 'package:hangman/views/base_pages/base_page.dart';
import 'package:hangman/views/components/hangman_keyboard.dart';
import 'package:hangman/views/mixins/game_page__mixin.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class GamePage extends BasePage {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends BasePageState<GamePage> with GamePageMixin {
  @override
  Widget title() => Text('');
  User user;

  void guess(letter) {
    print(letter);
  }

  @override
  Widget keyboard() {
    return HangmanKeyboard(
      onSingleKeyPressed: (letter) {
        guess(letter);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget body() {
    return SafeArea(
      child: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            FutureBuilder(
              future: HttpRemote().visibleWord(user),
              builder:
                  (BuildContext context, AsyncSnapshot<Response> snapshot) {
                return Text('${snapshot.data.body}',
                    style: appTheme()
                        .textTheme
                        .display3
                        .copyWith(fontWeight: FontWeight.w700));
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight() * 0.1),
              width: screenWidth() - 40,
              height: screenHeight() * 0.2,
              color: appTheme().colorScheme.primary,
            ),
          ])),
    );
  }
}
