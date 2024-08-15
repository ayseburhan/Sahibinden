import 'package:http/http.dart' as http;
import 'dart:convert';

// HTTP isteklerindeki hataları özel olarak ele almak için kullanılacak sınıf
class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}

// Kullanıcı işlemleri için HTTP isteklerini yönetecek olan servis sınıfı
class UserAuthService {
  final String baseUrl; // API'nin temel URL adresi
  final http.Client httpClient; // HTTP istekleri yapmak için kullanılacak http.Client nesnesi

  // Kurucu method
  UserAuthService({required this.baseUrl}) : httpClient = http.Client();

  // Yeni bir kullanıcı kaydı yapılmasını sağlayan fonksiyon
  Future<bool> registerUser(String email, String username, String password, String ad, String soyad, String telefon) async {
    var headers = {
      'Content-Type': 'application/json' // İstek başlığı olarak JSON kullanılacak
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/api/User/register')); // Yeni kullanıcı kaydı için POST isteği oluşturuluyor
    request.body = json.encode({ // Gövde (body) kısmı JSON formatında kodlanıyor
      "kullaniciMail": email,
      "kullaniciSifre": password,
      "kullaniciAdi": username,
      "kullaniciSoyadi": soyad,
      "kullaniciAdres": telefon
    });
    request.headers.addAll(headers); // İstek başlığına headers eklendi

    try {
      http.StreamedResponse response = await request.send(); // İstek gönderilip yanıt bekleniyor

      if (response.statusCode == 200) { // Başarılı yanıt durumu kontrol ediliyor
        return true; // Başarılı kayıt durumu
      } else {
        print('Kayıt başarısız. Durum kodu: ${response.statusCode}');
        print('Hata mesajı: ${await response.stream.bytesToString()}');
        return false; // Başarısız kayıt durumu
      }
    } catch (e) {
      print('Kayıt sırasında hata oluştu: $e');
      return false; // Hata durumu
    }
  }
  Future<http.Response> getUsers(String token) {
    return http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },  );
  }
  // Kullanıcı girişi sağlayan fonksiyon
  Future<int?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Kullanici/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'kullaniciMail': email,
        'kullaniciSifre': password,
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final int? adminBilgi = responseBody['adminbilgi'];
      return adminBilgi;
    } else {
      print('Giriş başarısız. Durum kodu: ${response.statusCode}');
      return null;
    }
  }


  // Admin girişi sağlayan fonksiyon
  Future<bool> loginAdmin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Admin/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Admin girişi başarısız. Durum kodu: ${response.statusCode}');
      return false;
    }
  }

  // Kullanıcıya ait üyelik bilgilerini kullanıcı kimliği (ID) ile almayı sağlayan fonksiyon
  Future<Map<String, dynamic>?> getUyelikBilgileriById(int kullaniciId) async {
    var headers = {
      'Content-Type': 'application/json' // İstek başlığı olarak JSON kullanılacak
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/User/getUserById?id=$kullaniciId')); // Kullanıcı bilgilerini getirmek için GET isteği oluşturuluyor
    request.headers.addAll(headers); // İstek başlığına headers eklendi

    try {
      http.StreamedResponse response = await request.send(); // İstek gönderilip yanıt bekleniyor

      if (response.statusCode == 200) { // Başarılı yanıt durumu kontrol ediliyor
        final body = json.decode(await response.stream.bytesToString()); // Yanıtın gövdesi JSON formatından çözülüyor
        return {
          'username': body['kullaniciAdi'],
          'ad': body['kullaniciAd'],
          'soyad': body['kullaniciSoyad'],
          'email': body['kullaniciMail'],
          'password': body['kullaniciSifre'],
          'telefon': body['kullaniciAdres'],
        }; // Kullanıcı bilgileri map olarak döndürülüyor
      } else {
        print('Üyelik bilgileri alınamadı. Hata: ${response.reasonPhrase}');
        return null; // Başarısız üyelik bilgileri alma durumu
      }
    } catch (e) {
      print('Üyelik bilgileri alınırken bir hata oluştu: $e');
      return null; // Hata durumu
    }
  }

  // Çerezlerden session ID ile kullanıcı bilgilerini almak için yeni fonksiyon
  Future<Map<String, dynamic>?> getUserInfoFromCookie(String sessionCookie) async {
    var headers = {
      'Content-Type': 'application/json', // İstek başlığı olarak JSON kullanılacak
      'Cookie': 'session=$sessionCookie' // Çerezi başlığa ekleyin
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/User/getUserFromSession')); // Session ID ile kullanıcı bilgilerini almak için GET isteği oluşturuluyor
    request.headers.addAll(headers); // İstek başlığına headers eklendi

    try {
      http.StreamedResponse response = await request.send(); // İstek gönderilip yanıt bekleniyor

      if (response.statusCode == 200) { // Başarılı yanıt durumu kontrol ediliyor
        final body = json.decode(await response.stream.bytesToString()); // Yanıtın gövdesi JSON formatından çözülüyor
        return {
          'username': body['kullaniciAdi'],
          'ad': body['kullaniciAd'],
          'soyad': body['kullaniciSoyad'],
          'email': body['kullaniciMail'],
          'password': body['kullaniciSifre'],
          'telefon': body['kullaniciAdres'],
        }; // Kullanıcı bilgileri map olarak döndürülüyor
      } else {
        print('Kullanıcı bilgileri alınamadı. Hata: ${response.reasonPhrase}');
        return null; // Başarısız kullanıcı bilgileri alma durumu
      }
    } catch (e) {
      print('Kullanıcı bilgileri alınırken bir hata oluştu: $e');
      return null; // Hata durumu
    }
  }

  // Kullanılan httpClient kapatılıyor
  void dispose() {
    try {
      httpClient.close();
      print('HttpClient successfully closed.');
    } catch (e) {
      print('Failed to close HttpClient: $e');
    }
  }
}
