import 'package:flutter/foundation.dart';

class AboutSettings {
  final String appName;
  final String version;
  final String buildNumber;
  final String releaseDate;
  final String developer;
  final String website;
  final String privacyPolicy;
  final String termsOfService;
  final String license;

  AboutSettings({
    this.appName = 'FinTrack',
    this.version = '1.0.0',
    this.buildNumber = '1',
    this.releaseDate = '2024-03-20',
    this.developer = 'FinTrack Team',
    this.website = 'https://fintrack.com',
    this.privacyPolicy = 'https://fintrack.com/privacy',
    this.termsOfService = 'https://fintrack.com/terms',
    this.license = 'https://fintrack.com/license',
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'version': version,
      'buildNumber': buildNumber,
      'releaseDate': releaseDate,
      'developer': developer,
      'website': website,
      'privacyPolicy': privacyPolicy,
      'termsOfService': termsOfService,
      'license': license,
    };
  }

  factory AboutSettings.fromJson(Map<String, dynamic> json) {
    return AboutSettings(
      appName: json['appName'],
      version: json['version'],
      buildNumber: json['buildNumber'],
      releaseDate: json['releaseDate'],
      developer: json['developer'],
      website: json['website'],
      privacyPolicy: json['privacyPolicy'],
      termsOfService: json['termsOfService'],
      license: json['license'],
    );
  }
} 