import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/project.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../projects/providers/project_provider.dart';
import '../../../shell/providers/navigation_provider.dart';
import '../../providers/review_provider.dart';

class DecisionBar extends ConsumerWidget {
  final ProjectDocument document;

  const DecisionBar({
    super.key,
    required this.document,
  });

  Future<void> _handleApprove(BuildContext context, WidgetRef ref) async {
    final reviewState = ref.read(reviewProvider);

    final confirmed = await ConfirmationDialog.show(
      context: context,
      type: ConfirmationType.approve,
      title: 'Approve Capstone Document?',
      message:
          'Are you sure you want to approve "${document.projectName}" with an evaluation score of ${reviewState.score}/100? This status will be published to the academic portal.',
      confirmLabel: 'Confirm Approval',
      extraContent: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.successBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 6),
                Text(
                  'Final Score: ${reviewState.score}/100',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                ),
              ],
            ),
            if (reviewState.manualComments.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Reviewer Remarks: "${reviewState.manualComments}"',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textBody, fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
      onConfirm: () async {
        await Future.delayed(const Duration(milliseconds: 600));
        ref.read(projectProvider.notifier).updateDocumentReview(
              documentId: document.id,
              newStatus: DocumentStatus.approved,
              score: reviewState.score,
              comments: reviewState.manualComments,
            );
      },
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Document "${document.projectName}" has been approved!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
    }
  }

  Future<void> _handleRequestRevision(BuildContext context, WidgetRef ref) async {
    final reviewState = ref.read(reviewProvider);

    final confirmed = await ConfirmationDialog.show(
      context: context,
      type: ConfirmationType.requestRevision,
      title: 'Request Revisions from Group?',
      message:
          'This will return "${document.projectName}" (${document.version}) to the student team with your required amendments and AI findings.',
      confirmLabel: 'Send Revision Request',
      extraContent: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.warningBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: 6),
                Text(
                  'Pending Revisions Required',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.warning),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'A resubmission link will be emailed to: ${document.studentMembers.join(', ')}',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textBody),
            ),
          ],
        ),
      ),
      onConfirm: () async {
        await Future.delayed(const Duration(milliseconds: 600));
        ref.read(projectProvider.notifier).updateDocumentReview(
              documentId: document.id,
              newStatus: DocumentStatus.revisionNeeded,
              score: reviewState.score,
              comments: reviewState.manualComments,
            );
      },
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.published_with_changes_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Revision request dispatched to ${document.groupName}'),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Save draft
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review draft comments and rubrics autosaved.'),
                  backgroundColor: AppColors.textHeading,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            child: const Icon(Icons.save_outlined, size: 16),
          ),
          const SizedBox(width: 8),

          // Request Revision (Amber)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleRequestRevision(context, ref),
              icon: const Icon(Icons.published_with_changes_rounded, size: 14),
              label: Text(
                'Request Revision',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Approve (Green)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleApprove(context, ref),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
              label: Text(
                'Approve Document',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
