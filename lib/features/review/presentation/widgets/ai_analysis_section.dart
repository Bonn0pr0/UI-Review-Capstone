import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/ai_finding.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/severity_badge.dart';
import '../../providers/review_provider.dart';

class AIAnalysisSection extends ConsumerWidget {
  const AIAnalysisSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(reviewProvider);
    final reviewNotifier = ref.read(reviewProvider.notifier);

    final criticalFindings = reviewState.findings.where((f) => f.severity == FindingSeverity.critical).toList();
    final warningFindings = reviewState.findings.where((f) => f.severity == FindingSeverity.warning).toList();
    final suggestionFindings = reviewState.findings.where((f) => f.severity == FindingSeverity.suggestion).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Review Header & Trigger
        CustomCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Document Evaluation',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textHeading,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Deep learning audit for academic & technical rigor',
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (reviewState.aiStatus != AIAnalysisStatus.analyzing)
                    ElevatedButton.icon(
                      onPressed: () => reviewNotifier.runAIAnalysis(),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(reviewState.findings.isEmpty ? 'Run AI Review' : 'Re-run AI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                ],
              ),

              // Analysis in progress indicator
              if (reviewState.aiStatus == AIAnalysisStatus.analyzing) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              reviewState.aiStepLabel,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          Text(
                            '${(reviewState.aiProgress * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: reviewState.aiProgress,
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Mandatory Disclaimer Pill
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textBody),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI output is advisory. Reviewer judgment is final.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Findings List grouped by severity
        if (reviewState.findings.isEmpty && reviewState.aiStatus != AIAnalysisStatus.analyzing)
          CustomCard(
            padding: const EdgeInsets.all(28),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.document_scanner_outlined, size: 40, color: AppColors.textMuted),
                  const SizedBox(height: 10),
                  Text(
                    'No AI Analysis Generated Yet',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Click "Run AI Review" above to automatically scan for citations, formula rigor, and methodological clarity.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          )
        else ...[
          // Summary findings tally
          Row(
            children: [
              Expanded(
                child: Text(
                  'Identified Findings (${reviewState.findings.length})',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeading,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildSeverityCountChip(FindingSeverity.critical, criticalFindings.length),
              const SizedBox(width: 6),
              _buildSeverityCountChip(FindingSeverity.warning, warningFindings.length),
              const SizedBox(width: 6),
              _buildSeverityCountChip(FindingSeverity.suggestion, suggestionFindings.length),
            ],
          ),
          const SizedBox(height: 12),

          // Group 1: Critical Findings
          if (criticalFindings.isNotEmpty) ...[
            ...criticalFindings.map((finding) => _buildFindingCard(context, ref, finding)),
          ],

          // Group 2: Warning Findings
          if (warningFindings.isNotEmpty) ...[
            ...warningFindings.map((finding) => _buildFindingCard(context, ref, finding)),
          ],

          // Group 3: Suggestion Findings
          if (suggestionFindings.isNotEmpty) ...[
            ...suggestionFindings.map((finding) => _buildFindingCard(context, ref, finding)),
          ],
        ],
      ],
    );
  }

  Widget _buildSeverityCountChip(FindingSeverity severity, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: severity.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severity.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(severity.icon, size: 12, color: severity.color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: severity.color),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingCard(BuildContext context, WidgetRef ref, AIFinding finding) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: finding.isAccepted
              ? AppColors.successBorder
              : (finding.isIgnored ? AppColors.border : finding.severity.borderColor),
          width: finding.isAccepted ? 1.5 : 1,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Finding Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: finding.isAccepted
                  ? AppColors.successLight
                  : (finding.isIgnored ? const Color(0xFFF8FAFC) : finding.severity.backgroundColor.withValues(alpha: 0.5)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              border: Border(
                bottom: BorderSide(
                  color: finding.isAccepted ? AppColors.successBorder : AppColors.border,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SeverityBadge(severity: finding.severity, isCompact: true),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        'Page ${finding.pageNumber}',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textBody),
                      ),
                    ),
                  ],
                ),

                // Accepted / Ignored Status Pills
                if (finding.isAccepted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Accepted',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                else if (finding.isIgnored)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility_off_outlined, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Dismissed',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Finding Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  finding.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 8),

                // Quoted Reference Text
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      border: Border(
                        left: BorderSide(color: finding.severity.color, width: 3),
                        top: const BorderSide(color: AppColors.border),
                        right: const BorderSide(color: AppColors.border),
                        bottom: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Text(
                      finding.referenceText,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textBody,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // AI Suggestion
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        finding.suggestion,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textHeading,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                // Action Buttons: Accept / Ignore
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => ref.read(reviewProvider.notifier).toggleIgnoreFinding(finding.id),
                      icon: Icon(
                        finding.isIgnored ? Icons.undo_rounded : Icons.close_rounded,
                        size: 14,
                        color: AppColors.textBody,
                      ),
                      label: Text(
                        finding.isIgnored ? 'Undo Dismiss' : 'Ignore',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textBody),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => ref.read(reviewProvider.notifier).toggleAcceptFinding(finding.id),
                      icon: Icon(
                        finding.isAccepted ? Icons.check_circle_rounded : Icons.check_rounded,
                        size: 14,
                        color: finding.isAccepted ? Colors.white : AppColors.success,
                      ),
                      label: Text(
                        finding.isAccepted ? 'Accepted' : 'Accept Finding',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: finding.isAccepted ? Colors.white : AppColors.success,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: finding.isAccepted ? AppColors.success : AppColors.successLight,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                            color: finding.isAccepted ? AppColors.success : AppColors.successBorder,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
