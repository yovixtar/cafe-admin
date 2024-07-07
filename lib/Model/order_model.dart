class OrderItem {
  final String nama;
  final int harga;
  int quantity;

  OrderItem({required this.nama, required this.harga, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        nama: json['nama'] as String? ?? '',
        harga: json['harga'] as int? ?? 0,
        quantity: json['quantity'] as int? ?? 0);
  }
}

class OrderModel {
  final String? idOrder;
  final String namaPemesan;
  final String noMeja;
  final int? totalHarga;
  List<OrderItem> items;

  OrderModel({
    this.idOrder,
    required this.namaPemesan,
    required this.noMeja,
    this.totalHarga,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': idOrder,
      'namaPemesan': namaPemesan,
      'noMeja': noMeja,
      'totalHarga': totalHarga,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'];

    List<OrderItem> items =
        itemsJson.map((itemJson) => OrderItem.fromJson(itemJson)).toList();
    return OrderModel(
        idOrder: json['_id'] as String? ?? '',
        namaPemesan: json['namaPemesan'] as String? ?? '',
        noMeja: json['noMeja'] as String? ?? '',
        totalHarga: json['totalHarga'] as int? ?? 0,
        items: items);
  }
}
