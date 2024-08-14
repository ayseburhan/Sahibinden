import 'package:flutter/material.dart';

 class ProductDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const ProductDetailPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Açıklama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title sepete eklendi')),
                );
              },
              child: const Text('Sepete Ekle'),
             
            ),
            const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Favorilere ekleme işlevi burada implement edilebilir
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title favorilere eklendi')),
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