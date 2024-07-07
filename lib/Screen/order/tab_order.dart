import 'package:admin/Model/order_model.dart';
import 'package:admin/Screen/order/detail_order.dart';
import 'package:admin/Screen/order/item_order.dart';
import 'package:admin/Service/order_service.dart';
import 'package:flutter/material.dart';

class AntrianList extends StatefulWidget {
  const AntrianList({super.key});

  @override
  _AntrianListState createState() => _AntrianListState();
}

class _AntrianListState extends State<AntrianList> {
  late Future<List<OrderModel>> _futureOrdes;

  @override
  void initState() {
    super.initState();
    _futureOrdes = OrderService().getOrdersByStatus('proses');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: _futureOrdes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Terjadi kendala, mohon tunggu sebentar lagi !');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada manu yang tersedia.'));
        } else {
          final orderItems = snapshot.data!;

          return ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return OrderListItem(
                order: item,
                isQueue: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(
                        order: item,
                        isQueue: true,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class RiwayatList extends StatefulWidget {
  const RiwayatList({super.key});

  @override
  _RiwayatListState createState() => _RiwayatListState();
}

class _RiwayatListState extends State<RiwayatList> {
  late Future<List<OrderModel>> _futureOrdes;

  @override
  void initState() {
    super.initState();
    _futureOrdes = OrderService().getOrdersByStatus('selesai');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: _futureOrdes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Terjadi kendala, mohon tunggu sebentar lagi !');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada manu yang tersedia.'));
        } else {
          final orderItems = snapshot.data!;

          return ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return OrderListItem(
                order: item,
                isQueue: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(
                        order: item,
                        isQueue: false,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
