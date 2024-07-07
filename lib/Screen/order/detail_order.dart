import 'package:admin/Model/order_model.dart';
import 'package:admin/Screen/order/nota_order.dart';
import 'package:admin/Service/order_service.dart';
import 'package:admin/color.dart';
import 'package:admin/snackbar_utils.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(
      {super.key, required this.order, required this.isQueue});

  final OrderModel order;
  final bool isQueue;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late bool isLoading = false;

  handleSelesai() async {
    setState(() {
      isLoading = true;
    });
    final result = await OrderService()
        .updateStatusOrder(idOrder: widget.order.idOrder, status: 'selesai');
    if (result.containsKey('success')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NotaOrderPage(
            order: widget.order,
          ),
        ),
      );
    } else {
      SnackbarUtils.showErrorSnackbar(
          context, 'Terjadi kendala Mohon ulangi beberapa saat lagi !');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${widget.order.idOrder}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Nama : ${widget.order.namaPemesan}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Meja ${widget.order.noMeja}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Nama Menu',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Jumlah',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Harga',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                ...widget.order.items.map(
                  (item) {
                    return TableRow(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.nama)),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.quantity.toString())),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Rp. ${item.harga.toString().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]}.',
                                  )}'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                      'Rp. ${widget.order.totalHarga.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]}.',
                          )}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (widget.isQueue) {
                    (isLoading) ? null : handleSelesai();
                  } else {
                    (isLoading)
                        ? null
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotaOrderPage(
                                order: widget.order,
                              ),
                            ),
                          );
                  }
                },
                icon: (isLoading)
                    ? SizedBox()
                    : Icon(
                        widget.isQueue ? Icons.check_circle : Icons.print,
                        color: Colors.white,
                      ),
                label: (isLoading)
                    ? CircularProgressIndicator()
                    : Text(
                        widget.isQueue ? 'Selesaikan Pesanan' : 'Cetak Struk',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
