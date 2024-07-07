import 'package:admin/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:admin/Model/food_model.dart';
import 'package:admin/Screen/Detail/add_to_cart.dart';
import 'package:admin/Screen/Detail/detail_app_bar.dart';

class FoodDetail extends StatefulWidget {
  final FoodModel data;

  const FoodDetail({super.key, required this.data});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  int kuantitas = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: AddToCart(product: widget.data),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailAppBar(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.data.gambar.isEmpty
                          ? AssetImage('images/img-icon.png') as ImageProvider
                          : NetworkImage(
                                  "${Config.baseUrl}${widget.data.gambar}")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 15, 0, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.nama,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rp. ${widget.data.harga.toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]}.',
                            )}',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Kategori : ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children:
                                widget.data.kategori.map<Widget>((kategori) {
                              return Chip(
                                label: Text(kategori.nama.trim()),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Deskripsi',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(widget.data.deskripsi,
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ));
  }
}
