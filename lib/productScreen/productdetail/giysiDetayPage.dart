import 'package:flutter/material.dart';

class GiysiDetayPage extends StatelessWidget {
  final Giysi giysi;

  const GiysiDetayPage({super.key, required this.giysi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(giysi.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                giysi.imageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ürün Adı: ${giysi.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Fiyat: ${giysi.price}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Buraya alışveriş sepetine ekleme veya satın alma işlemleri eklenebilir
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ürün Ekle'),
                      content: Text('${giysi.title} sepetinize eklendi.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Kapat'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Sepete Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

class Giysi {
  final String imageUrl;
  final String title;
  final String price;

  Giysi({required this.imageUrl, required this.title, required this.price});
}
