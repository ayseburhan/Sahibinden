import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/productdetail/emlakDetayPage.dart';


class EmlakListItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const EmlakListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmlakDetayPage(
                ilan: {
                  'imageUrl': imageUrl,
                  'title': title,
                  'price': price,
                  'description': 'Açıklama buraya yazılabilir.', // Buraya ilanın açıklaması eklenebilir
                },
              ),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Image.network(imageUrl),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class SatilikEmlakPage extends StatelessWidget {
   SatilikEmlakPage({super.key});

  final List<EmlakListItem> satilikEmlaklar = [
    const EmlakListItem(
      imageUrl: 'https://cdn.hangiev.com/girne-esentepe-satilik-villa-202011000551020000616552N.jpg',
      title: 'Özel havuzlu villa',
      price: '14.000.000 TL',
    ),
    const EmlakListItem(
      imageUrl: 'https://www.kacmazemlak.com/konut/foto/portfoy/satilik/daire/bursa-nilufer-kultur-203189-75a614b7.jpg',
      title: 'Yeni sitede satilik ',
      price: '4.350.000 TL',
    ),
    const EmlakListItem(
      imageUrl: 'https://www.egeyapi.com/assets/uploads/blog/2020/08/2-12.jpg',
      title: 'Mustakil Villa',
      price: '9.200.000 TL',
    ),
    const EmlakListItem(
      imageUrl: 'https://i0.shbdn.com/photos/06/41/62/x5_1111064162mmy.jpg',
      title: 'Merkezi konumda daire',
      price: '2.500.000 TL',
    ),
    // Diğer satılık emlakları buraya ekle
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satılık Emlak'),
      ),
      body: ListView(
        children: satilikEmlaklar.map((ilan) => ilan).toList(),
      ),
    );
  }
}
