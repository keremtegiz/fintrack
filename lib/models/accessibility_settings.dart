import 'package:flutter/foundation.dart';

class AccessibilitySettings {
  final bool screenReader;
  final bool highContrast;
  final bool largeText;
  final bool reduceMotion;
  final bool reduceTransparency;
  final bool invertColors;
  final bool boldText;
  final bool increaseTouchTargets;
  final bool showTapFeedback;
  final bool useSystemFont;
  final String fontSize;
  final String colorScheme;
  final String contrastRatio;
  final bool useCustomFont;
  final String customFont;
  final bool useCustomColors;
  final Map<String, String> customColors;
  final bool useCustomSpacing;
  final double customSpacing;
  final bool useCustomIcons;
  final String iconStyle;
  final bool useCustomAnimations;
  final String animationStyle;

  AccessibilitySettings({
    this.screenReader = false,
    this.highContrast = false,
    this.largeText = false,
    this.reduceMotion = false,
    this.reduceTransparency = false,
    this.invertColors = false,
    this.boldText = false,
    this.increaseTouchTargets = false,
    this.showTapFeedback = true,
    this.useSystemFont = true,
    this.fontSize = 'medium',
    this.colorScheme = 'default',
    this.contrastRatio = 'normal',
    this.useCustomFont = false,
    this.customFont = '',
    this.useCustomColors = false,
    this.customColors = const {},
    this.useCustomSpacing = false,
    this.customSpacing = 1.0,
    this.useCustomIcons = false,
    this.iconStyle = 'default',
    this.useCustomAnimations = false,
    this.animationStyle = 'default',
  });

  Map<String, dynamic> toJson() {
    return {
      'screenReader': screenReader,
      'highContrast': highContrast,
      'largeText': largeText,
      'reduceMotion': reduceMotion,
      'reduceTransparency': reduceTransparency,
      'invertColors': invertColors,
      'boldText': boldText,
      'increaseTouchTargets': increaseTouchTargets,
      'showTapFeedback': showTapFeedback,
      'useSystemFont': useSystemFont,
      'fontSize': fontSize,
      'colorScheme': colorScheme,
      'contrastRatio': contrastRatio,
      'useCustomFont': useCustomFont,
      'customFont': customFont,
      'useCustomColors': useCustomColors,
      'customColors': customColors,
      'useCustomSpacing': useCustomSpacing,
      'customSpacing': customSpacing,
      'useCustomIcons': useCustomIcons,
      'iconStyle': iconStyle,
      'useCustomAnimations': useCustomAnimations,
      'animationStyle': animationStyle,
    };
  }

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettings(
      screenReader: json['screenReader'],
      highContrast: json['highContrast'],
      largeText: json['largeText'],
      reduceMotion: json['reduceMotion'],
      reduceTransparency: json['reduceTransparency'],
      invertColors: json['invertColors'],
      boldText: json['boldText'],
      increaseTouchTargets: json['increaseTouchTargets'],
      showTapFeedback: json['showTapFeedback'],
      useSystemFont: json['useSystemFont'],
      fontSize: json['fontSize'],
      colorScheme: json['colorScheme'],
      contrastRatio: json['contrastRatio'],
      useCustomFont: json['useCustomFont'],
      customFont: json['customFont'],
      useCustomColors: json['useCustomColors'],
      customColors: Map<String, String>.from(json['customColors']),
      useCustomSpacing: json['useCustomSpacing'],
      customSpacing: json['customSpacing'],
      useCustomIcons: json['useCustomIcons'],
      iconStyle: json['iconStyle'],
      useCustomAnimations: json['useCustomAnimations'],
      animationStyle: json['animationStyle'],
    );
  }
} 