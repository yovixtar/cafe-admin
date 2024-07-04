import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/color.dart';

class FormMenuPage extends StatefulWidget {
  final String? gambar;
  final String? namaMenu;
  final int? harga;
  final String? kategori;
  final String? deskripsi;

  const FormMenuPage({
    Key? key,
    this.gambar,
    this.namaMenu,
    this.harga,
    this.kategori,
    this.deskripsi,
  }) : super(key: key);

  @override
  _FormMenuPageState createState() => _FormMenuPageState();
}

class _FormMenuPageState extends State<FormMenuPage> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  int _hargaInput = 0;
  String? _kategori;
  String _imagePath = '';
  final _categories = ['Ayam', 'Rendang', 'Tempe'];

  @override
  void initState() {
    super.initState();
    if (widget.namaMenu != null) {
      _namaController.text = widget.namaMenu!;
    }
    if (widget.harga != null) {
      _hargaController.text =
          'Rp ${widget.harga!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
      _hargaInput = widget.harga!;
    }
    if (widget.deskripsi != null) {
      _deskripsiController.text = widget.deskripsi!;
    }
    if (widget.kategori != null) {
      _kategori = widget.kategori;
    }
    if (widget.gambar != null && widget.gambar!.isNotEmpty) {
      _imagePath = widget.gambar!;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Potret Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Dari Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Batal'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _formatCurrencyInput(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isNotEmpty) {
      _hargaInput = int.parse(value);
      _hargaController.text =
          'Rp ${_hargaInput.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
      _hargaController.selection = TextSelection.fromPosition(
          TextPosition(offset: _hargaController.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaMenu != null ? 'Edit Menu' : 'Tambah Menu'),
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
        toolbarHeight: null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F6FF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: _imagePath.isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(
                                'images/img-icon.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(
                                'images/img-icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                      // : Image.file(
                      //     File(_imagePath),
                      //     fit: BoxFit.cover,
                      //   ),
                    ),
                    Positioned(
                      bottom: -15,
                      right: -15,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: primaryColor,
                              shape: CircleBorder(),
                            ),
                            onPressed: () =>
                                _showImageSourceActionSheet(context),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text('Nama Menu'),
              SizedBox(height: 8),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF0F5FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Harga'),
              SizedBox(height: 8),
              TextField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF0F5FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _formatCurrencyInput,
              ),
              SizedBox(height: 16),
              Text('Kategori'),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF0F5FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Deskripsi'),
              SizedBox(height: 8),
              TextField(
                controller: _deskripsiController,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF0F5FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Text(
                          widget.namaMenu != null
                              ? 'Simpan Perubahan'
                              : 'Tambah Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
