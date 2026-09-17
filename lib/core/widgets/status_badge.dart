import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project.dart';

class StatusBadge extends StatelessWidget {
  final DocumentStatus status;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: status.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            status.icon,
            size: isCompact ? 13 : 15,
            color: status.color,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              status.label,
              style: GoogleFonts.inter(
                fontSize: isCompact ? 11 : 12,
                fontWeight: FontWeight.w600,
                color: status.color,
                height: 1.1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
