import 'package:flutter/foundation.dart';

class NetworkSettings {
  final bool useProxy;
  final String proxyHost;
  final int proxyPort;
  final String proxyUsername;
  final String proxyPassword;
  final int timeout;
  final int retryCount;
  final bool useCache;
  final String cachePath;
  final int cacheSize;
  final String cacheDuration;
  final bool useCompression;
  final String compressionLevel;
  final bool useSSL;
  final bool verifySSL;
  final String sslCertificate;
  final String sslKey;
  final String sslPassword;

  NetworkSettings({
    this.useProxy = false,
    this.proxyHost = '',
    this.proxyPort = 8080,
    this.proxyUsername = '',
    this.proxyPassword = '',
    this.timeout = 30,
    this.retryCount = 3,
    this.useCache = true,
    this.cachePath = 'cache/',
    this.cacheSize = 100,
    this.cacheDuration = '1h',
    this.useCompression = true,
    this.compressionLevel = 'medium',
    this.useSSL = true,
    this.verifySSL = true,
    this.sslCertificate = '',
    this.sslKey = '',
    this.sslPassword = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'useProxy': useProxy,
      'proxyHost': proxyHost,
      'proxyPort': proxyPort,
      'proxyUsername': proxyUsername,
      'proxyPassword': proxyPassword,
      'timeout': timeout,
      'retryCount': retryCount,
      'useCache': useCache,
      'cachePath': cachePath,
      'cacheSize': cacheSize,
      'cacheDuration': cacheDuration,
      'useCompression': useCompression,
      'compressionLevel': compressionLevel,
      'useSSL': useSSL,
      'verifySSL': verifySSL,
      'sslCertificate': sslCertificate,
      'sslKey': sslKey,
      'sslPassword': sslPassword,
    };
  }

  factory NetworkSettings.fromJson(Map<String, dynamic> json) {
    return NetworkSettings(
      useProxy: json['useProxy'],
      proxyHost: json['proxyHost'],
      proxyPort: json['proxyPort'],
      proxyUsername: json['proxyUsername'],
      proxyPassword: json['proxyPassword'],
      timeout: json['timeout'],
      retryCount: json['retryCount'],
      useCache: json['useCache'],
      cachePath: json['cachePath'],
      cacheSize: json['cacheSize'],
      cacheDuration: json['cacheDuration'],
      useCompression: json['useCompression'],
      compressionLevel: json['compressionLevel'],
      useSSL: json['useSSL'],
      verifySSL: json['verifySSL'],
      sslCertificate: json['sslCertificate'],
      sslKey: json['sslKey'],
      sslPassword: json['sslPassword'],
    );
  }
} 