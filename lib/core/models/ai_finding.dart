import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum FindingSeverity {
  critical,
  warning,
  suggestion,
}

extension FindingSeverityExtension on FindingSeverity {
  String get label {
    switch (this) {
      case FindingSeverity.critical:
        return 'Critical Issue';
      case FindingSeverity.warning:
        return 'Warning';
      case FindingSeverity.suggestion:
        return 'Recommendation';
    }
  }

  IconData get icon {
    switch (this) {
      case FindingSeverity.critical:
        return Icons.error_outline_rounded;
      case FindingSeverity.warning:
        return Icons.warning_amber_rounded;
      case FindingSeverity.suggestion:
        return Icons.lightbulb_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case FindingSeverity.critical:
        return AppColors.error;
      case FindingSeverity.warning:
        return AppColors.warning;
      case FindingSeverity.suggestion:
        return AppColors.primary;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case FindingSeverity.critical:
        return AppColors.errorLight;
      case FindingSeverity.warning:
        return AppColors.warningLight;
      case FindingSeverity.suggestion:
        return AppColors.primaryLight;
    }
  }

  Color get borderColor {
    switch (this) {
      case FindingSeverity.critical:
        return AppColors.errorBorder;
      case FindingSeverity.warning:
        return AppColors.warningBorder;
      case FindingSeverity.suggestion:
        return AppColors.primary.withValues(alpha: 0.3);
    }
  }
}

class AIFinding {
  final String id;
  final String documentId;
  final FindingSeverity severity;
  final String title;
  final String referenceText;
  final String suggestion;
  final int pageNumber;
  final String category;
  bool isAccepted;
  bool isIgnored;

  AIFinding({
    required this.id,
    required this.documentId,
    required this.severity,
    required this.title,
    required this.referenceText,
    required this.suggestion,
    required this.pageNumber,
    required this.category,
    this.isAccepted = false,
    this.isIgnored = false,
  });

  AIFinding copyWith({
    String? id,
    String? documentId,
    FindingSeverity? severity,
    String? title,
    String? referenceText,
    String? suggestion,
    int? pageNumber,
    String? category,
    bool? isAccepted,
    bool? isIgnored,
  }) {
    return AIFinding(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      referenceText: referenceText ?? this.referenceText,
      suggestion: suggestion ?? this.suggestion,
      pageNumber: pageNumber ?? this.pageNumber,
      category: category ?? this.category,
      isAccepted: isAccepted ?? this.isAccepted,
      isIgnored: isIgnored ?? this.isIgnored,
    );
  }
}
