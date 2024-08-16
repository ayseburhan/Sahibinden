import 'package:flutter/material.dart';
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

  // JSON'dan Category nesnesi oluşturma
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      kategoriAdi: json['kategoriAdi'],
    );
  }

  // Category nesnesini JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategoriAdi': kategoriAdi,
    };
  }
}

class IlanEklemePage extends StatefulWidget {
  @override
  _IlanEklemePageState createState() => _IlanEklemePageState();
}

class _IlanEklemePageState extends State<IlanEklemePage> {
  final _formKey = GlobalKey<FormState>();
  List<Category> _categories = [];
  Category? _selectedCategory;
  String _urunAdi = '';
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
          'id': 0, // Varsayılan değer olarak 0 atanmış
          'kategoriId': _selectedCategory?.id ??
              0, // Eğer kategori seçili değilse 0 atanır
          'urunAdi': _urunAdi ??
              'string', // Eğer ürün adı belirtilmemişse 'string' atanır
          'urunAciklama': _urunAciklama ??
              'string', // Eğer ürün açıklaması belirtilmemişse 'string' atanır
          'urunFiyat': (_urunFiyat ?? 0)
              .toInt(), // double değeri int'e dönüştürülüp atanır
          'urunStok':
              _urunStok ?? 0, // Eğer ürün stoğu belirtilmemişse 0 atanır
          'eklenmeTarihi':
              DateTime.now().toIso8601String(), // Şu anki tarih ve saat atanır
          'urunDurum': _urunDurum ??
              'string', // Eğer ürün durumu belirtilmemişse 'string' atanır
          'urunGorsel': await _convertImageToBase64(_imageFile) ??
              'string', // Eğer görsel yoksa 'string' atanır
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
                    _selectedCategory = newValue!;
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
                decoration: InputDecoration(labelText: 'Ürün Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün adını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunAdi = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ürün Açıklaması'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün açıklamasını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunAciklama = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün fiyatını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunFiyat = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ürün Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün stok miktarını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunStok = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ürün Durumu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün durumunu girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urunDurum = value!;
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
