import 'package:flutter/material.dart';

class EmlakDetayPage extends StatelessWidget {
  final Map<String, String> ilan;

  const EmlakDetayPage({
    super.key,
    required this.ilan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ilan['title'] ?? 'Emlak Detayı'),
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