import 'package:citizen/api/api_service.dart';
import 'package:citizen/models/hotlines_model.dart';
import 'package:flutter/cupertino.dart';

import '../api/api.dart';

class HotlinesProvider with ChangeNotifier {
  bool _isLoading = false;
  List<HotlinesModel> _myHotlines = [];

  List<HotlinesModel> get myHotlines => _myHotlines;

  set myHotlines(List<HotlinesModel> value) {
    _myHotlines = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  getHotlines() async {
    isLoading = true;
    List<HotlinesModel> list = [];
    final response = await ApiService().getRequest(Apis.hotlines);
    if (response != null) {
      for (var i = 0; i < response.length; i++) {
        list.add(HotlinesModel.fromJson(response[i]));

      }

      myHotlines = list;
    }
    isLoading = false;
  }
}
