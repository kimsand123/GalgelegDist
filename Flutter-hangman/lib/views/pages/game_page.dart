import 'package:flutter/material.dart';
import 'package:hangman/model/game.dart';
import 'package:hangman/model/user.dart';
import 'package:hangman/providers/user_provider.dart';
import 'package:hangman/remote/http_remote.dart';
import 'package:hangman/routing/routing_paths.dart';
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
                future: _loadData(),
                builder: (BuildContext context, AsyncSnapshot<Game> snapshot) {
                  if (snapshot.hasData && snapshot != null) {
                    game = snapshot.data;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _generateListOfText(),
                    );
                  } else {
                    game.visibleWord = 'Loading';
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

  Future<Game> _loadData() async {
    Game game = await remote.getGameData(user).then((game) {
      _gameOverPopup(game);
      return game;
    });

    debugPrint("Guess the word: ${game.word}");
    return game;
  }

  List<Widget> _generateListOfText() {
    String usedLetters = '';

    if (game.usedLetters != null) {
      game.usedLetters.forEach((letter) {
        usedLetters += '$letter, ';
      });
    }

    return [
      Text(
        '${game.visibleWord}',
        style: appTheme()
            .textTheme
            .display3
            .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
      ),
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
          Container(
            width: screenWidth() / 3,
            child: Text(
              '$usedLetters',
              style: appTheme().textTheme.body1.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Number of wrong letters:',
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
    remote.guessLetter(user, letter).then((response) {
      if (response.statusCode != 200) {
        if (response.statusCode == 403) {
          showPopupDialog(
            context,
            'Your login has expired, please login again',
            '',
            {
              Text(
                "Go to login",
              ): () {
                Navigator.pushNamedAndRemoveUntil(context, homePageRoute,
                    ModalRoute.withName(Navigator.defaultRouteName));
              },
            },
          );
        } else {
          showPopupDialog(
            context,
            'An error occured',
            '',
            {
              Text(
                "Try again",
              ): () {
                remote.resetGame(user).then((response) {
                  setState(() {
                    game.visibleWord = 'Loading';
                    _loading = false;
                  });
                });
              },
              Text(
                "End game",
              ): () async {
                await remote.resetGame(user);
                Navigator.pop(context);
              },
            },
          );
        }
      }
    });

    setState(() {
      game.visibleWord = 'Loading';
      _loading = false;
    });
  }

  _gameOverPopup(Game game) {
    if (game.isGameLost != null && game.isGameWon != null) {
      if (game.isGameWon) {
        showPopupDialog(
          context,
          'The game is over',
          'The word was: ${game.word} \nYou won!',
          {
            Text(
              "Start over",
            ): () async {
              remote.resetGame(user).then((response) {
                setState(() {
                  game.visibleWord = 'Loading';
                  _loading = false;
                });
              });
            },
            Text(
              "End game",
            ): () async {
              await remote.resetGame(user);
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
            ): () async {
              remote.resetGame(user).then((response) {
                setState(() {
                  game.visibleWord = 'Loading';
                  _loading = false;
                });
              });
            },
            Text(
              "End game",
            ): () async {
              await remote.resetGame(user);
              Navigator.pop(context);
            },
          },
        );
      }
    }
  }
}
