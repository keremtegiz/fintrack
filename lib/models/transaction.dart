import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String type; // 'income' or 'expense'
  final DateTime date;
  final String currency; // 'TRY' or 'USD'

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.currency = 'TRY', // Default currency is TRY
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'currency': currency,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      amount: json['amount'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      currency: json['currency'] ?? 'TRY',
    );
  }
} 