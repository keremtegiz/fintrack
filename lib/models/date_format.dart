import 'package:flutter/foundation.dart';

class DateFormat {
  final String code;
  final String name;
  final String format;
  final String example;

  DateFormat({
    required this.code,
    required this.name,
    required this.format,
    required this.example,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'format': format,
      'example': example,
    };
  }

  factory DateFormat.fromJson(Map<String, dynamic> json) {
    return DateFormat(
      code: json['code'],
      name: json['name'],
      format: json['format'],
      example: json['example'],
    );
  }
} 