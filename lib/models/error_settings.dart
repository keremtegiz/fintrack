import 'package:flutter/foundation.dart';

class ErrorSettings {
  final bool showErrors;
  final bool logErrors;
  final bool reportErrors;
  final String errorLogPath;
  final String errorReportUrl;
  final String errorEmail;
  final String errorLevel; // 'debug', 'info', 'warning', 'error', 'critical'
  final bool showStackTrace;
  final bool showErrorDetails;
  final String errorFormat; // 'json', 'text', 'html'

  ErrorSettings({
    this.showErrors = true,
    this.logErrors = true,
    this.reportErrors = true,
    this.errorLogPath = 'logs/error.log',
    this.errorReportUrl = 'https://fintrack.com/error-report',
    this.errorEmail = 'errors@fintrack.com',
    this.errorLevel = 'error',
    this.showStackTrace = true,
    this.showErrorDetails = true,
    this.errorFormat = 'json',
  });

  Map<String, dynamic> toJson() {
    return {
      'showErrors': showErrors,
      'logErrors': logErrors,
      'reportErrors': reportErrors,
      'errorLogPath': errorLogPath,
      'errorReportUrl': errorReportUrl,
      'errorEmail': errorEmail,
      'errorLevel': errorLevel,
      'showStackTrace': showStackTrace,
      'showErrorDetails': showErrorDetails,
      'errorFormat': errorFormat,
    };
  }

  factory ErrorSettings.fromJson(Map<String, dynamic> json) {
    return ErrorSettings(
      showErrors: json['showErrors'],
      logErrors: json['logErrors'],
      reportErrors: json['reportErrors'],
      errorLogPath: json['errorLogPath'],
      errorReportUrl: json['errorReportUrl'],
      errorEmail: json['errorEmail'],
      errorLevel: json['errorLevel'],
      showStackTrace: json['showStackTrace'],
      showErrorDetails: json['showErrorDetails'],
      errorFormat: json['errorFormat'],
    );
  }
} 