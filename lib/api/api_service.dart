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

  Future<dynamic?> multipartPostRequest(String url, Map data, token) async {
    try {
      Uri uri = Uri.parse('${Apis.BASE_URL}$url');
      var request = http.MultipartRequest("POST", uri);
      debugPrint('url: $uri');
      request.fields['type'] = data['type'];
      request.fields['description'] = data['description'];
      request.fields['latitude'] = data['latitude'];
      request.fields['longitude'] = data['longitude'];
      request.fields['address'] = data['address'];

      request.headers.addAll(
          {"Authorization": "Bearer " + token, "Accept": "application/json"});

      List<String?> imgPaths = data['image'];
      dynamic result=null;
      for (var path in imgPaths) {
        request.files.add(await MultipartFile.fromPath('image', path!));

        http.Response response =
            await http.Response.fromStream(await request.send());

        //print('myResponse ' + response.body.toString());
        final hashMap = json.decode(response.body);
        debugPrint('hashmap: $hashCode');
        if (hashMap != '' && hashCode != null) {
          result= hashMap;
        }

      }
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    } finally {}
  }
}
