import 'package:admin/Screen/menu/form_menu.dart';
import 'package:admin/Screen/menu/detail_menu.dart';
import 'package:flutter/material.dart';

class ListMenu extends StatefulWidget {
  const ListMenu({super.key});

  @override
  _ListMenuState createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'gambar': 'images/img-icon.png',
      'namaMenu': 'Ayam Bakar',
      'harga': 10000,
      'kategori': 'Ayam',
      'deskripsi':
          'ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ',
      'stok': 10,
    },
    {
      'gambar': 'images/img-icon.png',
      'namaMenu': 'Ayam Goreng',
      'harga': 10000,
      'kategori': 'Ayam',
      'deskripsi':
          'ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ',
      'stok': 10,
    },
    {
      'gambar': 'images/img-icon.png',
      'namaMenu': 'Tempe Mendoan',
      'harga': 5000,
      'kategori': 'Tempe',
      'deskripsi':
          'ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ',
      'stok': 10,
    },
    {
      'gambar': 'images/img-icon.png',
      'namaMenu': 'Rendang Sapi',
      'harga': 10000,
      'kategori': 'Rendang',
      'deskripsi':
          'ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ini deskripsi panjang ',
      'stok': 10,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 20,
            childAspectRatio: 0.65,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        item['gambar'],
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item['namaMenu'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Rp. ${item['harga'].toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]}.',
                          )}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuDetailPage(
                                    gambar: item['gambar'],
                                    namaMenu: item['namaMenu'],
                                    harga: item['harga'],
                                    kategori: item['kategori'],
                                    deskripsi: item['deskripsi'],
                                    stok: item['stok'],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF7622),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Detail',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FormMenuPage(),
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
