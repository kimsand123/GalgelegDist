import 'package:flutter/material.dart';
import 'package:hangman/animations/fade_in__animation.dart';

class HangmanKeyboard extends StatefulWidget {

  var onSingleKeyPressed;
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
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)
        )
      ),
      height: MediaQuery.of(context).size.height * 0.3,
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
    List<String> alphabet = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o',
                             'p', 'å', 'a', 's', 'd', 'f', 'g', 'h', 'j',
                             'k', 'l', 'æ', 'ø', 'z', 'x', 'c', 'v',
                             'b', 'n', 'm'];
    List<Color> colors = List();
    for(var i = 0; i <= 28; i++) {
      colors.add(Color(0xFFe9e1cc));
    }

    List<Widget> rowElements = [];
    if (rowNumber == 1) {

      for(int counter = 0; counter <= 10; counter++) {
        rowElements.add(FadeInRTLAnimation(
          delay: 0.2 * (counter+1),
          child: GestureDetector(
            onTap: () {
              widget.onSingleKeyPressed(alphabet[counter]);
              setState(() {
                colors[counter] = Color(0xFF707070);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width*0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: colors[counter],
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(alphabet[counter].toUpperCase(),
                style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).colorScheme.primary)),
            )),
        ));
      }

    } else if (rowNumber == 2) {
      
      for(int counter = 11; counter <= 21; counter++) {
        rowElements.add(FadeInRTLAnimation(
          delay: 0.2 * counter,
          child: GestureDetector(
            onTap: () {
              print(alphabet[counter]);
              setState(() {
                colors[counter] = Color(0xFF707070);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width*0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: colors[counter],
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(alphabet[counter].toUpperCase(),
                style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).colorScheme.primary)),
            )),
        ));
      }

    } else {
      
      for(int counter = 22; counter <= 28; counter++) {
        rowElements.add(FadeInRTLAnimation(
          delay: 0.2 * counter,
          child: GestureDetector(
            onTap: () {
              print(alphabet[counter]);
              setState(() {
                colors[counter] = Color(0xFF707070);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width*0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: colors[counter],
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(alphabet[counter].toUpperCase(),
                style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).colorScheme.primary)),
            )),
        ));
      }

    }
    return rowElements;
  }
}
