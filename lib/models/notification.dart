import 'package:flutter/foundation.dart';

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      isRead: json['isRead'],
    );
  }
} 