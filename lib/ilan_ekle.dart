import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:kullanici_giris/const/urls.dart';
import 'dart:convert';
import 'package:kullanici_giris/services/UserAuthService.dart';

class Category {
  final int id;
  final String kategoriAdi;

  Category({
    required this.id,
    required this.kategoriAdi,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      kategoriAdi: json['kategoriAdi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategoriAdi': kategoriAdi,
    };
  }
}

class IlanEklemePage extends StatefulWidget {
  const IlanEklemePage({super.key});

  @override
  _IlanEklemePageState createState() => _IlanEklemePageState();
}

class _IlanEklemePageState extends State<IlanEklemePage> {
  final _formKey = GlobalKey<FormState>();
  List<Category> _categories = [];
  Category? _selectedCategory;
  TextEditingController urunAdiController = TextEditingController(text: "");
  TextEditingController urunAciklamaController = TextEditingController();
  TextEditingController urunFiyatController = TextEditingController();
  TextEditingController urunStokController = TextEditingController();
  TextEditingController urunDurumController = TextEditingController(text: "");
  String urunAdi = '';
  String _urunAciklama = '';
  double _urunFiyat = 0;
  int _urunStok = 0;
  String _urunDurum = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response =
        await http.get(Uri.parse('${Urls.BASE_URL}/GetAllKategoris'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _categories = data.map((item) => Category.fromJson(item)).toList();
      });
    } else {
      // Handle error
    }
  }

  Future<String?> _convertImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('${Urls.BASE_URL}/AddUrun'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': 0, 
          'kategoriId': _selectedCategory?.id ?? 0,
          'urunAdi': urunAdiController.value.text.toString().isNotEmpty ? urunAdiController.value.text.toString() : 'string',
          'urunAciklama': _urunAciklama.isNotEmpty ? _urunAciklama : 'string',
          'urunFiyat': _urunFiyat,
          'urunStok': _urunStok,
          'eklenmeTarihi': DateTime.now().toIso8601String(),
          'urunDurum': _urunDurum.isNotEmpty ? _urunDurum : 'string',
          'urunGorsel': await _convertImageToBase64(_imageFile) ?? 'string',
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlan ekleme hatası: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İlan Ekleme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Category>(
                decoration: InputDecoration(labelText: 'Kategori'),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.kategoriAdi),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Lütfen kategori seçin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: urunAdiController,
                decoration: InputDecoration(labelText: 'Ürün Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün adını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  urunAdi = value ?? "";
                },
              ),
              TextFormField(
                controller: urunAciklamaController,
                decoration: InputDecoration(labelText: 'Ürün Açıklaması'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün açıklamasını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunAciklama = value ?? "";
                },
              ),
              TextFormField(
                controller: urunFiyatController,
                decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün fiyatını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunFiyat = double.tryParse(value ?? '0') ?? 0;
                },
              ),
              TextFormField(
                controller: urunStokController ,
                decoration: InputDecoration(labelText: 'Ürün Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün stok miktarını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunStok = int.tryParse(value ?? '0') ?? 0;
                },
              ),
              TextFormField(
                controller: urunDurumController,
                decoration: InputDecoration(labelText: 'Ürün Durumu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün durumunu girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunDurum = value ?? "";
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                  }
                },
                child: const Text('Resim Seç'),
              ),
              if (_imageFile != null) ...[
                Image.file(_imageFile!),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('İlan Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
