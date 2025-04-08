import 'package:flutter/foundation.dart';

class Backup {
  final String id;
  final DateTime date;
  final String filePath;
  final int size;
  final String status; // 'success', 'failed', 'in_progress'

  Backup({
    required this.id,
    required this.date,
    required this.filePath,
    required this.size,
    this.status = 'success',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'filePath': filePath,
      'size': size,
      'status': status,
    };
  }

  factory Backup.fromJson(Map<String, dynamic> json) {
    return Backup(
      id: json['id'],
      date: DateTime.parse(json['date']),
      filePath: json['filePath'],
      size: json['size'],
      status: json['status'],
    );
  }
} 