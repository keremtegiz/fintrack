import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey = 'fca_live_IWoV9Q9AmWYxeQecTiJeX1ADlQBrk0GUdmK19oBS';
  static const String baseUrl = 'https://api.freecurrencyapi.com/v1';
  
  Future<double> getExchangeRate({required String from, required String to}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/latest?apikey=$apiKey&currencies=$to&base_currency=$from'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];
        final rate = data[to]?.toDouble() ?? 1.0;
        return rate;
      } else {
        print('API error: ${response.statusCode}');
        // Varsayılan dönüş değeri, gerçek uygulamada daha iyi bir hata yönetimi yapılmalıdır
        return 1.0;
      }
    } catch (e) {
      print('Network error: $e');
      return 1.0;
    }
  }
  
  // UYARI: Free API'lerin çoğu kısıtlı istek limiti içerir. Bu nedenle gerçek uygulamada
  // döviz kurlarını önbelleğe alma (caching) stratejisi kullanmak önemlidir.
} 