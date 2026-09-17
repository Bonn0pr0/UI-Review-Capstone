import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

enum DocumentStatus {
  pending,
  inReview,
  approved,
  revisionNeeded,
  rejected,
}

extension DocumentStatusExtension on DocumentStatus {
  String get label {
    switch (this) {
      case DocumentStatus.pending:
        return 'Pending Review';
      case DocumentStatus.inReview:
        return 'In Review';
      case DocumentStatus.approved:
        return 'Approved';
      case DocumentStatus.revisionNeeded:
        return 'Needs Revision';
      case DocumentStatus.rejected:
        return 'Rejected';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentStatus.pending:
        return Icons.hourglass_top_rounded;
      case DocumentStatus.inReview:
        return Icons.rate_review_outlined;
      case DocumentStatus.approved:
        return Icons.check_circle_rounded;
      case DocumentStatus.revisionNeeded:
        return Icons.warning_amber_rounded;
      case DocumentStatus.rejected:
        return Icons.cancel_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DocumentStatus.pending:
        return AppColors.pending;
      case DocumentStatus.inReview:
        return AppColors.primary;
      case DocumentStatus.approved:
        return AppColors.success;
      case DocumentStatus.revisionNeeded:
        return AppColors.warning;
      case DocumentStatus.rejected:
        return AppColors.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case DocumentStatus.pending:
        return AppColors.pendingLight;
      case DocumentStatus.inReview:
        return AppColors.primaryLight;
      case DocumentStatus.approved:
        return AppColors.successLight;
      case DocumentStatus.revisionNeeded:
        return AppColors.warningLight;
      case DocumentStatus.rejected:
        return AppColors.errorLight;
    }
  }

  Color get borderColor {
    switch (this) {
      case DocumentStatus.pending:
        return AppColors.pendingBorder;
      case DocumentStatus.inReview:
        return AppColors.primary.withValues(alpha: 0.3);
      case DocumentStatus.approved:
        return AppColors.successBorder;
      case DocumentStatus.revisionNeeded:
        return AppColors.warningBorder;
      case DocumentStatus.rejected:
        return AppColors.errorBorder;
    }
  }
}

class ProjectDocument {
  final String id;
  final String projectName;
  final String groupName;
  final String documentTitle;
  final String version;
  final DateTime submissionDate;
  DocumentStatus status;
  int? score;
  String? reviewerComments;
  final int pageCount;
  final String fileSize;
  final String category;
  final List<String> studentMembers;
  final String abstractText;
  final String fullMockContent;

  ProjectDocument({
    required this.id,
    required this.projectName,
    required this.groupName,
    required this.documentTitle,
    required this.version,
    required this.submissionDate,
    required this.status,
    this.score,
    this.reviewerComments,
    required this.pageCount,
    required this.fileSize,
    required this.category,
    required this.studentMembers,
    required this.abstractText,
    required this.fullMockContent,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy • HH:mm').format(submissionDate);
  String get shortDate => DateFormat('MMM dd, yyyy').format(submissionDate);

  ProjectDocument copyWith({
    String? id,
    String? projectName,
    String? groupName,
    String? documentTitle,
    String? version,
    DateTime? submissionDate,
    DocumentStatus? status,
    int? score,
    String? reviewerComments,
    int? pageCount,
    String? fileSize,
    String? category,
    List<String>? studentMembers,
    String? abstractText,
    String? fullMockContent,
  }) {
    return ProjectDocument(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      groupName: groupName ?? this.groupName,
      documentTitle: documentTitle ?? this.documentTitle,
      version: version ?? this.version,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status,
      score: score ?? this.score,
      reviewerComments: reviewerComments ?? this.reviewerComments,
      pageCount: pageCount ?? this.pageCount,
      fileSize: fileSize ?? this.fileSize,
      category: category ?? this.category,
      studentMembers: studentMembers ?? this.studentMembers,
      abstractText: abstractText ?? this.abstractText,
      fullMockContent: fullMockContent ?? this.fullMockContent,
    );
  }
}
