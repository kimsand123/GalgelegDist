import 'package:flutter/widgets.dart';

/*
This is the stateful basepage of all pages in the app
*/

abstract class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);
}

abstract class BasePageState<Page extends BasePage>
    extends State<Page> {
  Widget title();
}