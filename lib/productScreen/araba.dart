import 'package:flutter/material.dart';
import 'package:kullanici_giris/const/urls.dart';
import 'package:kullanici_giris/main_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kullanici_giris/productScreen/productdetail/arabaDetayPage.dart';

class ArabaPage extends StatefulWidget {
  @override
  _ArabaPageState createState() => _ArabaPageState();
}

class _ArabaPageState extends State<ArabaPage> {
  List<dynamic> ilanlar = [];

  @override
  void initState() {
    super.initState();
    fetchUrunlerByKategoriId(1);
  }

  Future<void> fetchUrunlerByKategoriId(int kategoriId) async {
    final response = await http.get(Uri.parse('${Urls.BASE_URL}/GetUrunlerByKategoriId?kategoriId=$kategoriId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        ilanlar = data;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler çekilemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Arabalar'),
        ),
        body: ilanlar.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ilanlar.length,
                itemBuilder: (context, index) {
                  final ilan = ilanlar[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: ilan['urunGorsel'] != null
                          ? Image.memory(base64Decode(ilan['urunGorsel']))
                          : Icon(Icons.image),
                      title: Text(ilan['urunAdi'] ?? 'Ürün Adı'),
                      subtitle: Text(ilan['urunAciklama'] ?? 'Ürün Açıklaması'),
                      trailing: Text('${ilan['urunFiyat']} TL'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Arabadetay(ilan:ilan),
                          ),
                        );
                      },
                    ),
                  );

                },
              ),
      ),
    );
  }
}
