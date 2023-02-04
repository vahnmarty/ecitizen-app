import 'package:citizen/api/api_service.dart';
import 'package:citizen/models/hotline_categories_model.dart';
import 'package:citizen/models/hotlines_model.dart';
import 'package:flutter/cupertino.dart';

import '../api/api.dart';
import '../constants/constancts.dart';

class HotlinesProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _categoriesLoading = false;

  bool get categoriesLoading => _categoriesLoading;

  set categoriesLoading(bool value) {
    _categoriesLoading = value;
    notifyListeners();
  }

  List<HotlinesModel> _myHotlines = [];
  List<HotlineCategoryModel> _hotlineCategories =[];

  List<HotlineCategoryModel> get hotlineCategories => _hotlineCategories;

  set hotlineCategories(List<HotlineCategoryModel> value) {
    value.insert(0, HotlineCategoryModel(id: '-1', name: 'All'));
    _hotlineCategories=value;
    notifyListeners();
  }

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
      saveEmergencyHotlines(response);
    }
    isLoading = false;
  }

  getHotlineCategories()async{
    categoriesLoading = true;
    List<HotlineCategoryModel> list = [];
    final response = await ApiService().getRequest(Apis.hotlinesCategories);
    if (response != null) {
      for (var i = 0; i < response.length; i++) {
        list.add(HotlineCategoryModel.fromJson(response[i]));
      }
      hotlineCategories = list;
    }
    categoriesLoading = false;
  }
}
