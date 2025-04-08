import 'package:flutter/foundation.dart';

class Settings {
  final String currency;
  final String language;
  final bool darkMode;
  final bool notifications;
  final String dateFormat;

  Settings({
    this.currency = 'USD',
    this.language = 'en',
    this.darkMode = false,
    this.notifications = true,
    this.dateFormat = 'MM/dd/yyyy',
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'language': language,
      'darkMode': darkMode,
      'notifications': notifications,
      'dateFormat': dateFormat,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      currency: json['currency'],
      language: json['language'],
      darkMode: json['darkMode'],
      notifications: json['notifications'],
      dateFormat: json['dateFormat'],
    );
  }
} 