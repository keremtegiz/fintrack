import 'package:flutter/foundation.dart';

class NotificationSettings {
  final bool budgetAlerts;
  final bool goalReminders;
  final bool billReminders;
  final bool weeklyReports;
  final bool monthlyReports;
  final String notificationTime;

  NotificationSettings({
    this.budgetAlerts = true,
    this.goalReminders = true,
    this.billReminders = true,
    this.weeklyReports = true,
    this.monthlyReports = true,
    this.notificationTime = '09:00',
  });

  Map<String, dynamic> toJson() {
    return {
      'budgetAlerts': budgetAlerts,
      'goalReminders': goalReminders,
      'billReminders': billReminders,
      'weeklyReports': weeklyReports,
      'monthlyReports': monthlyReports,
      'notificationTime': notificationTime,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      budgetAlerts: json['budgetAlerts'],
      goalReminders: json['goalReminders'],
      billReminders: json['billReminders'],
      weeklyReports: json['weeklyReports'],
      monthlyReports: json['monthlyReports'],
      notificationTime: json['notificationTime'],
    );
  }
} 