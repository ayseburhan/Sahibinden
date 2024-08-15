import 'package:flutter/material.dart';
import 'package:kullanici_giris/ana_sayfa.dart';
import 'package:kullanici_giris/kullaniciGiris.dart';
import 'package:kullanici_giris/sepet.dart';
import 'globals.dart'; // Global değişkenleri import edin

class UyelikBilgileriPage extends StatelessWidget {
  const UyelikBilgileriPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KullaniciGiris(
            authService: globalUserInfo.authService,
            cookieManager: globalUserInfo.cookieManager,
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
    // Global değişkenden kullanıcı bilgilerini al
    final kullaniciAdi = globalUserInfo.kullaniciAdi ?? 'Bilgi yok';
    final ad = globalUserInfo.kullaniciSoyadi ?? 'Bilgi yok';
    final soyad = globalUserInfo.kullaniciSoyadi ?? 'Bilgi yok';
    final email = globalUserInfo.email ?? 'Bilgi yok';
    final isAdmin = globalUserInfo.isAdmin == 1 ? 'Admin' : 'Kullanıcı';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Üyelik Bilgileri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(cookieManager: globalUserInfo.cookieManager),
                ),
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
            Text('Kullanıcı Adı: $kullaniciAdi'),
            Text('Ad: $ad'),
            Text('Soyad: $soyad'),
            Text('Email: $email'),
            Text('Rol: $isAdmin'), // Admin bilgisi ekleyin
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
