import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/project.dart';
import '../../../../core/models/ai_finding.dart';
import '../../../../core/widgets/severity_badge.dart';
import '../../providers/review_provider.dart';

class DocumentViewerPane extends ConsumerWidget {
  final ProjectDocument document;

  const DocumentViewerPane({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(reviewProvider);
    final reviewNotifier = ref.read(reviewProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9), // Subtle canvas background for document
        border: Border(
          right: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Document Viewer Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                // Document Icon & Title
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.documentTitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHeading,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${document.projectName} • ${document.version}',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Outline Toggle
                IconButton(
                  onPressed: () => reviewNotifier.toggleSidebarOutline(),
                  icon: Icon(
                    reviewState.isSidebarOutlineOpen ? Icons.view_sidebar_rounded : Icons.view_sidebar_outlined,
                    size: 19,
                    color: reviewState.isSidebarOutlineOpen ? AppColors.primary : AppColors.textBody,
                  ),
                  tooltip: 'Toggle Document Outline',
                ),
                const SizedBox(width: 4),

                // Page Navigation Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: reviewState.currentPage > 1
                            ? () => reviewNotifier.setCurrentPage(reviewState.currentPage - 1)
                            : null,
                        icon: const Icon(Icons.chevron_left_rounded, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                      ),
                      Text(
                        'Page ${reviewState.currentPage} of ${document.pageCount}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHeading,
                        ),
                      ),
                      IconButton(
                        onPressed: reviewState.currentPage < document.pageCount
                            ? () => reviewNotifier.setCurrentPage(reviewState.currentPage + 1)
                            : null,
                        icon: const Icon(Icons.chevron_right_rounded, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Zoom Controls
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: reviewState.zoomLevel > 0.6
                            ? () => reviewNotifier.setZoomLevel(reviewState.zoomLevel - 0.1)
                            : null,
                        icon: const Icon(Icons.remove_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                        tooltip: 'Zoom Out',
                      ),
                      Text(
                        '${(reviewState.zoomLevel * 100).toInt()}%',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                      ),
                      IconButton(
                        onPressed: reviewState.zoomLevel < 1.8
                            ? () => reviewNotifier.setZoomLevel(reviewState.zoomLevel + 0.1)
                            : null,
                        icon: const Icon(Icons.add_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                        tooltip: 'Zoom In',
                      ),
                      IconButton(
                        onPressed: () => reviewNotifier.setZoomLevel(1.0),
                        icon: const Icon(Icons.fit_screen_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                        tooltip: 'Reset Zoom (100%)',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Canvas with Document & Optional Outline Sidebar
          Expanded(
            child: Row(
              children: [
                // Outline sidebar (collapsible)
                if (reviewState.isSidebarOutlineOpen)
                  Container(
                    width: 180,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(right: BorderSide(color: AppColors.border)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'SECTIONS',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            children: [
                              _buildOutlineItem(
                                title: 'Abstract & Scope',
                                page: 1,
                                isSelected: reviewState.currentPage == 1,
                                onTap: () => reviewNotifier.setCurrentPage(1),
                              ),
                              _buildOutlineItem(
                                title: '1. Introduction',
                                page: 1,
                                isSelected: reviewState.currentPage == 1,
                                onTap: () => reviewNotifier.setCurrentPage(1),
                              ),
                              _buildOutlineItem(
                                title: '2. System Architecture',
                                page: 2,
                                isSelected: reviewState.currentPage == 2,
                                hasWarning: true,
                                onTap: () => reviewNotifier.setCurrentPage(2),
                              ),
                              _buildOutlineItem(
                                title: '3. Benchmarks & Validation',
                                page: 3,
                                isSelected: reviewState.currentPage == 3,
                                hasWarning: true,
                                onTap: () => reviewNotifier.setCurrentPage(3),
                              ),
                              _buildOutlineItem(
                                title: '4. Conclusion & Future Work',
                                page: 4,
                                isSelected: reviewState.currentPage == 4,
                                onTap: () => reviewNotifier.setCurrentPage(4),
                              ),
                              _buildOutlineItem(
                                title: '5. References & Appendices',
                                page: 5,
                                isSelected: reviewState.currentPage == 5,
                                onTap: () => reviewNotifier.setCurrentPage(5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Simulated Document Page Canvas
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      child: Transform.scale(
                        scale: reviewState.zoomLevel,
                        alignment: Alignment.topCenter,
                        child: _buildDocumentSheet(context, reviewState, document),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineItem({
    required String title,
    required int page,
    required bool isSelected,
    bool hasWarning = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryDark : AppColors.textHeading,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasWarning)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              'p.$page',
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSheet(BuildContext context, ReviewState reviewState, ProjectDocument doc) {
    return Container(
      width: 680,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'CAPSTONE FINAL DEFENSE MANUSCRIPT',
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'IEEE TEMPLATE FORMAT',
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(thickness: 1.5, color: AppColors.textDark),
          const SizedBox(height: 18),

          // Title
          Text(
            doc.projectName,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textHeading,
              letterSpacing: -0.3,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Authors
          Text(
            '${doc.groupName} • ${doc.studentMembers.join(', ')}',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            'Faculty Advisor: Prof. Jason Myers • Academic Year 2025-2026',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Abstract Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABSTRACT',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textHeading, letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  doc.abstractText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textBody,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Simulated Text Content with AI Highlight Pins
          Text(
            doc.fullMockContent,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textDark,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 24),

          // Highlighted Finding Callout Annotation in Document (Interactive AI finding sync)
          if (reviewState.findings.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2), // soft red highlight box
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECDD3), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SeverityBadge(severity: FindingSeverity.critical, isCompact: true),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'AI Flagged Annotation [Finding #1]',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '“Point clouds are filtered through a voxel grid with a leaf size of 0.05m before scan-to-map registration without explicit observability bounds.”',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading,
                      backgroundColor: const Color(0xFFFEE2E2),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Recommendation: Include covariance convergence proofs in Chapter 2.2 before approving final manuscript.',
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.error),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Footer
          const Divider(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Department of Computer Science & Engineering',
                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Page ${reviewState.currentPage} of ${doc.pageCount}',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
