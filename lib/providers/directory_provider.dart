import 'package:citizen/api/api.dart';
import 'package:citizen/api/api_service.dart';
import 'package:citizen/models/directory_model.dart';
import 'package:flutter/foundation.dart';

class DirectoryProvider with ChangeNotifier {
  bool _isLoading = false;
  List<DirectoryModel> _myDirectories = [];

  List<DirectoryModel> get myDirectories => _myDirectories;

  set myDirectories(List<DirectoryModel> value) {
    _myDirectories = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  getDirectories() async {
    List<DirectoryModel> list = [];
    isLoading = true;
    final response = await ApiService().getRequest(Apis.directory);
    if (response != null) {
      for (var i = 0; i < response.length; i++) {
        list.add(DirectoryModel.fromJson(response[i]));
      }
      myDirectories = list;

      //debugPrint('dl: ${myDirectories.length}');
    }

    isLoading = false;
  }
}
