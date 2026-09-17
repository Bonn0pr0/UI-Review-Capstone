import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/project.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/utils/responsive.dart';
import '../../shell/providers/navigation_provider.dart';
import '../providers/project_provider.dart';
import 'widgets/import_document_dialog.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProjects = ref.watch(filteredProjectsProvider);
    final filterState = ref.watch(projectFilterProvider);
    final projectState = ref.watch(projectProvider);
    final filterNotifier = ref.read(projectFilterProvider.notifier);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capstone Projects',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textHeading,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Submissions, versions & evaluation statuses',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textBody,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => ImportDocumentDialog.show(context),
                  icon: const Icon(Icons.upload_rounded, size: 16),
                  label: Text(isMobile ? 'Import' : 'Import Document'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Search & Filter Toolbar
            CustomCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (val) => filterNotifier.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search projects, groups, or files...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
                      suffixIcon: filterState.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              onPressed: () => filterNotifier.setSearchQuery(''),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      fillColor: AppColors.background,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Status Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'All (${projectState.documents.length})',
                          isSelected: filterState.statusFilter == null,
                          onTap: () => filterNotifier.setStatusFilter(null),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Pending',
                          icon: DocumentStatus.pending.icon,
                          color: DocumentStatus.pending.color,
                          isSelected: filterState.statusFilter == DocumentStatus.pending,
                          onTap: () => filterNotifier.setStatusFilter(DocumentStatus.pending),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'In Review',
                          icon: DocumentStatus.inReview.icon,
                          color: DocumentStatus.inReview.color,
                          isSelected: filterState.statusFilter == DocumentStatus.inReview,
                          onTap: () => filterNotifier.setStatusFilter(DocumentStatus.inReview),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Approved',
                          icon: DocumentStatus.approved.icon,
                          color: DocumentStatus.approved.color,
                          isSelected: filterState.statusFilter == DocumentStatus.approved,
                          onTap: () => filterNotifier.setStatusFilter(DocumentStatus.approved),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Need Revision',
                          icon: DocumentStatus.revisionNeeded.icon,
                          color: DocumentStatus.revisionNeeded.color,
                          isSelected: filterState.statusFilter == DocumentStatus.revisionNeeded,
                          onTap: () => filterNotifier.setStatusFilter(DocumentStatus.revisionNeeded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Responsive Data View: Mobile Cards or Desktop Table
            if (filteredProjects.isEmpty)
              CustomCard(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted.withValues(alpha: 0.5)),
                      const SizedBox(height: 10),
                      Text(
                        'No matching documents found',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try clearing search keywords or status filter',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else if (isMobile)
              // Mobile Card List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProjects.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doc = filteredProjects[index];
                  return CustomCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () => ref.read(navigationProvider.notifier).openReviewWorkspace(doc.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.errorLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.projectName,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textHeading,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc.groupName,
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    doc.version,
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  doc.shortDate,
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            StatusBadge(status: doc.status, isCompact: true),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              // Desktop Data Table
              CustomCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        border: Border(bottom: BorderSide(color: AppColors.border)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'PROJECT & CATEGORY',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'GROUP / AUTHORS',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'DOCUMENT & VERSION',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'SUBMITTED',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'STATUS',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(
                            width: 120,
                            child: Text(
                              'ACTIONS',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProjects.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final doc = filteredProjects[index];
                        return _buildTableRow(context, ref, doc);
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? AppColors.primary : (color ?? AppColors.textBody)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryDark : AppColors.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, WidgetRef ref, ProjectDocument doc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.projectName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHeading,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    doc.category,
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textBody, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.groupName,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                ),
                const SizedBox(height: 2),
                Text(
                  doc.studentMembers.join(', '),
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.documentTitle,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textHeading),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              doc.version,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${doc.pageCount} pages • ${doc.fileSize}',
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              doc.shortDate,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textBody),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: doc.status),
            ),
          ),
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(navigationProvider.notifier).openReviewWorkspace(doc.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rate_review_outlined, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Review',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
