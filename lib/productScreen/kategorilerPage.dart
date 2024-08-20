import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/araba.dart';
import 'package:kullanici_giris/productScreen/emlak.dart';
import 'package:kullanici_giris/productScreen/elektronik.dart';
import 'package:kullanici_giris/productScreen/is_makineleri.dart';
import 'package:kullanici_giris/productScreen/spor.dart';
import 'package:kullanici_giris/productScreen/giysi.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';

class KategorilerPage extends StatelessWidget {
  const KategorilerPage({super.key, required CookieManager cookieManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: [
          CategoryCard(
            title: 'Araba',
            icon: Icons.directions_car,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ArabaPage()),
              );
            },
          ),
          CategoryCard(
            title: 'Emlak',
            icon: Icons.house,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmlakPage()),
              );
            },
          ),
          CategoryCard(
            title: 'Elektronik',
            icon: Icons.phone_android,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ElektronikPage()),
              );
            },
          ),
          CategoryCard(
            title: 'İş Makineleri',
            icon: Icons.build,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IsMakineleriPage()),
              );
            },
          ),
          // Add more categories here
          CategoryCard(
            title: 'Spor',
            icon: Icons.sports_soccer,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SporPage()),
              );
            },
          ),
          CategoryCard(
            title: 'Giysi',
            icon: Icons.shopping_bag,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GiysiPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 50,
              color: const Color.fromARGB(255, 243, 156, 33),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
