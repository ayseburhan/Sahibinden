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
  final UserAuthService authService = UserAuthService(baseUrl: Urls.BASE_URL); 
}

class _IlanEklemePageState extends State<IlanEklemePage> {
  final _formKey = GlobalKey<FormState>();
  String _isim = '';
  String _aciklama = '';
  String _fiyat = '';
  String _stok = '';
  File? _resim;
  List<Category> _categories = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('${Urls.BASE_URL}/GetAllKategoris'));
    print(response);
    if (response.statusCode == 200) {
      List<Category> categories = (json.decode(response.body) as List)
          .map((data) => Category.fromJson(data))
          .toList();
      setState(() {
        _categories = categories;
      });
    } else {
      throw Exception('Kategori verileri alınamadı');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('${Urls.BASE_URL}/GetAllKategoris'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'kategoriId': _selectedCategory?.id,
          'urunAdi': _isim,
          'urunAciklama': _aciklama,
          'urunFiyat': _fiyat,
          'urunStok': _stok,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İlan başarıyla eklendi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlan ekleme hatası: ${response.body}')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _resim = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan Ekleme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Ürün Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün adını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _isim = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen açıklama girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _aciklama = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fiyat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen fiyat girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fiyat = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Stok'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen stok miktarını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _stok = value!;
                },
              ),
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
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Resim Seç'),
              ),
              if (_resim != null) Image.file(_resim!),
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
