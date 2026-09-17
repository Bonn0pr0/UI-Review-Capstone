import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'project.dart';

class ActivityItem {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final String documentTitle;
  final String user;
  final DateTime timestamp;
  final DocumentStatus status;
  final IconData icon;

  ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.documentTitle,
    required this.user,
    required this.timestamp,
    required this.status,
    required this.icon,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
