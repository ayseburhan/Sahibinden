import 'package:flutter/material.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';
import 'kullaniciGiris.dart';
import 'services/UserAuthService.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  final String baseUrl = Platform.isAndroid
      ? 'http://172.20.10.2:5207'
      : 'http://localhost:7001';

  final UserAuthService authService = UserAuthService(baseUrl: baseUrl);
  final CookieManager cookieManager = CookieManager(); // CookieManager örneği oluşturuyoruz

  try {
    runApp(MyApp(authService: authService, cookieManager: cookieManager)); // CookieManager'ı da geçiyoruz
  } catch (e) {
    print('Uygulama başlatılırken hata oluştu: $e');
  }
}

class MyApp extends StatelessWidget {
  final UserAuthService authService;
  final CookieManager cookieManager; // CookieManager'ı ekliyoruz

  const MyApp({Key? key, required this.authService, required this.cookieManager}) : super(key: key);

  static const String _title = 'Sahibinden.com';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const HalfColoredText(),
        ),
        body: KullaniciGiris(authService: authService, cookieManager: cookieManager), // CookieManager'ı da geçiyoruz
      ),
    );
  }
}

class HalfColoredText extends StatelessWidget {
  const HalfColoredText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'SAHIBINDEN',
            style: TextStyle(backgroundColor: Colors.yellow, color: Colors.black),
          ),
          TextSpan(
            text: '.com',
            style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
          ),
        ],
      ),
    );
  }
}