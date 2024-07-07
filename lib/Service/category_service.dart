import 'dart:convert';

import 'package:admin/Model/category_model.dart';
import 'package:admin/Service/session.dart';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CategoryService {
  final _baseUrl = Config.baseUrl;

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/kategori'));
    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load makanan');
    }
  }

  Future<Map<String, dynamic>> addCategory({
    required String nama,
    required String gambar,
  }) async {
    var token = await SessionManager.getReqToken();

    var urlUploadGambar = Uri.parse("$_baseUrl/uploadGambar");

    var mimeType = lookupMimeType(gambar);
    var request = http.MultipartRequest('POST', urlUploadGambar);
    request.files.add(await http.MultipartFile.fromPath(
      'gambar',
      gambar,
      contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
    ));

    var responseUploadGambar = await request.send();

    if (responseUploadGambar.statusCode == 200) {
      var responseBody = await http.Response.fromStream(responseUploadGambar);
      var jsonResponse = jsonDecode(responseBody.body);
      var imagePath = jsonResponse['imagePath'];

      var urlAddCategory = Uri.parse("$_baseUrl/api/kategori");
      var body = {
        'nama': nama,
        'gambar': imagePath,
      };

      var responseAddCategory = await http.post(
        urlAddCategory,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
        body: jsonEncode(body),
      );

      if (responseAddCategory.statusCode == 201) {
        return {'success': "Berhasil menambahkan kategori"};
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> updateCategory({
    required String id,
    required String nama,
    String? gambar,
  }) async {
    var token = await SessionManager.getReqToken();
    if (gambar != null && gambar.isNotEmpty) {
      var urlUploadGambar = Uri.parse("$_baseUrl/uploadGambar");

      var mimeType = lookupMimeType(gambar);
      var request = http.MultipartRequest('POST', urlUploadGambar);
      request.files.add(await http.MultipartFile.fromPath(
        'gambar',
        gambar,
        contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
      ));

      var responseUploadGambar = await request.send();

      if (responseUploadGambar.statusCode == 200) {
        var responseBody = await http.Response.fromStream(responseUploadGambar);
        var jsonResponse = jsonDecode(responseBody.body);
        var imagePath = jsonResponse['imagePath'];

        var urlUpdateCategory = Uri.parse("$_baseUrl/api/kategori/edit/$id");
        var body = {
          'nama': nama,
          'gambar': imagePath,
        };

        var responseUpdateCategory = await http.put(
          urlUpdateCategory,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token!
          },
          body: jsonEncode(body),
        );

        if (responseUpdateCategory.statusCode == 200) {
          return {'success': "Berhasil memperbarui kategori"};
        } else {
          return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
        }
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    } else {
      var urlUpdateCategory = Uri.parse("$_baseUrl/api/kategori/edit/$id");
      var body = {
        'nama': nama,
      };

      var responseUpdateCategory = await http.put(
        urlUpdateCategory,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
        body: jsonEncode(body),
      );

      if (responseUpdateCategory.statusCode == 200) {
        return {'success': "Berhasil memperbarui kategori"};
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    }
  }

  Future<Map<String, dynamic>> deleteCategory(String id) async {
    var token = await SessionManager.getReqToken();
    var url = Uri.parse('$_baseUrl/api/kategori/hapus/$id');

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
