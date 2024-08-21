import 'package:flutter/material.dart';
import 'package:kullanici_giris/const/urls.dart';
import 'package:kullanici_giris/main_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kullanici_giris/productScreen/productdetail/emlakDetayPage.dart';

class EmlakPage extends StatefulWidget {
  const EmlakPage({super.key});

  @override
  _EmlakPageState createState() => _EmlakPageState();
}

class _EmlakPageState extends State<EmlakPage> {
  List<dynamic> ilanlar = [];

@override
  void initState() {
    super.initState();
    fetchUrunlerByKategoriId(2);
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
        title: const Text('Emlak'),
        backgroundColor:Color.fromARGB(255, 83, 40, 153),
      ),
      body: ilanlar.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ilanlar.length,
              itemBuilder: (context, index) {
                final ilan = ilanlar[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ilan['urunGorsel'] != null
                          ? Image.memory(
                              base64Decode(ilan['urunGorsel']),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey,
                            ),
                    ),
                    title: Text(
                      ilan['urunAdi'] ?? 'Ürün Adı',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      ilan['urunAciklama'] ?? 'Ürün Açıklaması',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '${ilan['urunFiyat']} TL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 153),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmlakDetayPage(ilan: ilan),
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
