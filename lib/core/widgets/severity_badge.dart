import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ai_finding.dart';

class SeverityBadge extends StatelessWidget {
  final FindingSeverity severity;
  final bool isCompact;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 7 : 9,
        vertical: isCompact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: severity.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: severity.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            severity.icon,
            size: isCompact ? 12 : 14,
            color: severity.color,
          ),
          const SizedBox(width: 4),
          Text(
            severity.label,
            style: GoogleFonts.inter(
              fontSize: isCompact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: severity.color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
