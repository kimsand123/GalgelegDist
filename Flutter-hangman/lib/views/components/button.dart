import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final onPressed;
  Button({this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
      child: MaterialButton(
        child: Text('Login', style: Theme.of(context).textTheme.button),
        onPressed: this.onPressed,
        color: Theme.of(context).buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
    );
  }
}