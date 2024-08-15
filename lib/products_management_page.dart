import 'package:flutter/material.dart';
import 'services/cookie_manager.dart';
import 'services/UserAuthService.dart';

class ProductsManagementPage extends StatelessWidget {
  final Map<String, String> uyelikBilgileri;
  final CookieManager cookieManager;
  final UserAuthService authService;

  const ProductsManagementPage({
    Key? key,
    required this.uyelikBilgileri,
    required this.cookieManager,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Yönetimi'),
      ),
      body: Center(
        child: const Text('Ürün Yönetimi Sayfası İçeriği'),
      ),
    );
  }
}