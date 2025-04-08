import 'package:flutter/foundation.dart';

class Statistics {
  final double totalIncome;
  final double totalExpense;
  final Map<String, double> categoryExpenses;
  final Map<String, double> categoryIncomes;
  final List<Map<String, dynamic>> monthlyData;

  Statistics({
    required this.totalIncome,
    required this.totalExpense,
    required this.categoryExpenses,
    required this.categoryIncomes,
    required this.monthlyData,
  });

  double get netIncome => totalIncome - totalExpense;
  double get savingsRate => totalIncome > 0 ? (netIncome / totalIncome) * 100 : 0;

  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'categoryExpenses': categoryExpenses,
      'categoryIncomes': categoryIncomes,
      'monthlyData': monthlyData,
    };
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalIncome: json['totalIncome'],
      totalExpense: json['totalExpense'],
      categoryExpenses: Map<String, double>.from(json['categoryExpenses']),
      categoryIncomes: Map<String, double>.from(json['categoryIncomes']),
      monthlyData: List<Map<String, dynamic>>.from(json['monthlyData']),
    );
  }
} 