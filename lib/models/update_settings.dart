import 'package:flutter/foundation.dart';

class UpdateSettings {
  final bool autoUpdate;
  final String updateChannel; // 'stable', 'beta', 'alpha'
  final bool checkForUpdates;
  final String lastCheckTime;
  final String lastUpdateTime;
  final String currentVersion;
  final String latestVersion;
  final bool updateAvailable;
  final String updateStatus; // 'available', 'downloading', 'installing', 'completed', 'failed'
  final String updateUrl;
  final String updateNotes;

  UpdateSettings({
    this.autoUpdate = true,
    this.updateChannel = 'stable',
    this.checkForUpdates = true,
    this.lastCheckTime = '',
    this.lastUpdateTime = '',
    this.currentVersion = '1.0.0',
    this.latestVersion = '1.0.0',
    this.updateAvailable = false,
    this.updateStatus = 'available',
    this.updateUrl = 'https://fintrack.com/updates',
    this.updateNotes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'autoUpdate': autoUpdate,
      'updateChannel': updateChannel,
      'checkForUpdates': checkForUpdates,
      'lastCheckTime': lastCheckTime,
      'lastUpdateTime': lastUpdateTime,
      'currentVersion': currentVersion,
      'latestVersion': latestVersion,
      'updateAvailable': updateAvailable,
      'updateStatus': updateStatus,
      'updateUrl': updateUrl,
      'updateNotes': updateNotes,
    };
  }

  factory UpdateSettings.fromJson(Map<String, dynamic> json) {
    return UpdateSettings(
      autoUpdate: json['autoUpdate'],
      updateChannel: json['updateChannel'],
      checkForUpdates: json['checkForUpdates'],
      lastCheckTime: json['lastCheckTime'],
      lastUpdateTime: json['lastUpdateTime'],
      currentVersion: json['currentVersion'],
      latestVersion: json['latestVersion'],
      updateAvailable: json['updateAvailable'],
      updateStatus: json['updateStatus'],
      updateUrl: json['updateUrl'],
      updateNotes: json['updateNotes'],
    );
  }
} 