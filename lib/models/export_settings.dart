import 'package:flutter/foundation.dart';

class ExportSettings {
  final String format; // 'csv', 'pdf', 'excel'
  final String dateRange; // 'all', 'custom', 'last_month', 'last_year'
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> categories;
  final bool includeTransactions;
  final bool includeBudgets;
  final bool includeGoals;
  final bool includeReports;
  final String exportLocation;

  ExportSettings({
    this.format = 'csv',
    this.dateRange = 'all',
    this.startDate,
    this.endDate,
    this.categories = const [],
    this.includeTransactions = true,
    this.includeBudgets = true,
    this.includeGoals = true,
    this.includeReports = true,
    this.exportLocation = 'downloads',
  });

  Map<String, dynamic> toJson() {
    return {
      'format': format,
      'dateRange': dateRange,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'categories': categories,
      'includeTransactions': includeTransactions,
      'includeBudgets': includeBudgets,
      'includeGoals': includeGoals,
      'includeReports': includeReports,
      'exportLocation': exportLocation,
    };
  }

  factory ExportSettings.fromJson(Map<String, dynamic> json) {
    return ExportSettings(
      format: json['format'],
      dateRange: json['dateRange'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      categories: List<String>.from(json['categories']),
      includeTransactions: json['includeTransactions'],
      includeBudgets: json['includeBudgets'],
      includeGoals: json['includeGoals'],
      includeReports: json['includeReports'],
      exportLocation: json['exportLocation'],
    );
  }
} 