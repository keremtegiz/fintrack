import 'package:flutter/foundation.dart';

class StorageSettings {
  final String storageType; // 'local', 'cloud', 'hybrid'
  final String cloudProvider; // 'google_drive', 'dropbox', 'iCloud'
  final String localPath;
  final String cloudPath;
  final int maxStorageSize;
  final int currentStorageSize;
  final bool autoCleanup;
  final String cleanupFrequency; // 'daily', 'weekly', 'monthly'
  final String cleanupTime;
  final List<String> cleanupItems; // ['cache', 'logs', 'temp', 'backups']
  final bool encryptData;
  final String encryptionKey;
  final String encryptionAlgorithm;
  final bool compressData;
  final String compressionLevel;
  final bool useCache;
  final int cacheSize;
  final String cacheDuration;

  StorageSettings({
    this.storageType = 'local',
    this.cloudProvider = 'google_drive',
    this.localPath = 'data/',
    this.cloudPath = 'fintrack/',
    this.maxStorageSize = 1000,
    this.currentStorageSize = 0,
    this.autoCleanup = true,
    this.cleanupFrequency = 'weekly',
    this.cleanupTime = '00:00',
    this.cleanupItems = const ['cache', 'logs', 'temp'],
    this.encryptData = true,
    this.encryptionKey = '',
    this.encryptionAlgorithm = 'AES-256',
    this.compressData = true,
    this.compressionLevel = 'medium',
    this.useCache = true,
    this.cacheSize = 100,
    this.cacheDuration = '1h',
  });

  Map<String, dynamic> toJson() {
    return {
      'storageType': storageType,
      'cloudProvider': cloudProvider,
      'localPath': localPath,
      'cloudPath': cloudPath,
      'maxStorageSize': maxStorageSize,
      'currentStorageSize': currentStorageSize,
      'autoCleanup': autoCleanup,
      'cleanupFrequency': cleanupFrequency,
      'cleanupTime': cleanupTime,
      'cleanupItems': cleanupItems,
      'encryptData': encryptData,
      'encryptionKey': encryptionKey,
      'encryptionAlgorithm': encryptionAlgorithm,
      'compressData': compressData,
      'compressionLevel': compressionLevel,
      'useCache': useCache,
      'cacheSize': cacheSize,
      'cacheDuration': cacheDuration,
    };
  }

  factory StorageSettings.fromJson(Map<String, dynamic> json) {
    return StorageSettings(
      storageType: json['storageType'],
      cloudProvider: json['cloudProvider'],
      localPath: json['localPath'],
      cloudPath: json['cloudPath'],
      maxStorageSize: json['maxStorageSize'],
      currentStorageSize: json['currentStorageSize'],
      autoCleanup: json['autoCleanup'],
      cleanupFrequency: json['cleanupFrequency'],
      cleanupTime: json['cleanupTime'],
      cleanupItems: List<String>.from(json['cleanupItems']),
      encryptData: json['encryptData'],
      encryptionKey: json['encryptionKey'],
      encryptionAlgorithm: json['encryptionAlgorithm'],
      compressData: json['compressData'],
      compressionLevel: json['compressionLevel'],
      useCache: json['useCache'],
      cacheSize: json['cacheSize'],
      cacheDuration: json['cacheDuration'],
    );
  }
} 