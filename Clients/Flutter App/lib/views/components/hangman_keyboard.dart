import 'package:flutter/material.dart';
import 'package:hangman/animations/fade_in__animation.dart';

class HangmanKeyboard extends StatefulWidget {
  final onSingleKeyPressed;
  HangmanKeyboard({this.onSingleKeyPressed});

  @override
  _HangmanKeyboardState createState() => _HangmanKeyboardState();
}

class _HangmanKeyboardState extends State<HangmanKeyboard> {
  var buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = Color(0xFFe9e1cc);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: generateLettersForRow(1)),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: generateLettersForRow(2)),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: generateLettersForRow(3)),
        ]));
  }

  List<Widget> generateLettersForRow(rowNumber) {
    List<String> alphabet = [
      'q',
      'w',
      'e',
      'r',
      't',
      'y',
      'u',
      'i',
      'o',
      'p',
      'å',
      'a',
      's',
      'd',
      'f',
      'g',
      'h',
      'j',
      'k',
      'l',
      'æ',
      'ø',
      null,
      null,
      'z',
      'x',
      'c',
      'v',
      'b',
      'n',
      'm',
      null,
      null
    ];
    List<Color> colors = List();
    for (var i = 0; i <= 32; i++) {
      colors.add(Color(0xFFe9e1cc));
    }

    List<Widget> rowElements = [];
    if (rowNumber == 1) {
      for (int counter = 0; counter <= 10; counter++) {
        rowElements.add(FadeInRTLAnimation(
          delay: 0.2 * (counter + 1),
          child: GestureDetector(
            onTap: () {
              _keyAction(alphabet, counter, colors);
            },
            child: _keyGenerator(alphabet[counter], counter, colors),
          ),
        ));
      }
    } else if (rowNumber == 2) {
      for (int counter = 11; counter <= 21; counter++) {
        rowElements.add(FadeInRTLAnimation(
          delay: 0.2 * counter,
          child: GestureDetector(
            onTap: () {
              _keyAction(alphabet, counter, colors);
            },
            child: _keyGenerator(alphabet[counter], counter, colors),
          ),
        ));
      }
    } else {
      for (int counter = 22; counter <= 32; counter++) {
        rowElements.add(FadeInRTLAnimation(
          delay: 0.2 * counter,
          child: GestureDetector(
            onTap: () {
              _keyAction(alphabet, counter, colors);
            },
            child: _keyGenerator(alphabet[counter], counter, colors),
          ),
        ));
      }
    }
    return rowElements;
  }

  void _keyAction(alphabet, counter, colors) {
    if (alphabet[counter] != null) {
      widget.onSingleKeyPressed(alphabet[counter]);

      setState(() {
        colors[counter] = Color(0xFF707070);
      });
    }
  }

  Container _keyGenerator(letter, counter, colors) {
    if (letter == null) {
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.transparent,
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(vertical: 15.0),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: colors[counter],
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(letter.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      );
    }
  }
}
