import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/project.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/utils/responsive.dart';
import '../../auth/providers/auth_provider.dart';
import '../../shell/providers/navigation_provider.dart';
import '../../projects/providers/project_provider.dart';
import '../../projects/presentation/widgets/import_document_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final projectState = ref.watch(projectProvider);
    final isMobile = Responsive.isMobile(context);

    final pendingCount = projectState.documents.where((d) => d.status == DocumentStatus.pending).length;
    final inReviewCount = projectState.documents.where((d) => d.status == DocumentStatus.inReview).length;
    final approvedCount = projectState.documents.where((d) => d.status == DocumentStatus.approved).length;
    final revisionCount = projectState.documents.where((d) => d.status == DocumentStatus.revisionNeeded).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Welcome Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 18 : 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF0F172A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Capstone Cycle • Spring 2026',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF93C5FD),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome, ${authState.user?.name.split(' ').first ?? 'Reviewer'}',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You have $pendingCount documents awaiting review and $revisionCount pending revisions.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Action Buttons in Banner
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          final target = projectState.documents.firstWhere(
                            (d) => d.status == DocumentStatus.inReview || d.status == DocumentStatus.pending,
                            orElse: () => projectState.documents.first,
                          );
                          ref.read(navigationProvider.notifier).openReviewWorkspace(target.id);
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Start Next Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => ImportDocumentDialog.show(context),
                        icon: const Icon(Icons.upload_rounded, size: 16, color: Colors.white),
                        label: const Text('Import PDF', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF334155), width: 1.5),
                          backgroundColor: const Color(0xFF1E293B),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Summary Metric Cards (Responsive Grid / Row)
            if (isMobile)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildMetricCard(
                    title: 'Pending',
                    count: pendingCount.toString(),
                    subtitle: 'Awaiting evaluation',
                    icon: DocumentStatus.pending.icon,
                    color: DocumentStatus.pending.color,
                    lightColor: DocumentStatus.pending.backgroundColor,
                    onTap: () {
                      ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.pending);
                      ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                    },
                  ),
                  _buildMetricCard(
                    title: 'In Review',
                    count: inReviewCount.toString(),
                    subtitle: 'Drafts in progress',
                    icon: DocumentStatus.inReview.icon,
                    color: DocumentStatus.inReview.color,
                    lightColor: DocumentStatus.inReview.backgroundColor,
                    onTap: () {
                      ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.inReview);
                      ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                    },
                  ),
                  _buildMetricCard(
                    title: 'Approved',
                    count: approvedCount.toString(),
                    subtitle: 'Passed defense',
                    icon: DocumentStatus.approved.icon,
                    color: DocumentStatus.approved.color,
                    lightColor: DocumentStatus.approved.backgroundColor,
                    onTap: () {
                      ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.approved);
                      ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                    },
                  ),
                  _buildMetricCard(
                    title: 'Revision',
                    count: revisionCount.toString(),
                    subtitle: 'Returned to teams',
                    icon: DocumentStatus.revisionNeeded.icon,
                    color: DocumentStatus.revisionNeeded.color,
                    lightColor: DocumentStatus.revisionNeeded.backgroundColor,
                    onTap: () {
                      ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.revisionNeeded);
                      ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                    },
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Pending Reviews',
                      count: pendingCount.toString(),
                      subtitle: 'Awaiting evaluation',
                      icon: DocumentStatus.pending.icon,
                      color: DocumentStatus.pending.color,
                      lightColor: DocumentStatus.pending.backgroundColor,
                      onTap: () {
                        ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.pending);
                        ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'In Active Review',
                      count: inReviewCount.toString(),
                      subtitle: 'Drafts in progress',
                      icon: DocumentStatus.inReview.icon,
                      color: DocumentStatus.inReview.color,
                      lightColor: DocumentStatus.inReview.backgroundColor,
                      onTap: () {
                        ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.inReview);
                        ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Approved',
                      count: approvedCount.toString(),
                      subtitle: 'Passed benchmark',
                      icon: DocumentStatus.approved.icon,
                      color: DocumentStatus.approved.color,
                      lightColor: DocumentStatus.approved.backgroundColor,
                      onTap: () {
                        ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.approved);
                        ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Needs Revision',
                      count: revisionCount.toString(),
                      subtitle: 'Returned to teams',
                      icon: DocumentStatus.revisionNeeded.icon,
                      color: DocumentStatus.revisionNeeded.color,
                      lightColor: DocumentStatus.revisionNeeded.backgroundColor,
                      onTap: () {
                        ref.read(projectFilterProvider.notifier).setStatusFilter(DocumentStatus.revisionNeeded);
                        ref.read(navigationProvider.notifier).setTab(NavigationTab.projects);
                      },
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Two Column / Stacked Section: Priority Queue & Recent Activity
            if (isMobile) ...[
              _buildPriorityQueue(context, ref, projectState),
              const SizedBox(height: 16),
              _buildActivityLog(context, projectState),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildPriorityQueue(context, ref, projectState),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: _buildActivityLog(context, projectState),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityQueue(BuildContext context, WidgetRef ref, ProjectListState projectState) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority Evaluation Queue',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Submissions requiring reviewer action',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => ref.read(navigationProvider.notifier).setTab(NavigationTab.projects),
                child: Text(
                  'View all',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 6),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projectState.documents.take(4).length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final doc = projectState.documents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.projectName,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textHeading,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${doc.groupName} • ${doc.version}',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: doc.status, isCompact: true),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        ref.read(navigationProvider.notifier).openReviewWorkspace(doc.id);
                      },
                      icon: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.primary),
                      tooltip: 'Review',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog(BuildContext context, ProjectListState projectState) {
    return CustomCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audit & Activity Log',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Real-time timeline of submissions',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projectState.recentActivities.take(4).length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final act = projectState.recentActivities[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: act.status.backgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: act.status.borderColor),
                    ),
                    child: Icon(act.icon, size: 14, color: act.status.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                act.title,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textHeading,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              act.timeAgo,
                              style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          act.description,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textBody,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color lightColor,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBody,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textHeading,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
