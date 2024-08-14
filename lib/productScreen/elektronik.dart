import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/productdetail/elektronikDetayPage.dart';
import 'YeniIlan.dart';

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
      'imageUrl':
      'https://cdn.vatanbilgisayar.com/Upload/PRODUCT/apple/thumb/141033-1_small.jpg',
      'kategori': ElektronikKategori.telefon,
      'marka': ElektronikMarka.Apple,
    },
    {
      'title': 'Tablet',
      'price': '9.000 TL',
      'imageUrl':
      'https://www.webtekno.com/images/editor/default/0003/10/a038ff1e95e3abf29dc4796dba128863fb308f97.jpeg',
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
      'imageUrl':
      'https://cdn.akakce.com/z/urbanears/urbanears-alby-tws-kulak-ici-yesil.jpg',
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
                  MaterialPageRoute(
                    builder: (context) => YeniIlanPage(
                      onIlanEkle: (title, price, imageUrl, description) {
                        print(
                            'Yeni ilan eklendi: $title, $price, $imageUrl, $description');
                        Navigator.pop(context);
                      },
                    ),
                  ),
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
      bool matchesKategori =
          selectedKategori == ElektronikKategori.tumu || item['kategori'] == selectedKategori;
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
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
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
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<ElektronikMarka>> items = [];
              if (selectedKategori == ElektronikKategori.laptop) {
                items.addAll([
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
                  // Diğer laptop markaları buraya eklenebilir
                ]);
              } else if (selectedKategori == ElektronikKategori.telefon) {
                items.addAll([
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
                  // Diğer telefon markaları buraya eklenebilir
                ]);
              } else if (selectedKategori == ElektronikKategori.kulaklik) {
                items.addAll([
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
                  // Diğer kulaklık markaları buraya eklenebilir
                ]);
              } else if (selectedKategori == ElektronikKategori.tablet) {
                items.addAll([
                  const PopupMenuItem<ElektronikMarka>(
                    value: ElektronikMarka.Apple,
                    child: Row(
                      children: [
                        Icon(Icons.tablet),
                        SizedBox(width: 8),
                        Text('Apple'),
                      ],
                    ),
                  ),
                  // Diğer tablet markaları buraya eklenebilir
                ]);
              }
              return items;
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 4,
        ),
        itemCount: _buildFilteredItems().length,
        itemBuilder: (context, index) {
          return _buildFilteredItems()[index];
        },
      ),
    );
  }
}
