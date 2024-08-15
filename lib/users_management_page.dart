import 'package:flutter/material.dart';
import 'services/cookie_manager.dart';
import 'services/UserAuthService.dart';

class UsersManagementPage extends StatelessWidget {
  final Map<String, String> uyelikBilgileri;
  final CookieManager cookieManager;
  final UserAuthService authService;

  const UsersManagementPage({
    Key? key,
    required this.uyelikBilgileri,
    required this.cookieManager,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Yönetimi'),
      ),
      body: Center(
        child: const Text('Kullanıcı Yönetimi Sayfası İçeriği'),
      ),
    );
  }
}