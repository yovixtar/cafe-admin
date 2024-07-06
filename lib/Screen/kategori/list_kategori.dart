import 'package:admin/Model/category_model.dart';
import 'package:admin/bottom_bar.dart';
import 'package:admin/color.dart';
import 'package:admin/Screen/kategori/form_kategori.dart';
import 'package:admin/Service/category_service.dart';
import 'package:admin/config.dart';
import 'package:flutter/material.dart';

class ListKategori extends StatefulWidget {
  const ListKategori({super.key});

  @override
  _ListKategoriState createState() => _ListKategoriState();
}

class _ListKategoriState extends State<ListKategori> {
  List<Category> kategoriItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      var categories = await CategoryService().getCategories();
      setState(() {
        kategoriItems = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Kategori',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    columnWidths: {
                      0: FractionColumnWidth(0.2),
                      1: FractionColumnWidth(0.6),
                      2: FractionColumnWidth(0.2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Icon',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Nama',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Aksi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      ...kategoriItems.map((kategori) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                "${Config.baseUrl}${kategori.gambar}",
                                width: 30,
                                height: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                kategori.nama,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => FormKategoriPage(
                                          id: kategori.id,
                                          gambar: kategori.gambar,
                                          namaKategori: kategori.nama,
                                        ),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text(
                                              'Yakin Ingin Menghapus Kategori Ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('Batal',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Panggil fungsi deleteCategory
                                                final response =
                                                    await CategoryService()
                                                        .deleteCategory(
                                                            kategori.id);
                                                if (response
                                                    .containsKey('success')) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(response[
                                                            'success'])),
                                                  );
                                                  Navigator.pop(context);
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            BottomBar(
                                                              toPage: 2,
                                                            )),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            response['error'])),
                                                  );
                                                }
                                              },
                                              child: Text('Hapus',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        SizedBox(width: 8),
                                        Text('Hapus'),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Icon(Icons.more_vert),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FormKategoriPage(),
            ),
          );
        },
        backgroundColor: Color(0xFF2A4BA0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
