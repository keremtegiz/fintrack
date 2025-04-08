import 'package:flutter/foundation.dart';

class Budget {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    this.spent = 0.0,
    required this.startDate,
    required this.endDate,
  });

  double get remainingAmount => limit - spent;
  double get spentPercentage => (spent / limit) * 100;
  bool get isOverBudget => spent > limit;

  Budget copyWith({
    String? id,
    String? category,
    double? limit,
    double? spent,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'spent': spent,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      limit: json['limit'],
      spent: json['spent'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
} 