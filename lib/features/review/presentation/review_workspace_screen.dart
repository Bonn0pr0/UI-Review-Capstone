import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/project.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/status_badge.dart';
import '../../projects/providers/project_provider.dart';
import '../../shell/providers/navigation_provider.dart';
import '../providers/review_provider.dart';
import 'widgets/document_viewer_pane.dart';
import 'widgets/ai_analysis_section.dart';
import 'widgets/manual_review_section.dart';
import 'widgets/decision_bar.dart';

class ReviewWorkspaceScreen extends ConsumerStatefulWidget {
  final String? documentId;

  const ReviewWorkspaceScreen({
    super.key,
    this.documentId,
  });

  @override
  ConsumerState<ReviewWorkspaceScreen> createState() => _ReviewWorkspaceScreenState();
}

class _ReviewWorkspaceScreenState extends ConsumerState<ReviewWorkspaceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final docId = widget.documentId ?? ref.read(navigationProvider).activeDocumentId ?? 'DOC-2026-001';
      ref.read(reviewProvider.notifier).setDocument(docId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final navState = ref.watch(navigationProvider);
    final isMobile = Responsive.isMobile(context);

    final targetDocId = widget.documentId ?? navState.activeDocumentId ?? 'DOC-2026-001';
    final document = projectState.documents.firstWhere(
      (doc) => doc.id == targetDocId,
      orElse: () => projectState.documents.first,
    );

    final reviewState = ref.watch(reviewProvider);
    final findingsCount = reviewState.findings.length;

    if (isMobile) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: () => ref.read(navigationProvider.notifier).setTab(NavigationTab.projects),
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              tooltip: 'Quay lại danh sách',
              color: AppColors.textHeading,
            ),
            titleSpacing: 0,
            title: InkWell(
              onTap: () => _showDocumentSelectorSheet(context, projectState.documents, document.id),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.projectName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textHeading,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${document.id} (${document.version})',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: StatusBadge(status: document.status),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                  tabs: [
                    const Tab(
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined, size: 16),
                          SizedBox(width: 6),
                          Text('Văn bản'),
                        ],
                      ),
                    ),
                    Tab(
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 16),
                          const SizedBox(width: 6),
                          const Text('Đánh giá & AI'),
                          if (findingsCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$findingsCount',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1: Document Viewer Pane (Mobile-friendly layout)
              DocumentViewerPane(document: document),

              // Tab 2: AI Analysis & Manual Review
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          AIAnalysisSection(),
                          SizedBox(height: 14),
                          ManualReviewSection(),
                          SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                  DecisionBar(document: document),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Desktop / Tablet Layout (> 768px)
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Workspace Navigation Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Row(
              children: [
                // Back Button
                IconButton(
                  onPressed: () => ref.read(navigationProvider.notifier).setTab(NavigationTab.projects),
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  tooltip: 'Return to Projects List',
                  color: AppColors.textBody,
                ),
                const SizedBox(width: 8),

                // Breadcrumb & Project Info
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Projects',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          document.projectName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeading,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Status Badge
                StatusBadge(status: document.status),
                const SizedBox(width: 12),

                // Document Selector Switcher Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: document.id,
                      icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.primary),
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textHeading, fontWeight: FontWeight.w600),
                      items: projectState.documents.map((doc) {
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text('Switch: ${doc.id} (${doc.version})'),
                        );
                      }).toList(),
                      onChanged: (newId) {
                        if (newId != null) {
                          ref.read(navigationProvider.notifier).openReviewWorkspace(newId);
                          ref.read(reviewProvider.notifier).setDocument(newId);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Core 60 / 40 Split View
          Expanded(
            child: Row(
              children: [
                // Left Pane (60% Width): Interactive Document Viewer
                Expanded(
                  flex: 6,
                  child: DocumentViewerPane(document: document),
                ),

                // Right Pane (40% Width): AI Analysis, Manual Review & Decision
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      // Scrollable Review Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              // AI Analysis Section
                              AIAnalysisSection(),
                              SizedBox(height: 20),

                              // Manual Evaluation Section
                              ManualReviewSection(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // Sticky Decision Action Bar (Approve / Request Revision)
                      DecisionBar(document: document),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentSelectorSheet(
    BuildContext context,
    List<ProjectDocument> documents,
    String currentDocId,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Chọn tài liệu cần thẩm định',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: 12),
              ...documents.map((doc) {
                final isSelected = doc.id == currentDocId;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    leading: Icon(
                      Icons.description_rounded,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                      size: 22,
                    ),
                    title: Text(
                      doc.projectName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? AppColors.primaryDark : AppColors.textHeading,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${doc.id} • ${doc.version} • ${doc.groupName}',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                        : const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                    onTap: () {
                      ref.read(navigationProvider.notifier).openReviewWorkspace(doc.id);
                      ref.read(reviewProvider.notifier).setDocument(doc.id);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
