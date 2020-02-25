import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final onPressed;
  Button({this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text('Button component', style: Theme.of(context).textTheme.button),
      onPressed: this.onPressed,
      color: Theme.of(context).buttonColor,
    );
  }
}