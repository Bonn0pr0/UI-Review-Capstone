import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/project.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/utils/responsive.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../projects/presentation/project_list_screen.dart';
import '../../review/presentation/review_workspace_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../projects/providers/project_provider.dart';
import '../providers/navigation_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      type: ConfirmationType.destructive,
      title: 'Sign Out of Portal?',
      message: 'You will need to re-authenticate with your academic credentials to access capstone evaluations.',
      confirmLabel: 'Sign Out',
      cancelLabel: 'Stay Logged In',
    );

    if (confirmed == true) {
      ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);
    final authState = ref.watch(authProvider);
    final projectState = ref.watch(projectProvider);

    final isMobile = Responsive.isMobile(context);
    final pendingCount = projectState.documents.where((d) => d.status == DocumentStatus.pending).length;

    // Mobile Layout (Android Phone)
    if (isMobile) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fact_check_rounded, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ReviewHub',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHeading,
                    ),
                  ),
                  Text(
                    'Capstone Portal',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
              tooltip: 'Sign Out',
              onPressed: () => _handleLogout(context, ref),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _buildCurrentScreen(navState.currentTab),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navState.currentTab.index,
          onDestinationSelected: (index) {
            navNotifier.setTab(NavigationTab.values[index]);
          },
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryLight,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('${projectState.documents.length}'),
                child: const Icon(Icons.folder_open_rounded),
              ),
              selectedIcon: Badge(
                label: Text('${projectState.documents.length}'),
                child: const Icon(Icons.folder_rounded, color: AppColors.primary),
              ),
              label: 'Projects',
            ),
            NavigationDestination(
              icon: pendingCount > 0
                  ? Badge(
                      label: Text('$pendingCount'),
                      backgroundColor: AppColors.pending,
                      child: const Icon(Icons.rate_review_outlined),
                    )
                  : const Icon(Icons.rate_review_outlined),
              selectedIcon: const Icon(Icons.rate_review_rounded, color: AppColors.primary),
              label: 'Reviews',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded, color: AppColors.primary),
              label: 'Settings',
            ),
          ],
        ),
      );
    }

    // Desktop / Web Layout (> 768px)
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Persistent Sidebar / Navigation Rail
          Container(
            width: 250,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                right: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Branding Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.fact_check_rounded,
                          size: 22,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ReviewHub',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textHeading,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Capstone Portal',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Navigation Menu Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'MAIN NAVIGATION',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                _buildNavItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: navState.currentTab == NavigationTab.dashboard,
                  onTap: () => navNotifier.setTab(NavigationTab.dashboard),
                ),
                _buildNavItem(
                  icon: Icons.folder_open_rounded,
                  activeIcon: Icons.folder_rounded,
                  label: 'Projects & Docs',
                  badgeCount: projectState.documents.length,
                  isSelected: navState.currentTab == NavigationTab.projects,
                  onTap: () => navNotifier.setTab(NavigationTab.projects),
                ),
                _buildNavItem(
                  icon: Icons.rate_review_outlined,
                  activeIcon: Icons.rate_review_rounded,
                  label: 'Review Workspace',
                  badgeCount: pendingCount > 0 ? pendingCount : null,
                  badgeColor: AppColors.pending,
                  isSelected: navState.currentTab == NavigationTab.reviews,
                  onTap: () => navNotifier.setTab(NavigationTab.reviews),
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: navState.currentTab == NavigationTab.settings,
                  onTap: () => navNotifier.setTab(NavigationTab.settings),
                ),

                const Spacer(),

                // Bottom User Profile Card & Logout
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // User Info Pill
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                authState.user?.name.split(' ').map((n) => n[0]).take(2).join('') ?? 'SV',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authState.user?.name ?? 'Dr. Sarah Vance',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textHeading,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Faculty Reviewer',
                                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Logout Button
                      InkWell(
                        onTap: () => _handleLogout(context, ref),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
                              const SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: _buildCurrentScreen(navState.currentTab),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
    Color? badgeColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: AppColors.surfaceHover,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.sidebarActiveBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 18,
                  color: isSelected ? AppColors.primary : AppColors.textBody,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textHeading,
                    ),
                  ),
                ),
                if (badgeCount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (badgeColor ?? AppColors.textMuted.withValues(alpha: 0.15)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textHeading,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(NavigationTab currentTab) {
    switch (currentTab) {
      case NavigationTab.dashboard:
        return const DashboardScreen();
      case NavigationTab.projects:
        return const ProjectListScreen();
      case NavigationTab.reviews:
        return const ReviewWorkspaceScreen();
      case NavigationTab.settings:
        return const SettingsScreen();
    }
  }
}
