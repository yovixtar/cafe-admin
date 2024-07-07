import 'dart:convert';
import 'dart:io';

import 'package:admin/Model/food_model.dart';
import 'package:admin/Service/session.dart';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;

class FoodService {
  final _baseUrl = Config.baseUrl;

  Future<List<FoodModel>> getFoods() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/makanan'));
    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => FoodModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load makanan');
    }
  }

  Future<List<FoodModel>> getByCategory(String id) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/api/makanan/kategori/$id'));
    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => FoodModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load makanan');
    }
  }

  Future<FoodModel> getById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/makanan/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      return FoodModel.fromJson(body);
    } else {
      throw Exception('Failed to load makanan');
    }
  }

  Future<Map<String, dynamic>> addMenu({
    required String nama,
    required int harga,
    required File gambar,
    required String deskripsi,
    required int jumlah,
    required List<String> categoryId,
  }) async {
    var token = await SessionManager.getReqToken();
    var urlUploadGambar = Uri.parse("$_baseUrl/uploadGambar");

    var requestUploadGambar = http.MultipartRequest('POST', urlUploadGambar)
      ..files.add(await http.MultipartFile.fromPath('gambar', gambar.path));

    var responseUploadGambar = await requestUploadGambar.send();

    if (responseUploadGambar.statusCode == 200) {
      var responseBody = await http.Response.fromStream(responseUploadGambar);
      var imagePath = jsonDecode(responseBody.body)['imagePath'];

      var urlAddMenu = Uri.parse("$_baseUrl/api/makanan");

      var body = jsonEncode({
        'nama': nama,
        'harga': harga,
        'gambar': imagePath,
        'deskripsi': deskripsi,
        'jumlah': jumlah,
        'categoryId': categoryId,
      });

      var responseAddMenu = await http.post(urlAddMenu,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token!
          },
          body: body);

      if (responseAddMenu.statusCode == 201) {
        return {'success': "Berhasil menambahkan menu"};
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> updateMenu({
    required String idMenu,
    required String nama,
    required int harga,
    File? gambar,
    required String deskripsi,
    required int jumlah,
    required List<String> categoryId,
  }) async {
    var token = await SessionManager.getReqToken();
    var urlUpdateMenu = Uri.parse("$_baseUrl/api/makanan/edit/$idMenu");
    if (gambar != null) {
      var urlUploadGambar = Uri.parse("$_baseUrl/uploadGambar");

      var requestUploadGambar = http.MultipartRequest('POST', urlUploadGambar)
        ..files.add(await http.MultipartFile.fromPath('gambar', gambar.path));

      var responseUploadGambar = await requestUploadGambar.send();

      if (responseUploadGambar.statusCode == 200) {
        var responseBody = await http.Response.fromStream(responseUploadGambar);
        var imagePath = jsonDecode(responseBody.body)['imagePath'];

        var body = jsonEncode({
          'nama': nama,
          'harga': harga,
          'gambar': imagePath,
          'deskripsi': deskripsi,
          'jumlah': jumlah,
          'categoryId': categoryId,
        });

        var responseUpdateMenu = await http.put(urlUpdateMenu,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': token!
            },
            body: body);

        if (responseUpdateMenu.statusCode == 200) {
          return {'success': "Berhasil menambahkan menu"};
        } else {
          return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
        }
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    } else {
      var body = jsonEncode({
        'nama': nama,
        'harga': harga,
        'deskripsi': deskripsi,
        'jumlah': jumlah,
        'categoryId': categoryId,
      });

      var responseUpdateMenu = await http.put(urlUpdateMenu,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token!
          },
          body: body);

      if (responseUpdateMenu.statusCode == 200) {
        return {'success': "Berhasil menambahkan menu"};
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    }
  }

  Future<Map<String, dynamic>> deleteMenu(String id) async {
    var token = await SessionManager.getReqToken();
    var url = Uri.parse('$_baseUrl/api/makanan/hapus/$id');

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': token!
      });

      if (response.statusCode == 200) {
        return {'success': json.decode(response.body)['message']};
      } else {
        return {'error': 'Terjadi kendala, mohon tunggu sebentar lagi !'};
      }
    } catch (e) {
      return {'error': 'Terjadi kendala, mohon tunggu sebentar lagi !'};
    }
  }
}
