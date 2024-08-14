import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriService {
  final String baseUrl;
  final http.Client httpClient;

  FavoriService({required this.baseUrl}) : httpClient = http.Client();

  Future<Map<String, dynamic>?> addFavorite(int kullaniciId, int urunId) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/api/Favori'));
    request.body = jsonEncode({
      'kullaniciId': kullaniciId,
      'urunId': urunId,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        print('Favori ekleme başarısız. Hata: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Favori ekleme sırasında hata oluştu: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getFavorites() async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/Favori'));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final body = jsonDecode(await response.stream.bytesToString());
        return List<Map<String, dynamic>>.from(body);
      } else {
        print('Favoriler alınamadı. Hata: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Favoriler alınırken bir hata oluştu: $e');
      return null;
    }
  }

  // HttpClient'i kapatmak için dispose fonksiyonu
  void dispose() {
    try {
      httpClient.close();
      print('HttpClient successfully closed.');
    } catch (e) {
      print('Failed to close HttpClient: $e');
    }
  }
}
