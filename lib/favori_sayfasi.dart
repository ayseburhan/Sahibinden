import 'package:flutter/material.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';
import 'package:kullanici_giris/services/favoriService.dart';


class FavoritesPage extends StatefulWidget {
  final CookieManager cookieManager;

  const FavoritesPage({Key? key, required this.cookieManager}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoriService favoriService;
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    favoriService = FavoriService(baseUrl: 'http://localhost:5207');
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final fetchedFavorites = await favoriService.getFavorites();
      if (fetchedFavorites != null) {
        setState(() {
          favorites = fetchedFavorites;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Favoriler alınamadı.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Favoriler alınırken bir hata oluştu: $e';
        isLoading = false;
      });
    }
  }

  void _removeFavorite(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Onay'),
          content: const Text('Bu favoriyi silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favorites.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    favoriService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : favorites.isEmpty
          ? const Center(child: Text('Henüz favori ilanınız bulunmamaktadır.'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 5,
            child: ListTile(
              leading: Image.network(
                favorite['imageUrl'] ?? 'https://via.placeholder.com/70',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              title: Text(favorite['title'] ?? 'Başlık yok'),
              subtitle: Text(favorite['price'] ?? 'Fiyat yok'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeFavorite(index),
              ),
              onTap: () {
                // İlan detaylarına gitme işlemi
                // Detay sayfasına navigasyon ekleyebilirsiniz
              },
            ),
          );
        },
      ),
    );
  }
}
