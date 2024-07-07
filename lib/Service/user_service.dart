import 'dart:convert';

import 'package:admin/Service/session.dart';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;

class UserService {
  String baseUrl = Config.baseUrl;

  Future<Map<String, dynamic>> login({
    String? username,
    String? password,
  }) async {
    var url = Uri.parse("$baseUrl/api/auth/login");
    var headers = {"Content-Type": "application/json"};

    var body = jsonEncode({
      'username': username!,
      'password': password!,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var token = responseData['token'];
      await SessionManager.saveToken(token);
      return {'success': "Berhasil login"};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> signup({
    String? username,
    String? noHp,
    String? password,
  }) async {
    var url = Uri.parse("$baseUrl/api/auth/registrasi");
    var headers = {"Content-Type": "application/json"};

    var body = jsonEncode({
      'username': username,
      'password': password,
      'noHp': noHp,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return {'success': "${responseData['msg']}"};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    var token = await SessionManager.getReqToken();
    var url = Uri.parse("$baseUrl/api/user");
    var headers = {"Content-Type": "application/json", 'Authorization': token!};

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }
}
