import 'package:flutter/foundation.dart';

class Goal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String category;
  final String status; // 'active', 'completed', 'cancelled'

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.targetDate,
    required this.category,
    this.status = 'active',
  });

  double get progress => (currentAmount / targetAmount) * 100;
  bool get isCompleted => currentAmount >= targetAmount;
  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isCompleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'category': category,
      'status': status,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      targetDate: DateTime.parse(json['targetDate']),
      category: json['category'],
      status: json['status'],
    );
  }
} 