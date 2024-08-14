import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/YeniIlan.dart';
import 'package:kullanici_giris/productScreen/kiralikEmlakPage.dart';
import 'package:kullanici_giris/productScreen/productdetail/emlakDetayPage.dart';
import 'package:kullanici_giris/productScreen/satilikEmlakPage.dart';

class EmlakPage extends StatefulWidget {
  const EmlakPage({super.key});

  @override
  _EmlakPageState createState() => _EmlakPageState();
}

class _EmlakPageState extends State<EmlakPage> {
  final List<Map<String, String>> _ilanlar = [];

  void _onIlanEkle(String title, String price, String imageUrl, String description) {
    setState(() {
      _ilanlar.add({
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'description': description,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emlak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YeniIlanPage(onIlanEkle: _onIlanEkle),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'satilik':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SatilikEmlakPage()),
                  );
                  break;
                case 'kiralik':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KiralikEmlakPage()),
                  );
                  break;
              // Diğer seçenekler buraya eklenebilir
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'satilik',
                child: Text('Satılık Emlak'),
              ),
              const PopupMenuItem<String>(
                value: 'kiralik',
                child: Text('Kiralık Emlak'),
              ),
              // Diğer seçenekler buraya eklenebilir
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // Emlakları listele
          ..._ilanlar.map((ilan) => EmlakListItem(
            imageUrl: ilan['imageUrl']!,
            title: ilan['title']!,
            price: ilan['price']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmlakDetayPage(
                    ilan: ilan,
                  ),
                ),
              );
            },
          )),
          EmlakListItem(
            imageUrl: 'https://www.egeyapi.com/assets/uploads/blog/2020/08/2-12.jpg',
            title: 'Mustakil Villa',
            price: '2.200.000 TL',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmlakDetayPage(
                    ilan: {
                      'imageUrl':
                      'https://www.egeyapi.com/assets/uploads/blog/2020/08/2-12.jpg',
                      'title': 'Mustakil Villa',
                      'price': '2.200.000 TL',
                      'description': 'Açıklama buraya yazılabilir.',
                    },
                  ),
                ),
              );
            },
          ),
          EmlakListItem(
            imageUrl:
            'https://i0.shbdn.com/photos/06/41/62/x5_1111064162mmy.jpg',
            title: 'Merkezi konumda daire',
            price: '1.500.000 TL',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmlakDetayPage(
                    ilan: {
                      'imageUrl':
                      'https://i0.shbdn.com/photos/06/41/62/x5_1111064162mmy.jpg',
                      'title': 'Merkezi konumda daire',
                      'price': '1.500.000 TL',
                      'description': 'Açıklama buraya yazılabilir.',
                    },
                  ),
                ),
              );
            },
          ),
          EmlakListItem(
            imageUrl:
            'https://hecdn01.hemlak.com/mncropresize/182/137/ds01/2/9/7/2/7/8/2/4/1719450261570-42872792.jpg',
            title: '2+1 kiralık daire',
            price: '13.500 TL/ay',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmlakDetayPage(
                    ilan: {
                      'imageUrl':
                      'https://hecdn01.hemlak.com/mncropresize/182/137/ds01/2/9/7/2/7/8/2/4/1719450261570-42872792.jpg',
                      'title': '2+1 kiralık daire',
                      'price': '13.500 TL/ay',
                      'description': 'Açıklama buraya yazılabilir.',
                    },
                  ),
                ),
              );
            },
          ),
          EmlakListItem(
            imageUrl:
            'https://www.hepsiemlak.com/emlak-yasam/wp-content/uploads/2018/03/esyali-kiralik-daire-hakkinda-bilinmesi-gerekenler-2.jpg',
            title: 'Esyali Merkezi konumda kiralık',
            price: '20.800 TL/ay',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmlakDetayPage(
                    ilan: {
                      'imageUrl':
                      'https://www.hepsiemlak.com/emlak-yasam/wp-content/uploads/2018/03/esyali-kiralik-daire-hakkinda-bilinmesi-gerekenler-2.jpg',
                      'title': 'Esyali Merkezi konumda kiralık',
                      'price': '20.800 TL/ay',
                      'description': 'Açıklama buraya yazılabilir.',
                    },
                  ),
                ),
              );
            },
          ),
          // Diğer emlakları buraya ekle
        ],
      ),
    );
  }
}

class EmlakListItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final VoidCallback onTap;

  const EmlakListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
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
