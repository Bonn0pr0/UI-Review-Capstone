import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_card.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _enableAutoAIScan = true;
  bool _flagCitations = true;
  bool _flagEquations = true;
  double _aiConfidenceThreshold = 0.85;
  String _selectedTemplate = 'IEEE Standard Capstone Rubric';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Text(
              'Application Settings & Preferences',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textHeading,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configure evaluation rubrics, AI assistant sensitivity, and reviewer profile',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textBody),
            ),
            const SizedBox(height: 24),

            // Profile Card
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        authState.user?.name.split(' ').map((n) => n[0]).take(2).join('') ?? 'SV',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.user?.name ?? 'Dr. Sarah Vance',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeading,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${authState.user?.role ?? 'Lead Reviewer'} • ${authState.user?.department ?? 'Department of Computer Science'}',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textBody),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          authState.user?.email ?? 's.vance@university.edu',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile details updated')),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // AI & Evaluation Configuration
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Assistant & Heuristic Auditing',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textHeading),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tune how the advisory engine flags anomalies and inconsistencies in submissions',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  SwitchListTile(
                    title: Text(
                      'Automatic AI Review on Document Import',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                    ),
                    subtitle: Text(
                      'Automatically pre-compute findings when new student manuscripts are uploaded',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textBody),
                    ),
                    value: _enableAutoAIScan,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _enableAutoAIScan = val),
                  ),
                  const Divider(),

                  SwitchListTile(
                    title: Text(
                      'Rigorous Citation Verification',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                    ),
                    subtitle: Text(
                      'Cross-reference IEEE bibliography references against academic databases',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textBody),
                    ),
                    value: _flagCitations,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _flagCitations = val),
                  ),
                  const Divider(),

                  SwitchListTile(
                    title: Text(
                      'Mathematical Proof & Equation Integrity Checks',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                    ),
                    subtitle: Text(
                      'Inspect matrix dimensions and Lyapunov stability derivations in methodology',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textBody),
                    ),
                    value: _flagEquations,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _flagEquations = val),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'AI Finding Sensitivity Threshold: ${(_aiConfidenceThreshold * 100).toInt()}%',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      activeTrackColor: AppColors.primary,
                      thumbColor: AppColors.primary,
                    ),
                    child: Slider(
                      value: _aiConfidenceThreshold,
                      min: 0.5,
                      max: 0.99,
                      divisions: 50,
                      onChanged: (val) => setState(() => _aiConfidenceThreshold = val),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Rubric Preset Template
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capstone Rubrics & Scoring Presets',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textHeading),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTemplate,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textHeading),
                        items: [
                          'IEEE Standard Capstone Rubric',
                          'ABET Engineering Accreditation Matrix',
                          'Interdisciplinary Computer Science Defense Rubric',
                        ].map((tpl) {
                          return DropdownMenuItem(
                            value: tpl,
                            child: Text(tpl),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTemplate = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
