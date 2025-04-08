import 'package:flutter/foundation.dart';

class HelpSettings {
  final bool showTutorials;
  final bool showTooltips;
  final bool showHints;
  final String language;
  final String theme;
  final String fontSize;
  final bool highContrast;
  final bool screenReader;
  final String helpCenterUrl;

  HelpSettings({
    this.showTutorials = true,
    this.showTooltips = true,
    this.showHints = true,
    this.language = 'en',
    this.theme = 'light',
    this.fontSize = 'medium',
    this.highContrast = false,
    this.screenReader = false,
    this.helpCenterUrl = 'https://help.fintrack.com',
  });

  Map<String, dynamic> toJson() {
    return {
      'showTutorials': showTutorials,
      'showTooltips': showTooltips,
      'showHints': showHints,
      'language': language,
      'theme': theme,
      'fontSize': fontSize,
      'highContrast': highContrast,
      'screenReader': screenReader,
      'helpCenterUrl': helpCenterUrl,
    };
  }

  factory HelpSettings.fromJson(Map<String, dynamic> json) {
    return HelpSettings(
      showTutorials: json['showTutorials'],
      showTooltips: json['showTooltips'],
      showHints: json['showHints'],
      language: json['language'],
      theme: json['theme'],
      fontSize: json['fontSize'],
      highContrast: json['highContrast'],
      screenReader: json['screenReader'],
      helpCenterUrl: json['helpCenterUrl'],
    );
  }
} 