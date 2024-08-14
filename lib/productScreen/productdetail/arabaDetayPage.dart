import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/YeniIlan.dart';

// Araba marka enumları
enum ArabaMarka { tumu, BMW, Mercedes, Audi }

class ArabaPage extends StatefulWidget {
  const ArabaPage({super.key});

  @override
  _ArabaPageState createState() => _ArabaPageState();
}

class _ArabaPageState extends State<ArabaPage> {
  ArabaMarka? selectedMarka = ArabaMarka.tumu;

  final List<Map<String, dynamic>> _ilanlar = [
    {
      'title': 'BMW 3 Serisi',
      'price': '1.200.000 TL',
      'imageUrl': 'https://www.bmw.com.tr/content/dam/bmw/common/all-models/3-series/sedan/2018/navigation/BMW-3-Series-Sedan-Modellfinder.png',
      'marka': ArabaMarka.BMW,
    },
    {
      'title': 'Mercedes C Serisi',
      'price': '1.400.000 TL',
      'imageUrl': 'https://www.mercedes-benz.com.tr/passengercars/mercedes-benz-cars/models/c-class/saloon-w205/explore/dam/w205-explore-gallery-3400x1440-c35-01-2016.jpg',
      'marka': ArabaMarka.Mercedes,
    },
    {
      'title': 'Audi A4',
      'price': '1.300.000 TL',
      'imageUrl': 'https://www.audi.com.tr/media/Model_Gallery/model_image_2019_3x2_1920x1280/1920x1080-mtc-v2/model_image/1920x1080-mtc-v2-teaser-images/1920x1080-mtc-v2-teaser-images/mmo-model-1920x1080-audi-a4-sedan-2019-18.jpg',
      'marka': ArabaMarka.Audi,
    },
  ];

  void _showIlanEkleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İlan Ekle'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('İlan ekleme işlemi için yeni ilana tıklayınız'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yeni İlan'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YeniIlanPage(
                    onIlanEkle: (title, price, imageUrl, description) {
                      print('Yeni ilan eklendi: $title, $price, $imageUrl, $description');
                      Navigator.pop(context);
                    },
                  )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFilteredItems() {
    return _ilanlar
        .where((item) {
      bool matchesMarka = selectedMarka == ArabaMarka.tumu || item['marka'] == selectedMarka;
      return matchesMarka;
    })
        .map((item) => _buildArabaListItem(
      imageUrl: item['imageUrl'],
      title: item['title'],
      price: item['price'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArabaDetayPage(
              ilan: item,
            ),
          ),
        );
      },
    ))
        .toList();
  }

  Widget _buildArabaListItem({
    required String imageUrl,
    required String title,
    required String price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3.0,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Image.network(
              imageUrl,
              height: 200,
              width: 230,
              fit: BoxFit.cover,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabalar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showIlanEkleDialog();
            },
          ),
          PopupMenuButton<ArabaMarka>(
            onSelected: (ArabaMarka marka) {
              setState(() {
                selectedMarka = marka;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ArabaMarka>>[
              const PopupMenuItem<ArabaMarka>(
                value: ArabaMarka.tumu,
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Tümü'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<ArabaMarka>(
                value: ArabaMarka.BMW,
                child: Row(
                  children: [
                    Icon(Icons.directions_car),
                    SizedBox(width: 8),
                    Text('BMW'),
                  ],
                ),
              ),
              const PopupMenuItem<ArabaMarka>(
                value: ArabaMarka.Mercedes,
                child: Row(
                  children: [
                    Icon(Icons.directions_car),
                    SizedBox(width: 8),
                    Text('Mercedes'),
                  ],
                ),
              ),
              const PopupMenuItem<ArabaMarka>(
                value: ArabaMarka.Audi,
                child: Row(
                  children: [
                    Icon(Icons.directions_car),
                    SizedBox(width: 8),
                    Text('Audi'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: _buildFilteredItems(),
      ),
    );
  }
}

class ArabaDetayPage extends StatelessWidget {
  final Map<String, dynamic> ilan;

  const ArabaDetayPage({
    super.key,
    required this.ilan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ilan['title'] ?? 'Araba Detayı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  ilan['imageUrl'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              ilan['title'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ilan['price'] ?? '',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Açıklama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ilan['description'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${ilan['title']} sepete eklendi')),
                );
              },
              child: const Text('Sepete Ekle'),
             
            ),
            const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Favorilere ekleme işlevi burada implement edilebilir
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${ilan['title']} favorilere eklendi')),
                  );
                },
                child: const Text('Favorilere Ekle'),
             ),
            ],
          ),
        ],
      ),
    ),
  );
}
 }

void main() {
  runApp(MaterialApp(
    title: 'Araba Uygulama',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const ArabaPage(),
  ));
}
