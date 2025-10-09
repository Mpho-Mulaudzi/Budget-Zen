import '../data/currency_data.dart';

class CurrencyService {
  List<Map<String, String>> getAllCurrencies() => currencyData;

  Map<String, String>? findBySymbol(String symbol) {
    try {
      return currencyData.firstWhere((c) => c["symbol"] == symbol);
    } catch (_) {
      return null;
    }
  }
}