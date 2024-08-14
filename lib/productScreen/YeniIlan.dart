import 'package:flutter/material.dart';

class YeniIlanPage extends StatelessWidget {
  const YeniIlanPage({super.key, required this.onIlanEkle});

  final Function(String, String, String, String) onIlanEkle;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni İlan Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Fiyat',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Görsel URL',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Yeni ilan ekleme işlemleri burada yapılacak
                final String title = titleController.text;
                final String price = priceController.text;
                final String imageUrl = imageUrlController.text;
                final String description = descriptionController.text;

                // Yeni ilanı listeye eklemek için gerekli işlemler
                onIlanEkle(title, price, imageUrl, description);
                Navigator.pop(context);
              },
              child: const Text('İlanı Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
