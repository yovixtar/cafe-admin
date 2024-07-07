import 'package:admin/Screen/order/tab_order.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Antrian'),
            Tab(text: 'Riwayat Antrian'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AntrianList(),
          RiwayatList(),
        ],
      ),
    );
  }
}
