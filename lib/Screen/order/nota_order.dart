import 'package:admin/Model/order_model.dart';
import 'package:admin/bottom_bar.dart';
import 'package:admin/color.dart';
import 'package:admin/snackbar_utils.dart';
import 'package:flutter/material.dart';

class NotaOrderPage extends StatefulWidget {
  const NotaOrderPage({super.key, required this.order});

  final OrderModel order;

  @override
  State<NotaOrderPage> createState() => _NotaOrderPageState();
}

class _NotaOrderPageState extends State<NotaOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota Pesanan'),
      ),
      body: Center(
        child: Card(
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.2),
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/Logo.png',
                  height: 120,
                ),
                SizedBox(height: 24),
                Text('Kabupaten Pekalongan, Jawa Tengah',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text('Kontak kami: 08123456789',
                    style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 16,
                ),
                Divider(),
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Menu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Jumlah'.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Harga',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...widget.order.items.map((item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.nama,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.quantity.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Rp. ${item.harga.toString().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]}.',
                                  )}',
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          'Rp. ${widget.order.totalHarga.toString().replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                              )}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    SnackbarUtils.showSuccessSnackbar(
                        context, "Terimakasih telah berbelanja !");
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BottomBar(
                          toPage: 3,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Print',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
