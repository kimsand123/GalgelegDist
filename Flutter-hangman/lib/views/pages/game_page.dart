import 'package:flutter/material.dart';
import 'package:hangman/model/game.dart';
import 'package:hangman/model/user.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:hangman/remote/http_remote.dart';
import 'package:hangman/views/base_pages/base_page.dart';
import 'package:hangman/views/components/hangman_keyboard.dart';
import 'package:hangman/views/components/popupComponent.dart';
import 'package:hangman/views/mixins/game_page__mixin.dart';
import 'package:provider/provider.dart';

class GamePage extends BasePage {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends BasePageState<GamePage> with GamePageMixin {
  bool _loading;
  HttpRemote remote;
  Game game;

  @override
  void initState() {
    super.initState();
    _loading = false;
    game = Game(visibleWord: 'Loading word');
    remote = HttpRemote();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget title() => Text('');
  User user;

  @override
  Widget loadingOverlay() {
    return Visibility(
      child: Container(
          height: screenHeight(),
          width: screenWidth(),
          color: Colors.white54,
          alignment: Alignment.center,
          child: CircularProgressIndicator()),
      visible: _loading,
    );
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
  Widget body() {
    return SafeArea(
      child: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Text('Hangman',
                style: appTheme()
                    .textTheme
                    .display3
                    .copyWith(fontWeight: FontWeight.w700)),
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight() * 0.1),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: screenWidth() - 40,
              height: screenHeight() * 0.2,
              color: appTheme().colorScheme.primary,
              child: FutureBuilder(
                future: remote.getGameData(user),
                builder: (BuildContext context, AsyncSnapshot<Game> snapshot) {
                  if (snapshot.hasData && snapshot != null) {
                    game = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _generateListOfText(),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _generateListOfText(),
                    );
                  }
                },
              ),
            ),
          ])),
    );
  }

  List<Widget> _generateListOfText() {
    return [
      Text('${game.visibleWord}',
          style: appTheme()
              .textTheme
              .display3
              .copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
      Divider(
        color: Colors.white,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Used letters:',
            style: appTheme().textTheme.body1.copyWith(color: Colors.white),
          ),
          Text(
            '${game.usedLetters}',
            style: appTheme().textTheme.body1.copyWith(color: Colors.white),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Number of tries:',
            style: appTheme().textTheme.body1.copyWith(color: Colors.white),
          ),
          Text(
            '${game.numberOfWrongLetters}',
            style: appTheme().textTheme.body1.copyWith(color: Colors.white),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Last letter was:',
            style: appTheme().textTheme.body1.copyWith(color: Colors.white),
          ),
          Text(
            '${game.wasLastLetterCorrect}',
            style: appTheme().textTheme.body1.copyWith(color: Colors.white),
          ),
        ],
      ),
    ];
  }

  Future<void> guess(letter) async {
    setState(() {
      _loading = true;
    });

    print("** Guessing letter: $letter");
    await remote.guessLetter(user, letter);

    if (game.isGameLost != null && game.isGameWon != null) {
      if (game.isGameWon) {
        showPopupDialog(
          context,
          'The game is over',
          'The word was: ${game.word} \nYou won!',
          {
            Text(
              "Start over",
            ): () {
              remote.resetGame(user);
            },
            Text(
              "End game",
            ): () {
              remote.resetGame(user);
              Navigator.pop(context);
            },
          },
        );
      } else if (game.isGameLost) {
        showPopupDialog(
          context,
          'The game is over',
          'The word was: ${game.word} \nYou lost!',
          {
            Text(
              "Start over",
            ): () {
              remote.resetGame(user);
            },
            Text(
              "End game",
            ): () {
              remote.resetGame(user);
              Navigator.pop(context);
            },
          },
        );
      }
    }

    setState(() {
      _loading = false;
    });
  }
}
