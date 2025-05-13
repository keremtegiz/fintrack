import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/currency_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _currencyService = CurrencyService();
  bool _isLoading = false;
  double _exchangeRateUSDtoTRY = 0.0;
  double _exchangeRateEURtoTRY = 0.0;
  DateTime? _lastUpdated;
  
  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }
  
  Future<void> _fetchExchangeRates() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // API çağrıları
      final usdToTry = await _currencyService.getExchangeRate(
        from: 'USD',
        to: 'TRY',
      );
      
      final eurToTry = await _currencyService.getExchangeRate(
        from: 'EUR',
        to: 'TRY',
      );
      
      setState(() {
        _exchangeRateUSDtoTRY = usdToTry;
        _exchangeRateEURtoTRY = eurToTry;
        _lastUpdated = DateTime.now();
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Döviz kurları güncellenemedi: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'TEKRAR DENE',
            onPressed: _fetchExchangeRates,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Döviz Kurları',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchExchangeRates,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Son güncelleme zamanı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Güncel Kurlar',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      _lastUpdated != null
                          ? 'Son Güncelleme: ${_lastUpdated!.hour.toString().padLeft(2, '0')}:${_lastUpdated!.minute.toString().padLeft(2, '0')}'
                          : 'Henüz güncellenmedi',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Dolar kuru kartı
                _buildCurrencyCard(
                  currencyName: 'Amerikan Doları',
                  currencyCode: 'USD',
                  exchangeRate: _exchangeRateUSDtoTRY,
                  flagAsset: '🇺🇸', // Emoji kullanımı
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 16),
                
                // Euro kuru kartı
                _buildCurrencyCard(
                  currencyName: 'Euro',
                  currencyCode: 'EUR',
                  exchangeRate: _exchangeRateEURtoTRY,
                  flagAsset: '🇪🇺', // Emoji kullanımı
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // Güncelleme butonu
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchExchangeRates,
                    icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.refresh),
                    label: Text(_isLoading ? 'Güncelleniyor...' : 'Kurları Güncelle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Küçük bilgi notu
                Text(
                  'Not: Kurlar anlık değişkenlik gösterebilir. Alım satım işlemleri için bankanızın güncel kurlarını kontrol ediniz.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrencyCard({
    required String currencyName,
    required String currencyCode,
    required double exchangeRate,
    required String flagAsset,
    required bool isLoading,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  flagAsset,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  currencyName,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '1 $currencyCode',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '=',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        '₺${exchangeRate.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alış',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '₺${(exchangeRate - 0.05).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Satış',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '₺${(exchangeRate + 0.05).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
