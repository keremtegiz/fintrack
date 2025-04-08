import 'package:flutter/foundation.dart';

class SecuritySettings {
  final bool biometricAuth;
  final bool pinAuth;
  final String pin;
  final bool autoLock;
  final int autoLockTimeout; // in minutes
  final bool hideBalance;
  final bool hideTransactions;
  final bool encryptData;

  SecuritySettings({
    this.biometricAuth = false,
    this.pinAuth = false,
    this.pin = '',
    this.autoLock = true,
    this.autoLockTimeout = 5,
    this.hideBalance = false,
    this.hideTransactions = false,
    this.encryptData = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'biometricAuth': biometricAuth,
      'pinAuth': pinAuth,
      'pin': pin,
      'autoLock': autoLock,
      'autoLockTimeout': autoLockTimeout,
      'hideBalance': hideBalance,
      'hideTransactions': hideTransactions,
      'encryptData': encryptData,
    };
  }

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      biometricAuth: json['biometricAuth'],
      pinAuth: json['pinAuth'],
      pin: json['pin'],
      autoLock: json['autoLock'],
      autoLockTimeout: json['autoLockTimeout'],
      hideBalance: json['hideBalance'],
      hideTransactions: json['hideTransactions'],
      encryptData: json['encryptData'],
    );
  }
} 