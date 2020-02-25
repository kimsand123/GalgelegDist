import 'package:flutter/widgets.dart';

import '../model/any_model.dart';

class AnyProvider extends ChangeNotifier {
  AnyModel _model = AnyModel();

  AnyModel get model => _model;

  void setModel(AnyModel model) {
    _model = model;

    notifyListeners();
  }
}