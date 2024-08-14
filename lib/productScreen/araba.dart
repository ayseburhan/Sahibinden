import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/productdetail/arabaDetayPage.dart';

import 'YeniIlan.dart';


// Araba markaları enum tanımı
enum ArabaMarka {
  Kia,
  Toyota,
  Ford,
  // Diğer markalar
}

// Araba modelleri enum tanımı
enum ArabaModel {
  Stonic,
  Corolla,
  Focus,
  // Diğer modeller
}

class ArabaPage extends StatefulWidget {
  const ArabaPage({super.key});

  @override
  _ArabaPageState createState() => _ArabaPageState();
}

class _ArabaPageState extends State<ArabaPage> {
  ArabaMarka? selectedMarka;
  ArabaModel? selectedModel;
  final List<Map<String, dynamic>> _ilanlar = [];

  void _onIlanEkle(String title, String price, String imageUrl, String description) {
    setState(() {
      _ilanlar.add({
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'description': description,
        'marka': selectedMarka,
        'model': selectedModel,
      });
    });
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YeniIlanPage(onIlanEkle: _onIlanEkle)),
              );
            },
          ),
          PopupMenuButton<dynamic>(
            onSelected: (value) {
              setState(() {
                if (value is ArabaMarka) {
                  selectedMarka = value;
                  selectedModel = null; // Marka seçildiğinde model seçimini sıfırla
                } else if (value == 'tumu') {
                  selectedMarka = null;
                  selectedModel = null;
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
                value: ArabaMarka.Kia,
                child: Text('Kia'),
              ),
              const PopupMenuItem<dynamic>(
                value: ArabaMarka.Toyota,
                child: Text('Toyota'),
              ),
              const PopupMenuItem<dynamic>(
                value: ArabaMarka.Ford,
                child: Text('Ford'),
              ),
              // Diğer markalar buraya eklenebilir
            ],
          ),
          PopupMenuButton<ArabaModel>(
            enabled: selectedMarka != null,
            onSelected: (ArabaModel model) {
              setState(() {
                selectedModel = model;
              });
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<ArabaModel>> items = [];
              if (selectedMarka == ArabaMarka.Kia) {
                items.addAll([
                  const PopupMenuItem<ArabaModel>(
                    value: ArabaModel.Stonic,
                    child: Text('Stonic'),
                  ),
                  // Diğer Kia modelleri buraya eklenebilir
                ]);
              } else if (selectedMarka == ArabaMarka.Toyota) {
                items.addAll([
                  const PopupMenuItem<ArabaModel>(
                    value: ArabaModel.Corolla,
                    child: Text('Corolla'),
                  ),
                  // Diğer Toyota modelleri buraya eklenebilir
                ]);
              } else if (selectedMarka == ArabaMarka.Ford) {
                items.addAll([
                  const PopupMenuItem<ArabaModel>(
                    value: ArabaModel.Focus,
                    child: Text('Focus'),
                  ),
                  // Diğer Ford modelleri buraya eklenebilir
                ]);
              }
              return items;
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          if (selectedMarka == null && selectedModel == null)
            ..._buildArabaCards()
          else
            ..._buildFilteredArabaCards(),
        ],
      ),
    );
  }

  List<Widget> _buildArabaCards() {
    final List<Map<String, dynamic>> sabitIlanlar = [
      {
        'marka': ArabaMarka.Kia,
        'model': ArabaModel.Stonic,
        'imageUrl': 'https://www.kiaavcilar.com/upload/ckfinder/images/kampanya/Kia_Stonic_Offer.jpg',
        'title': 'Kia Stonic 2021',
        'price': '986.000 TL',
      },
      {
        'marka': ArabaMarka.Toyota,
        'model': ArabaModel.Corolla,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrig4udv-02g2qxhcXkSFAELpuS0er--anpQ&s',
        'title': 'Toyota Corolla 2020',
        'price': '1.000.000 TL',
      },
      {
        'marka': ArabaMarka.Ford,
        'model': ArabaModel.Focus,
        'imageUrl': 'https://www.webtekno.com/images/editor/default/0002/79/75303f4fe75a701cf5d226a7e0f94fb4bbab32ae.jpeg',
        'title': 'Ford Focus 2018',
        'price': '880.000 TL',
      },
      // Diğer arabaları buraya ekle
    ];

    return sabitIlanlar.map((ilan) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArabaDetayPage(ilan: ilan),
            ),
          );
        },
        child: ArabaCard(
          marka: ilan['marka'],
          model: ilan['model'],
          imageUrl: ilan['imageUrl'],
          title: ilan['title'],
          price: ilan['price'],
        ),
      );
    }).toList();
  }

  List<Widget> _buildFilteredArabaCards() {
    final List<Map<String, dynamic>> sabitIlanlar = [
      {
        'marka': ArabaMarka.Kia,
        'model': ArabaModel.Stonic,
        'imageUrl': 'https://www.kiaavcilar.com/upload/ckfinder/images/kampanya/Kia_Stonic_Offer.jpg',
        'title': 'Kia Stonic 2021',
        'price': '986.000 TL',
      },
      {
        'marka': ArabaMarka.Toyota,
        'model': ArabaModel.Corolla,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrig4udv-02g2qxhcXkSFAELpuS0er--anpQ&s',
        'title': 'Toyota Corolla 2020',
        'price': '1.000.000 TL',
      },
      {
        'marka': ArabaMarka.Ford,
        'model': ArabaModel.Focus,
        'imageUrl': 'https://www.webtekno.com/images/editor/default/0002/79/75303f4fe75a701cf5d226a7e0f94fb4bbab32ae.jpeg',
        'title': 'Ford Focus 2018',
        'price': '880.000 TL',
      },
      // Diğer arabaları buraya ekle
    ];

    final List<Map<String, dynamic>> filteredIlanlar = sabitIlanlar.where((ilan) {
      final ArabaMarka ilanMarka = ilan['marka'];
      final ArabaModel ilanModel = ilan['model'];
      if (selectedMarka != null && selectedModel != null) {
        return ilanMarka == selectedMarka && ilanModel == selectedModel;
      } else if (selectedMarka != null) {
        return ilanMarka == selectedMarka;
      }
      return true;
    }).toList();

    return filteredIlanlar.map((ilan) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArabaDetayPage(ilan: ilan),
            ),
          );
        },
        child: ArabaCard(
          marka: ilan['marka'],
          model: ilan['model'],
          imageUrl: ilan['imageUrl'],
          title: ilan['title'],
          price: ilan['price'],
        ),
      );
    }).toList();
  }
}

// Araba ilan kartı bileşeni
class ArabaCard extends StatelessWidget {
  final ArabaMarka marka;
  final ArabaModel model;
  final String imageUrl;
  final String title;
  final String price;

  const ArabaCard({
    super.key,
    required this.marka,
    required this.model,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
