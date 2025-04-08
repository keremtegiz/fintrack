import 'package:flutter/foundation.dart';

class Theme {
  final String name;
  final String primaryColor;
  final String secondaryColor;
  final String backgroundColor;
  final String textColor;
  final bool isDark;

  Theme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.isDark = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'isDark': isDark,
    };
  }

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      name: json['name'],
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      isDark: json['isDark'],
    );
  }
} 