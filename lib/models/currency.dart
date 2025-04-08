import 'package:flutter/foundation.dart';

class Currency {
  final String code;
  final String name;
  final String symbol;
  final double exchangeRate;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.exchangeRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'exchangeRate': exchangeRate,
    };
  }

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
      exchangeRate: json['exchangeRate'],
    );
  }
} 