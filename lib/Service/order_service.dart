import 'dart:convert';
import 'package:admin/Service/session.dart';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:admin/Model/order_model.dart';

class OrderService {
  static const String apiUrl = '${Config.baseUrl}/api/order';

  static Future<bool> submitOrder(OrderModel order) async {
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      var jsonBody = jsonEncode(order.toJson());
      var response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    var token = await SessionManager.getReqToken();
    print(token);
    final response = await http.get(Uri.parse("$apiUrl?status=$status"));
    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> updateStatusOrder({
    String? idOrder,
    String? status,
  }) async {
    var token = await SessionManager.getReqToken();
    var url = Uri.parse("$apiUrl/$idOrder");
    var headers = {"Content-Type": "application/json", 'Authorization': token!};

    var body = jsonEncode({
      'status': status,
    });

    var response = await http.put(url, headers: headers, body: body);
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var msg = responseData['msg'];
      return {'success': msg};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }
}
