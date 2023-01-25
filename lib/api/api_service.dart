import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../constants/constancts.dart';
import 'api.dart';

class ApiService {
  Future<dynamic> postRequest(String url, Map data, {String token = ''}) async {
    //debugPrint('url${Apis.BASE_URL}$url');

    final Client client = http.Client();
    try {
      final Response response = await client
          .post(Uri.parse('${Apis.BASE_URL}$url'), body: data, headers: {
        "Authorization": "Bearer " + token,
        "Accept": "application/json"
      });

      final hashMap = jsonDecode(response.body);
      return hashMap;
    } catch (e) {
      print(e.toString() + '=>$url');
      return null;
    } finally {
      client.close();
    }
  }

  Future<dynamic> getRequest(String url, {String token = ''}) async {
    final Client client = http.Client();
    try {
      final http.Response response = await client
          .get(Uri.parse('${Apis.BASE_URL}$url'), headers: {
        "Authorization": "Bearer " + token,
        "Accept": "application/json"
      });
      final hashMap = json.decode(response.body);
      if (hashMap != '' || hashMap != null) {
        return hashMap;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      client.close();
    }
  }
}
