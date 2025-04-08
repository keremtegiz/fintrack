import 'package:flutter/foundation.dart';

class Language {
  final String code;
  final String name;
  final String nativeName;
  final Map<String, String> translations;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.translations,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'translations': translations,
    };
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'],
      name: json['name'],
      nativeName: json['nativeName'],
      translations: Map<String, String>.from(json['translations']),
    );
  }
} 