import 'package:flutter/foundation.dart';

class ImportSettings {
  final String format; // 'csv', 'excel'
  final String filePath;
  final bool skipDuplicates;
  final bool updateExisting;
  final Map<String, String> fieldMapping;
  final List<String> categories;
  final DateTime? startDate;
  final DateTime? endDate;

  ImportSettings({
    this.format = 'csv',
    required this.filePath,
    this.skipDuplicates = true,
    this.updateExisting = false,
    this.fieldMapping = const {},
    this.categories = const [],
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'format': format,
      'filePath': filePath,
      'skipDuplicates': skipDuplicates,
      'updateExisting': updateExisting,
      'fieldMapping': fieldMapping,
      'categories': categories,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory ImportSettings.fromJson(Map<String, dynamic> json) {
    return ImportSettings(
      format: json['format'],
      filePath: json['filePath'],
      skipDuplicates: json['skipDuplicates'],
      updateExisting: json['updateExisting'],
      fieldMapping: Map<String, String>.from(json['fieldMapping']),
      categories: List<String>.from(json['categories']),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
} 