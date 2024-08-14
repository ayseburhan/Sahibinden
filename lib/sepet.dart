import 'package:flutter/material.dart';

class SepetPage extends StatelessWidget {
  const SepetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek sepet verileri
    List<Map<String, dynamic>> sepetUrunleri = [
     /*
      {'urunAdi': 'Ürün 1', 'fiyat': 100.0},
      {'urunAdi': 'Ürün 2', 'fiyat': 50.0},
      {'urunAdi': 'Ürün 3', 'fiyat': 75.0},
    */
    ];

    // Toplam tutar hesaplama
    double toplamTutar = sepetUrunleri.fold(0, (sum, item) => sum + item['fiyat']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sepetteki Ürünler:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sepetUrunleri.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(sepetUrunleri[index]['urunAdi']),
                    subtitle: Text('Fiyat: ${sepetUrunleri[index]['fiyat']}'),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Toplam Tutar: $toplamTutar',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
