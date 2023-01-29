import 'package:citizen/api/api.dart';
import 'package:citizen/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  bool _isGettingNews = false;
  List<News> _newsList = [];

  List<News> get newsList => _newsList;

  set newsList(List<News> value) {
    _newsList = value;
    notifyListeners();
  }

  bool get isGettingNews => _isGettingNews;

  set isGettingNews(bool value) {
    _isGettingNews = value;
    notifyListeners();
  }

  gettingNews(String link) async {
    isGettingNews = true;
    List<News> list = [];
    dynamic response = await ApiService().getRequest(link);
    //debugPrint('news: $response');
    if (response != null && response != '') {
      for (var i = 0; i < response.length; i++) {
        list.add(News.fromJson(response[i]));
      }
      newsList = list;
    }
    isGettingNews = false;
  }
}
