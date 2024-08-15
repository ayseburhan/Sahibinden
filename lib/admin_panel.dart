import 'package:flutter/material.dart';
import 'services/cookie_manager.dart';
import 'services/UserAuthService.dart';
import 'users_management_page.dart'; 
import 'products_management_page.dart'; 

class AdminPanel extends StatelessWidget {
  final Map<String, String> uyelikBilgileri;
  final CookieManager cookieManager;
  final UserAuthService authService;

  const AdminPanel({
    Key? key,
    required this.uyelikBilgileri,
    required this.cookieManager,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Kullanıcı Yönetimi'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersManagementPage(
                    uyelikBilgileri: uyelikBilgileri,
                    cookieManager: cookieManager,
                    authService: authService,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Ürün Yönetimi'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsManagementPage(
                    uyelikBilgileri: uyelikBilgileri,
                    cookieManager: cookieManager,
                    authService: authService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
