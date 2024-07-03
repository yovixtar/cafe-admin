import 'dart:convert';
import 'package:admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:admin/Model/order_model.dart';

class OrderService {
  static const String apiUrl = '${Config.baseUrl}/api/order';

  static Future<bool> submitOrder(OrderModel order) async {
    var headers = {
      'Content-Type': 'application/json',
      // Tambahkan header lain jika diperlukan seperti Authorization
    };

    try {
      var jsonBody = jsonEncode(order.toJson());
      var response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        // Sukses, response bisa di-handle di sini jika diperlukan
        return true;
      } else {
        // Gagal, handle error
        print('Gagal mengirim pesanan: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Exception saat koneksi atau request
      print('Error: $e');
      return false;
    }
  }
}
