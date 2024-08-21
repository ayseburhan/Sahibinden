import 'package:flutter/material.dart';
import 'package:kullanici_giris/const/urls.dart';
import 'package:kullanici_giris/main_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kullanici_giris/productScreen/productdetail/isMakineleriDetay.dart';

class IsMakineleriPage extends StatefulWidget {
  const IsMakineleriPage({super.key});

  @override
  _IsMakineleriPageState createState() => _IsMakineleriPageState();
}

class _IsMakineleriPageState extends State<IsMakineleriPage> {
  List<dynamic> ilanlar = [];

@override
  void initState() {
    super.initState();
    fetchUrunlerByKategoriId(4);
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

 Widget build(BuildContext context) {
  return MainScaffold(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('İş Makineleri'),
        backgroundColor:Color.fromARGB(255, 209, 101, 29),
      ),
      body: ilanlar.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Bir satırda kaç sütun olacağını belirler
                  crossAxisSpacing: 8.0, // Sütunlar arasındaki boşluk
                  mainAxisSpacing: 8.0, // Satırlar arasındaki boşluk
                  childAspectRatio: 3 / 4, // Kartların en-boy oranı
                ),
                itemCount: ilanlar.length,
                itemBuilder: (context, index) {
                  final ilan = ilanlar[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsMakinesiDetay(ilan: ilan),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: ilan['urunGorsel'] != null
                                  ? Image.memory(
                                      base64Decode(ilan['urunGorsel']),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.image,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ilan['urunAdi'] ?? 'Ürün Adı',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  ilan['urunAciklama'] ?? 'Ürün Açıklaması',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${ilan['urunFiyat']} TL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 209, 101, 29),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    ),
  );
}


}
