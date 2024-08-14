import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/YeniIlan.dart';

// Elektronik ürün kategorileri
enum ElektronikKategori { tumu, laptop, telefon, kulaklik, tablet }

// Elektronik alet marka enumları
enum ElektronikMarka { tumu, Apple, Samsung, Lenovo }

class ElektronikPage extends StatefulWidget {
  const ElektronikPage({super.key});

  @override
  _ElektronikPageState createState() => _ElektronikPageState();
}

class _ElektronikPageState extends State<ElektronikPage> {
  ElektronikKategori? selectedKategori = ElektronikKategori.tumu;
  ElektronikMarka? selectedMarka = ElektronikMarka.tumu;

  final List<Map<String, dynamic>> _ilanlar = [
    {
      'title': 'Akıllı Telefon',
      'price': '53.500 TL',
      'imageUrl': 'https://cdn.vatanbilgisayar.com/Upload/PRODUCT/apple/thumb/141033-1_small.jpg',
      'kategori': ElektronikKategori.telefon,
      'marka': ElektronikMarka.Apple,
    },
    {
      'title': 'Tablet',
      'price': '9.000 TL',
      'imageUrl': 'https://www.webtekno.com/images/editor/default/0003/10/a038ff1e95e3abf29dc4796dba128863fb308f97.jpeg',
      'kategori': ElektronikKategori.tablet,
      'marka': ElektronikMarka.Apple,
    },
    {
      'title': 'Laptop',
      'price': '34.500 TL',
      'imageUrl': 'https://i.ytimg.com/vi/xh1rAXpIDcs/maxresdefault.jpg',
      'kategori': ElektronikKategori.laptop,
      'marka': ElektronikMarka.Lenovo,
    },
    {
      'title': 'Kulaklık',
      'price': '3.000 TL',
      'imageUrl': 'https://cdn.akakce.com/z/urbanears/urbanears-alby-tws-kulak-ici-yesil.jpg',
      'kategori': ElektronikKategori.kulaklik,
      'marka': ElektronikMarka.Samsung,
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
      bool matchesKategori = selectedKategori == ElektronikKategori.tumu || item['kategori'] == selectedKategori;
      bool matchesMarka = selectedMarka == ElektronikMarka.tumu || item['marka'] == selectedMarka;
      return matchesKategori && matchesMarka;
    })
        .map((item) => _buildElektronikListItem(
      imageUrl: item['imageUrl'],
      title: item['title'],
      price: item['price'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ElektronikDetayPage(
              ilanTitle: item['title'],
              ilanPrice: item['price'],
              ilanImageUrl: item['imageUrl'],
              onSepeteEkle: () {
                // Sepete ekleme işlevi burada implement edilebilir
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['title']} sepete eklendi')),
                );
              },
            ),
          ),
        );
      },
    ))
        .toList();
  }

  Widget _buildElektronikListItem({
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
        title: const Text('Elektronik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showIlanEkleDialog();
            },
          ),
          PopupMenuButton<dynamic>(
            onSelected: (value) {
              setState(() {
                if (value is ElektronikKategori) {
                  selectedKategori = value;
                  selectedMarka = ElektronikMarka.tumu; // Kategori seçildiğinde marka seçimini sıfırla
                } else if (value == 'tumu') {
                  selectedKategori = ElektronikKategori.tumu;
                  selectedMarka = ElektronikMarka.tumu;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
              const PopupMenuItem<dynamic>(
                value: 'tumu',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Tümü'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<dynamic>(
                value: ElektronikKategori.laptop,
                child: Row(
                  children: [
                    Icon(Icons.laptop),
                    SizedBox(width: 8),
                    Text('Laptop'),
                  ],
                ),
              ),
              const PopupMenuItem<dynamic>(
                value: ElektronikKategori.telefon,
                child: Row(
                  children: [
                    Icon(Icons.phone_android),
                    SizedBox(width: 8),
                    Text('Telefon'),
                  ],
                ),
              ),
              const PopupMenuItem<dynamic>(
                value: ElektronikKategori.kulaklik,
                child: Row(
                  children: [
                    Icon(Icons.headphones),
                    SizedBox(width: 8),
                    Text('Kulaklık'),
                  ],
                ),
              ),
              const PopupMenuItem<dynamic>(
                value: ElektronikKategori.tablet,
                child: Row(
                  children: [
                    Icon(Icons.tablet),
                    SizedBox(width: 8),
                    Text('Tablet'),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<ElektronikMarka>(
            enabled: selectedKategori != ElektronikKategori.tumu,
            onSelected: (ElektronikMarka marka) {
              setState(() {
                selectedMarka = marka;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ElektronikMarka>>[
              const PopupMenuItem<ElektronikMarka>(
                value: ElektronikMarka.tumu,
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Tümü'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<ElektronikMarka>(
                value: ElektronikMarka.Apple,
                child: Row(
                  children: [
                    Icon(Icons.phone_android),
                    SizedBox(width: 8),
                    Text('Apple'),
                  ],
                ),
              ),
              const PopupMenuItem<ElektronikMarka>(
                value: ElektronikMarka.Samsung,
                child: Row(
                  children: [
                    Icon(Icons.headphones),
                    SizedBox(width: 8),
                    Text('Samsung'),
                  ],
                ),
              ),
              const PopupMenuItem<ElektronikMarka>(
                value: ElektronikMarka.Lenovo,
                child: Row(
                  children: [
                    Icon(Icons.laptop),
                    SizedBox(width: 8),
                    Text('Lenovo'),
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

class ElektronikDetayPage extends StatelessWidget {
  final String ilanTitle;
  final String ilanPrice;
  final String ilanImageUrl;
  final VoidCallback onSepeteEkle;

  const ElektronikDetayPage({
    required this.ilanTitle,
    required this.ilanPrice,
    required this.ilanImageUrl,
    required this.onSepeteEkle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ilanTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              ilanImageUrl,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ilanTitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ilanPrice,
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Row(
              children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$ilanTitle sepete eklendi')),
                );
              },
              child: const Text('Sepete Ekle'),
             
            ),
            const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Favorilere ekleme işlevi burada implement edilebilir
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$ilanTitle favorilere eklendi')),
                  );
                },
                child: const Text('Favorilere Ekle'),
             ),
            ],
          ),
        ],
      ),
            ),
          ],
    ),     
  ),
    );
}
 }

void main() {
  runApp(MaterialApp(
    title: 'Elektronik Uygulama',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const ElektronikPage(),
  ));
}
