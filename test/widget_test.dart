import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kullanici_giris/main.dart';
import 'package:kullanici_giris/services/UserAuthService.dart';
import 'package:kullanici_giris/services/cookie_manager.dart'; // CookieManager'ı import edin

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create an instance of UserAuthService for testing
    final authService = UserAuthService(baseUrl: 'https://localhost:44382');

    // Create an instance of CookieManager for testing
    final cookieManager = CookieManager();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(authService: authService, cookieManager: cookieManager));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}