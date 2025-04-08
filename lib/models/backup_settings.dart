import 'package:flutter/foundation.dart';

class BackupSettings {
  final bool autoBackup;
  final String backupFrequency; // 'daily', 'weekly', 'monthly'
  final String backupTime;
  final bool cloudBackup;
  final String cloudProvider; // 'google_drive', 'dropbox', 'iCloud'
  final String backupLocation;

  BackupSettings({
    this.autoBackup = true,
    this.backupFrequency = 'daily',
    this.backupTime = '00:00',
    this.cloudBackup = false,
    this.cloudProvider = 'google_drive',
    this.backupLocation = 'local',
  });

  Map<String, dynamic> toJson() {
    return {
      'autoBackup': autoBackup,
      'backupFrequency': backupFrequency,
      'backupTime': backupTime,
      'cloudBackup': cloudBackup,
      'cloudProvider': cloudProvider,
      'backupLocation': backupLocation,
    };
  }

  factory BackupSettings.fromJson(Map<String, dynamic> json) {
    return BackupSettings(
      autoBackup: json['autoBackup'],
      backupFrequency: json['backupFrequency'],
      backupTime: json['backupTime'],
      cloudBackup: json['cloudBackup'],
      cloudProvider: json['cloudProvider'],
      backupLocation: json['backupLocation'],
    );
  }
} 