import 'package:admin/Screen/menu/form_menu.dart';
import 'package:admin/Service/food_service.dart';
import 'package:admin/bottom_bar.dart';
import 'package:admin/config.dart';
import 'package:admin/snackbar_utils.dart';
import 'package:flutter/material.dart';

class MenuDetailPage extends StatefulWidget {
  final String idMenu;
  final String gambar;
  final String namaMenu;
  final int harga;
  final String kategori;
  final String idKategori;
  final String deskripsi;
  final String jumlah;

  const MenuDetailPage({
    Key? key,
    required this.idMenu,
    required this.gambar,
    required this.namaMenu,
    required this.harga,
    required this.kategori,
    required this.idKategori,
    required this.deskripsi,
    required this.jumlah,
  }) : super(key: key);

  @override
  _MenuDetailPageState createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Menu'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFECF0F4),
                shape: CircleBorder(),
                padding: EdgeInsets.all(8),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.gambar.isEmpty
                      ? AssetImage('images/img-icon.png') as ImageProvider
                      : NetworkImage("${Config.baseUrl}${widget.gambar}")
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.namaMenu.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Harga : Rp. ${widget.harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "Kategori : ",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.kategori,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Stok : ${widget.jumlah}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Deskripsi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.deskripsi,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009C3F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormMenuPage(
                                idMenu: widget.idMenu,
                                gambar: widget.gambar,
                                namaMenu: widget.namaMenu,
                                harga: widget.harga,
                                kategori: widget.kategori,
                                idKategori: widget.idKategori,
                                deskripsi: widget.deskripsi,
                                jumlah: widget.jumlah,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFBE2B0B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Konfirmasi"),
                                content: Text(
                                    "Apakah Anda yakin ingin menghapus menu ini?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Batal',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final response = await FoodService()
                                          .deleteMenu(widget.idMenu);
                                      if (response.containsKey('success')) {
                                        SnackbarUtils.showSuccessSnackbar(
                                            context, response['success']);
                                        Navigator.pop(context);
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) => BottomBar(
                                                    toPage: 1,
                                                  )),
                                        );
                                      } else {
                                        SnackbarUtils.showErrorSnackbar(
                                            context, response['error']);
                                      }
                                    },
                                    child: Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
