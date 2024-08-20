import 'package:flutter/material.dart';
import 'package:kullanici_giris/favori_sayfasi.dart';
import 'package:kullanici_giris/globals.dart';
import 'package:kullanici_giris/ilan_ekle.dart';
import 'package:kullanici_giris/sepet.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';
import 'package:kullanici_giris/uyelikBilgileri.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  CookieManager cookieManager = CookieManager(); 
  MainScaffold({super.key, required this.child});
  
  

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  bool get isAdmin => globalUserInfo.isAdmin == 1;
  bool get isLoggedIn => globalUserInfo.isLoggedIn;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home
        break;
      case 1:
        if (isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IlanEklemePage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesPage()),
          );
        }
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SepetPage(),
          ),
        );
        break;
      case 3:
        if (isLoggedIn) {
          navigateToUyelikBilgileriPage();
        } else {
          showLoginAlert();
        }
        break;
    }
  }

  void navigateToUyelikBilgileriPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UyelikBilgileriPage(), // Assuming you have this page
      ),
    );
  }

  void showLoginAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Giriş Yapmanız Gerekiyor'),
          content: Text('Bu sayfayı görmek için giriş yapmalısınız.'),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          if (isAdmin)
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'İlan Ekle',
            )
          else
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Üyelik',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}