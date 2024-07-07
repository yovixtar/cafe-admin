import 'dart:io';

import 'package:admin/Model/category_model.dart';
import 'package:admin/Service/category_service.dart';
import 'package:admin/Service/food_service.dart';
import 'package:admin/bottom_bar.dart';
import 'package:admin/color.dart';
import 'package:admin/config.dart';
import 'package:admin/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormMenuPage extends StatefulWidget {
  final String? idMenu;
  final String? gambar;
  final String? namaMenu;
  final int? harga;
  final String? kategori;
  final String? idKategori;
  final String? deskripsi;
  final String? jumlah;

  const FormMenuPage({
    Key? key,
    this.idMenu,
    this.gambar,
    this.namaMenu,
    this.harga,
    this.kategori,
    this.idKategori,
    this.deskripsi,
    this.jumlah,
  }) : super(key: key);

  @override
  _FormMenuPageState createState() => _FormMenuPageState();
}

class _FormMenuPageState extends State<FormMenuPage> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _jumlahController = TextEditingController();
  int _hargaInput = 0;
  String? _idKategori;
  String _imagePath = '';
  bool _isFromNetwork = false;
  List<Category> _categories = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _formatCurrencyInput(String value) {
    value = value.replaceAll(RegExp(r'[^\d]'), '');

    if (value.isNotEmpty) {
      _hargaInput = int.parse(value);
      _hargaController.text = 'Rp ' +
          _hargaInput.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]}.',
              );
      _hargaController.selection = TextSelection.fromPosition(
        TextPosition(offset: _hargaController.text.length),
      );
    } else {
      _hargaInput = 0;
      _hargaController.text = '';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    if (widget.namaMenu != null) {
      _namaController.text = widget.namaMenu!;
    }
    if (widget.harga != null) {
      _formatCurrencyInput(widget.harga.toString());
    }
    if (widget.deskripsi != null) {
      _deskripsiController.text = widget.deskripsi!;
    }
    if (widget.kategori != null) {
      _idKategori = widget.idKategori;
    }
    if (widget.gambar != null && widget.gambar!.isNotEmpty) {
      _imagePath = widget.gambar!;
      _isFromNetwork = true;
    }
    if (widget.jumlah != null) {
      _jumlahController.text = widget.jumlah!;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _isFromNetwork = false;
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

  Future<void> _fetchCategories() async {
    try {
      final categories = await CategoryService().getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      SnackbarUtils.showErrorSnackbar(context, "Gagal mengambil kategori !");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final foodService = FoodService();

      if (_imagePath.isEmpty) {
        SnackbarUtils.showErrorSnackbar(context, 'Gambar harus dipilih');
        return;
      }
      setState(() {
        _isLoading = true;
      });
      var response;
      if (_imagePath.isNotEmpty && _imagePath != widget.gambar) {
        response = widget.namaMenu != null
            ? await foodService.updateMenu(
                idMenu: widget.idMenu!,
                nama: _namaController.text,
                harga: _hargaInput,
                gambar: File(_imagePath),
                deskripsi: _deskripsiController.text,
                jumlah: int.parse(_jumlahController.text),
                categoryId: [_idKategori ?? ''],
              )
            : await foodService.addMenu(
                nama: _namaController.text,
                harga: _hargaInput,
                gambar: File(_imagePath),
                deskripsi: _deskripsiController.text,
                jumlah: int.parse(_jumlahController.text),
                categoryId: [_idKategori ?? ''],
              );
      } else {
        response = widget.namaMenu != null
            ? await foodService.updateMenu(
                idMenu: widget.idMenu!,
                nama: _namaController.text,
                harga: _hargaInput,
                deskripsi: _deskripsiController.text,
                jumlah: int.parse(_jumlahController.text),
                categoryId: [_idKategori ?? ''],
              )
            : await foodService.addMenu(
                nama: _namaController.text,
                harga: _hargaInput,
                gambar: File(_imagePath),
                deskripsi: _deskripsiController.text,
                jumlah: int.parse(_jumlahController.text),
                categoryId: [_idKategori ?? ''],
              );
      }

      if (response.containsKey('success')) {
        SnackbarUtils.showSuccessSnackbar(context, response['success']);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BottomBar(
              toPage: 1,
            ),
          ),
        );
      } else {
        SnackbarUtils.showErrorSnackbar(context, response['error']);
      }
      setState(() {
        _isLoading = false;
      });
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
        child: Form(
          key: _formKey,
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
                            : _isFromNetwork
                                ? Image.network(
                                    "${Config.baseUrl}$_imagePath",
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_imagePath),
                                    fit: BoxFit.cover,
                                  ),
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
                                backgroundColor: Theme.of(context).primaryColor,
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
                _buildInput(
                  label: 'Nama Menu',
                  controller: _namaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama menu tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildInput(
                  label: 'Harga',
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  onChanged: _formatCurrencyInput,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildDropdown(
                  label: 'Kategori',
                  value: _idKategori,
                  items: _categories,
                  onChanged: (value) {
                    setState(() {
                      _idKategori = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                _buildInput(
                  label: 'Deskripsi',
                  controller: _deskripsiController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                _buildInput(
                  label: 'Jumlah',
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (_isLoading) ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 20),
                        ),
                        child: (_isLoading)
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                                widget.namaMenu != null
                                    ? 'Update Menu'
                                    : 'Tambah Menu',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
    int maxLines = 1,
    isCurrency = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: (!isCurrency)
              ? onChanged
              : (value) {
                  _formatCurrencyInput(value);
                },
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Color(0xFFF0F5FA),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<Category> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item.id,
              child: Text(item.nama),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Color(0xFFF0F5FA),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kategori tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
