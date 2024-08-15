import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kullanici_giris/const/urls.dart';
import 'package:kullanici_giris/favori_sayfasi.dart';
import 'package:kullanici_giris/ilan_ekle.dart';
import 'package:kullanici_giris/kullaniciGiris.dart';
import 'package:kullanici_giris/productScreen/araba.dart';
import 'package:kullanici_giris/productScreen/elektronik.dart';
import 'package:kullanici_giris/productScreen/emlak.dart';
import 'package:kullanici_giris/productScreen/giysi.dart';
import 'package:kullanici_giris/sepet.dart';
import 'package:kullanici_giris/services/UserAuthService.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';
import 'package:kullanici_giris/globals.dart';
import 'package:kullanici_giris/uyelikBilgileri.dart';
import 'package:kullanici_giris/productScreen/kategorilerPage.dart';
import 'package:kullanici_giris/productScreen/productdetail/productDetayPage.dart';
class HomePage extends StatefulWidget {
  final CookieManager cookieManager;

  const HomePage({Key? key, required this.cookieManager}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String kullaniciAdi = "";
  bool isLoggedIn = false;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  final UserAuthService authService = UserAuthService(baseUrl: Urls.BASE_URL); // Bu satır burada olmalı
  final isAdmin = globalUserInfo.isAdmin == 1;
  
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await widget.cookieManager.getCookie('token');
    try {
      UserAuthService authService = UserAuthService(baseUrl: Urls.BASE_URL);

      // Token null olabileceği için, nullable türde bir parametre olarak geçirin
      var userInfo = await authService.getUserInfoFromCookie(token ?? '');

      if (userInfo != null) {
        setState(() {
          kullaniciAdi = userInfo['username'] ?? 'Kullanıcı';
          isLoggedIn = true;
        });
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoggedIn = false;
      });
    }
  }


  void showWelcomeMessage(String userName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hoşgeldiniz, $userName'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showLoginAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Üyelik girişi yapınız.'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Kapat',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KullaniciGiris(
                    authService: UserAuthService(baseUrl: Urls.BASE_URL),
                    cookieManager: widget.cookieManager,
                    
                  ),
                ),
              );
          },
        ),
      ),
    );
  }

  void navigateToUyelikBilgileriPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UyelikBilgileriPage()
    ),
  );
}


  void navigateToKategorilerPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KategorilerPage(cookieManager: widget.cookieManager),
      ),
    );
  }

  void onSearchPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Arama yapın...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        String searchText = searchController.text;
                        print('Arama: $searchText');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    String searchText = value;
                    print('Arama: $searchText');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
        // Adminse İlan Ekleme sayfasına git
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IlanEklemePage()),
        );
      } else {
        // Kullanıcıysa Favoriler sayfasına git
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage(cookieManager: widget.cookieManager)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahibinden.com'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchPressed,
          ),
          
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KullaniciGiris(
                    authService: UserAuthService(baseUrl: Urls.BASE_URL),
                    cookieManager: widget.cookieManager,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Future.delayed(const Duration(seconds: 1), () {
                SystemNavigator.pop(); // Uygulamayı kapatır
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Öne Çıkanlar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Öne Çıkanlar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                 ProductCard(
  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRO5vkU42F-TfTSBmhiYEuFy8pN6Be9xa7bIg&s',
  title: 'Temiz Satılık',
  price: '16.000.000 TL',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRO5vkU42F-TfTSBmhiYEuFy8pN6Be9xa7bIg&s',
          title: 'Temiz Satılık',
          price: '16.000.000 TL',
        ),
      ),
    );
  },
),

ProductCard(
  imageUrl: 'https://i.pinimg.com/originals/ff/8a/61/ff8a61e0e7a88f8e4f209e9a0c068cd6.jpg',
  title: 'Satılık Villa',
  price: '3.500.000 TL',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          imageUrl: 'https://i.pinimg.com/originals/ff/8a/61/ff8a61e0e7a88f8e4f209e9a0c068cd6.jpg',
          title: 'Satılık Villa',
          price: '3.500.000 TL',
        ),
      ),
    );
  },
),


                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Kategoriler',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: navigateToKategorilerPage,
                    child: const Text(
                      'Tüm Kategoriler',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 239, 119, 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  buildCategoryCard('Araba', Icons.directions_car, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArabaPage()),
                    );
                  }),
                  buildCategoryCard('Emlak', Icons.home, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmlakPage()),
                    );
                  }),
                  buildCategoryCard('Elektronik', Icons.electrical_services, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ElektronikPage()),
                    );
                  }),
                  buildCategoryCard('Giysi', Icons.shopping_bag, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GiysiPage()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          if(isAdmin)
          BottomNavigationBarItem(
              icon:  Icon(Icons.add),
              label: 'İlan Ekle',
            )
            else // Eğer kullanıcıysa, favoriler butonunu göster
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
        unselectedItemColor: Colors.black, // Seçilmemiş öğelerin rengi
        onTap: _onItemTapped,
      ),

    );
  }

  Widget buildCategoryCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final VoidCallback onPressed;

  const ProductCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onPressed,
  });

 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  price,
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}