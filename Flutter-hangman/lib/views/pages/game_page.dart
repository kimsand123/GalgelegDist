import 'package:flutter/material.dart';
import 'package:hangman/views/base_pages/base_page.dart';
import 'package:hangman/views/components/hangman_keyboard.dart';
import 'package:hangman/views/mixins/game_page__mixin.dart';

class GamePage extends BasePage {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends BasePageState<GamePage> with GamePageMixin {

  @override
  Widget title() => Text('');

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
  Widget body() {
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text('Synlige ord', style: appTheme().textTheme.display3.copyWith(fontWeight: FontWeight.w700)),
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight() * 0.1),
              width: screenWidth() - 40,
              height: screenHeight() * 0.2,
              color: appTheme().colorScheme.primary,
            ),
          ])
      ),
    );
  }
}