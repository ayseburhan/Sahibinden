import 'package:flutter/material.dart';
import 'package:kullanici_giris/services/UserAuthService.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';
import 'package:kullanici_giris/kullaniciGiris.dart';
import 'package:kullanici_giris/ana_sayfa.dart';
import 'package:kullanici_giris/sepet.dart';

class UyelikBilgileriPage extends StatelessWidget {
  final Map<String, String> uyelikBilgileri;
  final CookieManager cookieManager;
  final UserAuthService authService; // Add this line

  const UyelikBilgileriPage({
    Key? key,
    required this.uyelikBilgileri,
    required this.cookieManager,
    required this.authService, // Add this line
  }) : super(key: key);
  
  Future<void> _logout(BuildContext context) async {
    try {
      // Tüm çerezleri sil
      await cookieManager.deleteAllCookies();
      print('Cookies deleted successfully.');

      // Giriş sayfasına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KullaniciGiris(
            authService: authService,
            cookieManager: cookieManager,
          ),
        ),
      );
    } catch (e) {
      print('Logout error: $e');
      // Hata mesajını kullanıcıya göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çıkış işlemi sırasında bir hata oluştu: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üyelik Bilgileri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage(cookieManager: cookieManager)),
                (Route<dynamic> route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SepetPage()),
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
            Text('Kullanıcı Adı: ${uyelikBilgileri['username'] ?? 'Bilgi yok'}'),
            Text('Email: ${uyelikBilgileri['email'] ?? 'Bilgi yok'}'),
            Text('Ad: ${uyelikBilgileri['ad'] ?? 'Bilgi yok'}'),
            Text('Soyad: ${uyelikBilgileri['soyad'] ?? 'Bilgi yok'}'),
            Text('Telefon: ${uyelikBilgileri['telefon'] ?? 'Bilgi yok'}'),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Oturumu Kapat'),
            ),
          ],
        ),
      ),
    );
  }
}
