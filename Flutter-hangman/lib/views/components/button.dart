import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final onPressed;
  Button({this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).buttonColor,
          width: 2
        ),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: MaterialButton(
        child: Text('Login', style: Theme.of(context).textTheme.button.copyWith(color: Theme.of(context).buttonColor)),
        onPressed: this.onPressed,
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        highlightColor: Color(0x05000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );
  }
}