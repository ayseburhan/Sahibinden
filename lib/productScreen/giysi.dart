import 'package:flutter/material.dart';
import 'productdetail/giysiDetayPage.dart';

class GiysiPage extends StatefulWidget {
  const GiysiPage({super.key});

  @override
  _GiysiPageState createState() => _GiysiPageState();
}

class _GiysiPageState extends State<GiysiPage> {
  late List<Giysi> filteredGiysiList;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredGiysiList = giysiListesi;
  }

  void filterGiysiList(String query) {
    List<Giysi> filteredList = giysiListesi
        .where((giysi) =>
        giysi.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredGiysiList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giysi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: GiysiSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Ürün Ara',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    filterGiysiList('');
                  },
                ),
              ),
              onChanged: filterGiysiList,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredGiysiList.length,
                itemBuilder: (context, index) {
                  return _buildGiysiListItem(context, filteredGiysiList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiysiListItem(BuildContext context, Giysi giysi) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(giysi.imageUrl),
        ),
        title: Text(giysi.title),
        subtitle: Text(giysi.price),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiysiDetayPage(giysi: giysi),
            ),
          );
        },
      ),
    );
  }
}

class GiysiSearchDelegate extends SearchDelegate<Giysi?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Giysi> results = giysiListesi
        .where((giysi) => giysi.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(results[index].imageUrl),
          ),
          title: Text(results[index].title),
          subtitle: Text(results[index].price),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiysiDetayPage(giysi: results[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Giysi> suggestionList = giysiListesi
        .where((giysi) => giysi.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].title),
          onTap: () {
            query = suggestionList[index].title;
            showResults(context);
          },
        );
      },
    );
  }
}

// Örnek giysi listesi
List<Giysi> giysiListesi = [
  Giysi(
    imageUrl: 'https://img3.aksam.com.tr/imgsdisk/2024/04/23/ve-5-yillik-anlasma-tamam-385_2.jpg',
    title: 'Erkek Ceket',
    price: '200 TL',
  ),
  Giysi(
    imageUrl: 'https://m.media-amazon.com/images/I/61hTahF1TvL._AC_SY780_.jpg',
    title: 'Kadın Kazak',
    price: '150 TL',
  ),
  Giysi(
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAOLDecM469PVk56LI8iJ0pdqpOJqlm1ljsQ&s',
    title: 'Erkek Gömlek',
    price: '80 TL',
  ),
  Giysi(
    imageUrl: 'https://static.ticimax.cloud/cdn-cgi/image/width=-,quality=85/5334/uploads/urunresimleri/buyuk/etek-2cfd1ba2-e.jpg',
    title: 'Kadın Etek',
    price: '120 TL',
  ),
];
