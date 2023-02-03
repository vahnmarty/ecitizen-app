import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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

  checkUserSession() async {
    final token = await getToken();
    if (token && token != '' && token != null) {
      debugPrint('token found: $token');
      getUser(token);
    }
  }

  UserModel _user = UserModel();

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    setUser(value);
    _isLogin = true;
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

  login(dynamic data, {bool showLoading = true}) async {
    if (showLoading) isLoading = true;
    bool result = false;
    final response = await ApiService().postRequest("${Apis.login}", data);
    if (response != null) {
      if (response['status'] == 0) {
        if (showLoading) showToast(response['message']);
        result = false;
      } else if (response['status'] == 1) {
        var token = response['token'];
        setToken(token);
        user = UserModel.fromJson(response['response']);
        showToast(response['message']);
        result = true;
      } else {
        if (showLoading) showToast('Unable to proceed your request');
        result = false;
      }
    } else {
      if (showLoading) showToast('Unable to proceed your request');
      result = false;
    }
    if (showLoading) isLoading = false;
    return result;
  }

  signup(dynamic data, {bool showLoading = true}) async {
    if (showLoading) isLoading = true;
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
          if (showLoading) showToast(response['errors'][0]);
          result = false;
        }
      } catch (e) {
        debugPrint('error: $e');
        if (showLoading) showToast('Unable to register you!');
        result = false;
      }
    } else {
      //unable to procces your request
      result = false;
    }
    if (showLoading) isLoading = false;
    return result;
  }

  loginWithFacebook() async {
    isLoading = true;
    bool result = false;
    try {
      final LoginResult fbLogin = await FacebookAuth.instance.login();
      if (fbLogin.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        if (userData != '' && userData != null) {
          var data = {
            "name": userData['name'],
            "email": userData['email'],
            "password": "12345678",
            "password_confirmation": "12345678"
          };
          final signupResult = await signup(data, showLoading: false);
          if (signupResult) {
            result = true;
          } else {
            final loginResult = await login(data, showLoading: false);
            if (loginResult) {
              result = true;
            } else {
              showToast('Unable to Login you!');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('error login=> $e');
      showToast('Unable to Login you!');
    }
    isLoading = false;
    return result;
  }
}
