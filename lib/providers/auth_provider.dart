import 'dart:convert';

import 'package:citizen/api/api.dart';
import 'package:citizen/api/api_service.dart';
import 'package:citizen/constants/constancts.dart';
import 'package:citizen/helpers/session_helper.dart';
import 'package:citizen/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  checkUserSession()async{
    final token = await getToken();
    if (token != '' || token != null) {
      //debugPrint('token found: $token');
      getUser(token);
    }
  }
  UserModel _user = UserModel();

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    setUser(value);
    _isLogin=true;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  getUser(String token) async {
    UserModel userModel = UserModel();
    final response = await ApiService().getRequest(Apis.user, token: token);
    if (response != null) {
      userModel = UserModel.fromJson(response);
      user = userModel;
    }
  }

  login(dynamic data) async {
    isLoading = true;
    bool result = false;
    final response = await ApiService().postRequest("${Apis.login}", data);
    if (response != null) {
      if (response['status'] == 0) {
        showToast(response['message']);
        result = false;
      } else if (response['status'] == 1) {
        var token = response['token'];
        setToken(token);
        user = UserModel.fromJson(response['response']);
        showToast(response['message']);
        result = true;
      } else {
        showToast('Unable to proceed your request');
        result = false;
      }
    } else {
      showToast('Unable to proceed your request');
      result = false;
    }
    isLoading = false;
    return result;
  }

  signup(dynamic data) async {
    isLoading = true;
    bool result = false;
    final response = await ApiService().postRequest("${Apis.signup}", data);
    //debugPrint('response $response');
    if (response != null) {
      try {
        if (response['status'] == 1) {
          showToast(response['message']);
          var token = response['token'];
          UserModel userModel = UserModel.fromJson(response['response']);
          user = userModel;
          await setToken(token);
          result = true;
          isLogin = true;
          getUser(token);
        } else {
          showToast(response['errors'][0]);
          result = false;
        }
      } catch (e) {
        debugPrint('error: $e');
        showToast('Unable to register you!');
        result = false;
      }
    } else {
      //unable to procces your request
      result = false;
    }
    isLoading = false;
    return result;
  }
}
