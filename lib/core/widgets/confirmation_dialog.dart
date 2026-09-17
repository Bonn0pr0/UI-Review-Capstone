import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum ConfirmationType {
  approve,
  requestRevision,
  destructive,
}

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final ConfirmationType type;
  final Widget? extraContent;
  final Future<void> Function()? onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.type = ConfirmationType.approve,
    this.extraContent,
    this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    ConfirmationType type = ConfirmationType.approve,
    Widget? extraContent,
    Future<void> Function()? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        type: type,
        extraContent: extraContent,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool _isLoading = false;

  Color get _accentColor {
    switch (widget.type) {
      case ConfirmationType.approve:
        return AppColors.success;
      case ConfirmationType.requestRevision:
        return AppColors.warning;
      case ConfirmationType.destructive:
        return AppColors.error;
    }
  }

  Color get _accentLightColor {
    switch (widget.type) {
      case ConfirmationType.approve:
        return AppColors.successLight;
      case ConfirmationType.requestRevision:
        return AppColors.warningLight;
      case ConfirmationType.destructive:
        return AppColors.errorLight;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case ConfirmationType.approve:
        return Icons.check_circle_outline_rounded;
      case ConfirmationType.requestRevision:
        return Icons.published_with_changes_rounded;
      case ConfirmationType.destructive:
        return Icons.warning_amber_rounded;
    }
  }

  Future<void> _handleConfirm() async {
    if (widget.onConfirm != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onConfirm!();
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      backgroundColor: AppColors.surface,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _accentLightColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _accentColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _icon,
                    color: _accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textHeading,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Review Evaluation Confirmation',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.textMuted,
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                widget.message,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textBody,
                  height: 1.5,
                ),
              ),
            ),
            if (widget.extraContent != null) ...[
              const SizedBox(height: 16),
              widget.extraContent!,
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(widget.cancelLabel),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_icon, size: 16, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(widget.confirmLabel),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
