import 'package:flutter/foundation.dart';

class Report {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // 'daily', 'weekly', 'monthly', 'yearly'
  final Map<String, dynamic> data;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
      'data': data,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      data: json['data'],
    );
  }
} 