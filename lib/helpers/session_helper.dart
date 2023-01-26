import 'dart:convert';

import 'package:citizen/constants/constancts.dart';
import 'package:citizen/providers/auth_provider.dart';
import 'package:citizen/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

const Token = 'token';
const User = 'user';

setUser(UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(User, jsonEncode(user.toJson()));
}

getUser() async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> json = await jsonDecode(prefs.getString(User)!);
  UserModel user = UserModel.fromJson(json);
  return user;
}

setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(Token, jsonEncode(token));
}

getToken() async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final res = await jsonDecode(prefs.getString(Token)!);
    if (res != null) {
      return res;
    }
    return false;
  } catch (e) {
    debugPrint('error :'+e.toString());
    return false;
  }
}

logout() async {
  final prefs = await SharedPreferences.getInstance();
  try {
    await prefs.remove(Token);
    await prefs.remove(User);
  } catch (e) {
    debugPrint('excepton $e');
  }
}
