import 'package:flutter/material.dart';

import '../base_pages/base_page.dart';

/*
This mixin provides the build method of every screen implementing it
The mixin also provides device height and width as well as the apptheme.

All is available when implementing the mixin.
*/

mixin AppbarPage<Page extends BasePage> on BasePageState<Page> {
  double screenWidth() => MediaQuery.of(context).size.width;
  double screenHeight() => MediaQuery.of(context).size.height;
  ThemeData appTheme() => Theme.of(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      actions: <Widget>[action()],
      centerTitle: true,
      title: title(),
    );

    double _minHeightWithAppBar =
        screenHeight() - appbar.preferredSize.height - kToolbarHeight;
    double _minHeightWithOutAppBar = screenHeight();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: title() == null ? null : appbar,
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth(),
            constraints: BoxConstraints(
                minHeight: title() == null
                    ? _minHeightWithOutAppBar
                    : _minHeightWithAppBar),
            child: body(),
          ),
        ),
      ),
    );
  }

  Widget body();

  Widget action() => Container();
}
