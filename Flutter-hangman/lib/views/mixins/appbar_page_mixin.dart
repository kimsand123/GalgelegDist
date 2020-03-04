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
  double contentHeight;

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
    contentHeight = screenHeight() - 24;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: screenWidth(),
                constraints: BoxConstraints(minHeight: screenHeight() - 24),
                child: body(),
              ),
            ),
          ),
          loadingOverlay(),
        ],
      ),
    );
  }

  Widget loadingOverlay() => Container();

  Widget body();

  Widget action() => Container();
}
