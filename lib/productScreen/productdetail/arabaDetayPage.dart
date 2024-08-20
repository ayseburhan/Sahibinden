import 'dart:convert';

import 'package:flutter/material.dart';

class Arabadetay extends StatelessWidget {
  final Map<String, dynamic> ilan;

  Arabadetay({required this.ilan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ilan['urunAdi'] ?? 'Araba Detayı'),
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
                child: ilan['urunGorsel'] != null
                    ? Image.memory(
                        base64Decode(ilan['urunGorsel']),
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              ilan['urunAdi'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${ilan['urunFiyat']} TL',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Açıklama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ilan['urunAciklama'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${ilan['urunAdi']} sepete eklendi')),
                    );
                  },
                  child: const Text('Sepete Ekle'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${ilan['urunAdi']} favorilere eklendi')),
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
