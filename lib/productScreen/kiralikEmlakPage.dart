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

class KiralikEmlakPage extends StatelessWidget {
   KiralikEmlakPage({super.key});

  final List<EmlakListItem> kiralikEmlaklar = [
    const EmlakListItem(
      imageUrl: 'https://hecdn01.hemlak.com/mncropresize/182/137/ds01/2/9/7/2/7/8/2/4/1719450261570-42872792.jpg',
      title: '2+1 kiralık daire',
      price: '13.500 TL/ay',
    ),
    const EmlakListItem(
      imageUrl: 'https://www.hepsiemlak.com/emlak-yasam/wp-content/uploads/2018/03/esyali-kiralik-daire-hakkinda-bilinmesi-gerekenler-2.jpg',
      title: 'Esyali Merkezi konumda kiralık',
      price: '20.800 TL/ay',
    ),
    // Diğer kiralık emlakları buraya ekle
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiralık Emlak'),
      ),
      body: ListView(
        children: kiralikEmlaklar.map((ilan) => ilan).toList(),
      ),
    );
  }
}
