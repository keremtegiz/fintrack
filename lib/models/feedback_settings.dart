import 'package:flutter/foundation.dart';

class FeedbackSettings {
  final bool allowCrashReports;
  final bool allowAnalytics;
  final bool allowUsageData;
  final bool allowFeatureRequests;
  final bool allowBugReports;
  final bool allowFeedback;
  final String feedbackEmail;
  final String feedbackUrl;

  FeedbackSettings({
    this.allowCrashReports = true,
    this.allowAnalytics = true,
    this.allowUsageData = true,
    this.allowFeatureRequests = true,
    this.allowBugReports = true,
    this.allowFeedback = true,
    this.feedbackEmail = 'feedback@fintrack.com',
    this.feedbackUrl = 'https://feedback.fintrack.com',
  });

  Map<String, dynamic> toJson() {
    return {
      'allowCrashReports': allowCrashReports,
      'allowAnalytics': allowAnalytics,
      'allowUsageData': allowUsageData,
      'allowFeatureRequests': allowFeatureRequests,
      'allowBugReports': allowBugReports,
      'allowFeedback': allowFeedback,
      'feedbackEmail': feedbackEmail,
      'feedbackUrl': feedbackUrl,
    };
  }

  factory FeedbackSettings.fromJson(Map<String, dynamic> json) {
    return FeedbackSettings(
      allowCrashReports: json['allowCrashReports'],
      allowAnalytics: json['allowAnalytics'],
      allowUsageData: json['allowUsageData'],
      allowFeatureRequests: json['allowFeatureRequests'],
      allowBugReports: json['allowBugReports'],
      allowFeedback: json['allowFeedback'],
      feedbackEmail: json['feedbackEmail'],
      feedbackUrl: json['feedbackUrl'],
    );
  }
} 