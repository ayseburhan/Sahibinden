import 'package:flutter/material.dart';

// Spor kategorileri enum
enum SporKategori { tumu, futbol, basketbol, voleybol, yuzme }

// Spor marka enumları
enum SporMarka { tumu, Nike, Adidas, Puma }

class SporPage extends StatefulWidget {
  const SporPage({super.key});

  @override
  _SporPageState createState() => _SporPageState();
}

class _SporPageState extends State<SporPage> {
  SporKategori? selectedKategori = SporKategori.tumu;
  SporMarka? selectedMarka = SporMarka.tumu;

  final List<Map<String, dynamic>> _ilanlar = [
    {
      'title': 'Futbol Topu',
      'price': '150 TL',
      'imageUrl':
          'https://trthaberstatic.cdn.wp.trt.com.tr/resimler/1874000/turkiye-futbol-liglerinin-resmi-top-1874046.jpg',
      'kategori': SporKategori.futbol,
    },
    {
      'title': 'Basketbol Topu',
      'price': '250 TL',
      'imageUrl':
          'https://ideacdn.net/idea/cb/58/myassets/products/348/voit-evolution-basketbol-topu.jpg?revision=1706645948',
      'kategori': SporKategori.basketbol,
      'marka': SporMarka.Adidas,
    },
    {
      'title': 'Voleybol Topu',
      'price': '180 TL',
      'imageUrl':
          'https://contents.mediadecathlon.com/p2461306/k51c01f2c56908b7ad6d793a382f532b8/sq/8604442.jpg?format=auto&f=800x0',
      'kategori': SporKategori.voleybol,
      'marka': SporMarka.Puma,
    },
    {
      'title': 'Yüzme Gözlüğü',
      'price': '80 TL',
      'imageUrl':
          'https://contents.mediadecathlon.com/p1622828/k20e8c9315e4cd88472e1f286b10a2dcf/sq/8547681.jpg?format=auto&f=800x0',
      'kategori': SporKategori.yuzme,
      'marka': SporMarka.Nike,
    },
  ];

  List<Widget> _buildFilteredItems() {
    return _ilanlar
        .where((item) {
          bool matchesKategori =
              selectedKategori == SporKategori.tumu || item['kategori'] == selectedKategori;
          bool matchesMarka =
              selectedMarka == SporMarka.tumu || item['marka'] == selectedMarka;
          return matchesKategori && matchesMarka;
        })
        .map((item) => _buildSporListItem(
              imageUrl: item['imageUrl'],
              title: item['title'],
              price: item['price'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SporDetayPage(
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

  Widget _buildSporListItem({
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
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
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
        title: const Text('Spor'),
        actions: [
          PopupMenuButton<dynamic>(
            onSelected: (value) {
              setState(() {
                if (value is SporKategori) {
                  selectedKategori = value;
                  selectedMarka = SporMarka.tumu; // Kategori seçildiğinde marka seçimini sıfırla
                } else if (value == 'tumu') {
                  selectedKategori = SporKategori.tumu;
                  selectedMarka = SporMarka.tumu;
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
                value: SporKategori.futbol,
                child: Row(
                  children: [
                    Icon(Icons.sports_soccer),
                    SizedBox(width: 8),
                    Text('Futbol'),
                  ],
                ),
              ),
              const PopupMenuItem<dynamic>(
                value: SporKategori.basketbol,
                child: Row(
                  children: [
                    Icon(Icons.sports_basketball),
                    SizedBox(width: 8),
                    Text('Basketbol'),
                  ],
                ),
              ),
              const PopupMenuItem<dynamic>(
                value: SporKategori.voleybol,
                child: Row(
                  children: [
                    Icon(Icons.sports_volleyball),
                    SizedBox(width: 8),
                    Text('Voleybol'),
                  ],
                ),
              ),
              const PopupMenuItem<dynamic>(
                value: SporKategori.yuzme,
                child: Row(
                  children: [
                    Icon(Icons.sports),
                    SizedBox(width: 8),
                    Text('Yüzme'),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<SporMarka>(
            enabled: selectedKategori != SporKategori.tumu,
            onSelected: (SporMarka marka) {
              setState(() {
                selectedMarka = marka;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SporMarka>>[
              const PopupMenuItem<SporMarka>(
                value: SporMarka.tumu,
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Tümü'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<SporMarka>(
                value: SporMarka.Nike,
                child: Row(
                  children: [
                    Icon(Icons.sports_soccer),
                    SizedBox(width: 8),
                    Text('Nike'),
                  ],
                ),
              ),
              const PopupMenuItem<SporMarka>(
                value: SporMarka.Adidas,
                child: Row(
                  children: [
                    Icon(Icons.sports_basketball),
                    SizedBox(width: 8),
                    Text('Adidas'),
                  ],
                ),
              ),
              const PopupMenuItem<SporMarka>(
                value: SporMarka.Puma,
                child: Row(
                  children: [
                    Icon(Icons.sports_volleyball),
                    SizedBox(width: 8),
                    Text('Puma'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2 / 3,
        ),
        itemCount: _buildFilteredItems().length,
        itemBuilder: (context, index) {
          return _buildFilteredItems()[index];
        },
      ),
    );
  }
}

class SporDetayPage extends StatelessWidget {
  final String ilanTitle;
  final String ilanPrice;
  final String ilanImageUrl;
  final VoidCallback onSepeteEkle;

  const SporDetayPage({
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
                  ElevatedButton(
                    onPressed: onSepeteEkle,
                    child: const Text('Sepete Ekle'),
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
    title: 'Spor Uygulama',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const SporPage(),
  ));
}
