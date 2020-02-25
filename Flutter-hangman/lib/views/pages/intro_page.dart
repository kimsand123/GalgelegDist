import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/any_model.dart';
import '../../providers/any_provider.dart';
import '../../routing/routing_paths.dart';
import '../base_pages/base_page.dart';
import '../components/button.dart';
import '../mixins/appbar_page_mixin.dart';

class IntroPage extends BasePage {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends BasePageState <IntroPage> with AppbarPage {
  AnyModel model = AnyModel();
  TextEditingController controller = TextEditingController();
  
  /*
  We create a model for our provider to pass on to the consumers.
  */
  @override
  Widget body() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: appTheme().colorScheme.primary
              )
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Write something'
              ),
            )
          ),
          Button(
            onPressed: () {
              model.modelParamOne = controller.text;
              Provider.of<AnyProvider>(context, listen: false).setModel(model);
              Navigator.pushNamed(context, homePageRoute);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget title() => Text('Intro', 
    textAlign: TextAlign.center, 
    style: appTheme()
            .textTheme
            .headline
            .copyWith(color: appTheme().colorScheme.onPrimary)
    );

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }  
}