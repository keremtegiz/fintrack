import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  // Tamamen ücretsiz ve API anahtarı gerektirmeyen servisler
  static const String exchangeRateAPI = 'https://open.er-api.com/v6/latest';
  static const String floatRatesAPI = 'https://www.floatrates.com/daily';
  
  Future<double> getExchangeRate({
    required String from,
    required String to,
  }) async {
    // Farklı API'leri sırayla deneyelim
    List<Future<double> Function()> apiCalls = [
      () => _tryExchangeRateAPI(from, to),
      () => _tryFloatRatesAPI(from, to),
    ];
    
    Exception? lastException;
    
    for (var apiCall in apiCalls) {
      try {
        final rate = await apiCall();
        print('API çağrısı başarılı: $from -> $to = $rate');
        return rate;
      } catch (e) {
        print('API denemesi başarısız: $e');
        lastException = e is Exception ? e : Exception(e.toString());
        // Bir sonraki API'yi dene
      }
    }
    
    // Tüm API'ler başarısız olduysa son hatayı fırlat
    throw lastException ?? Exception('Tüm API denemeleri başarısız oldu');
  }
  
  // ExchangeRate-API.com - tamamen ücretsiz, API anahtarı gerektirmez
  Future<double> _tryExchangeRateAPI(String from, String to) async {
    try {
      // API URL'sini oluştur
      final url = Uri.parse('$exchangeRateAPI/$from');
      
      print('ExchangeRate-API çağrısı: $url');
      final response = await http.get(url);
      print('ExchangeRate-API yanıtı: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['result'] == 'success') {
          final rates = jsonResponse['rates'];
          if (rates != null && rates[to] != null) {
            return rates[to].toDouble();
          }
          throw Exception('Döviz kuru bulunamadı: $to');
        } else {
          throw Exception('API başarısız: ${jsonResponse['error-type']}');
        }
      } else {
        throw Exception('HTTP Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('ExchangeRate-API hatası: $e');
      throw Exception('ExchangeRate-API: $e');
    }
  }
  
  // FloatRates - tamamen ücretsiz, JSON dosyaları
  Future<double> _tryFloatRatesAPI(String from, String to) async {
    try {
      // FloatRates her para birimi için ayrı JSON dosyası kullanır
      final fromLower = from.toLowerCase();
      
      // API URL'sini oluştur
      final url = Uri.parse('$floatRatesAPI/$fromLower.json');
      
      print('FloatRates API çağrısı: $url');
      final response = await http.get(url);
      print('FloatRates yanıtı: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // FloatRates'de tüm değerler küçük harfle
        final toLower = to.toLowerCase();
        if (jsonResponse[toLower] != null) {
          final rate = jsonResponse[toLower]['rate'];
          if (rate != null) {
            return double.parse(rate.toString());
          }
        }
        throw Exception('FloatRates: $to kuru bulunamadı');
      } else {
        throw Exception('FloatRates HTTP hata: ${response.statusCode}');
      }
    } catch (e) {
      print('FloatRates API hatası: $e');
      throw Exception('FloatRates: $e');
    }
  }
}
