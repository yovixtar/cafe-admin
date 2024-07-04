import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/color.dart';

class FormKategoriPage extends StatefulWidget {
  final String? gambar;
  final String? namaKategori;

  const FormKategoriPage({
    Key? key,
    this.gambar,
    this.namaKategori,
  }) : super(key: key);

  @override
  _FormKategoriPageState createState() => _FormKategoriPageState();
}

class _FormKategoriPageState extends State<FormKategoriPage> {
  final _namaController = TextEditingController();
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    if (widget.namaKategori != null) {
      _namaController.text = widget.namaKategori!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.namaKategori != null ? 'Edit Kategori' : 'Tambah Kategori'),
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
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text('Nama Kategori'),
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
                          widget.namaKategori != null
                              ? 'Simpan Perubahan'
                              : 'Tambah Kategori',
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
