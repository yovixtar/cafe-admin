import 'dart:convert';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;
import '../Model/food_model.dart';

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
}
