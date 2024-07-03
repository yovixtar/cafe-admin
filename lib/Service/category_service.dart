import 'dart:convert';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;
import '../Model/category_model.dart';

class CategoryService {
  final _baseUrl = Config.baseUrl;

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/kategori'));
    if (response.statusCode == 200) {
      // Iterable body = json.decode(response.body);
      // List<FoodModel> foods =
      //     body.map((item) => FoodModel.fromJson(item)).toList();
      // return foods;
      final List body = json.decode(response.body);
      return body.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load makanan');
    }
  }
}
