import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../providers/review_provider.dart';

class ManualReviewSection extends ConsumerStatefulWidget {
  const ManualReviewSection({super.key});

  @override
  ConsumerState<ManualReviewSection> createState() => _ManualReviewSectionState();
}

class _ManualReviewSectionState extends ConsumerState<ManualReviewSection> {
  late TextEditingController _commentsController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    final review = ref.read(reviewProvider);
    _commentsController = TextEditingController(text: review.manualComments);
    _scoreController = TextEditingController(text: review.score.toString());
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  String _getGradeLabel(int score) {
    if (score >= 90) return 'Grade A (Distinction)';
    if (score >= 80) return 'Grade B+ (Merit)';
    if (score >= 70) return 'Grade B (Satisfactory)';
    if (score >= 60) return 'Grade C (Needs Work)';
    return 'Unsatisfactory';
  }

  Color _getGradeColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 70) return AppColors.primary;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  void _insertQuickFeedback(String snippet) {
    final current = _commentsController.text;
    final updated = current.isEmpty ? snippet : '$current\n• $snippet';
    _commentsController.text = updated;
    ref.read(reviewProvider.notifier).updateComments(updated);
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewProvider);
    final reviewNotifier = ref.read(reviewProvider.notifier);

    // Sync score text if updated externally by rubrics
    if (_scoreController.text != reviewState.score.toString()) {
      _scoreController.text = reviewState.score.toString();
    }

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.rate_review_rounded, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faculty Manual Evaluation',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textHeading,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Score calculation & feedback notes',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Grade badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getGradeColor(reviewState.score).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getGradeColor(reviewState.score).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded, size: 14, color: _getGradeColor(reviewState.score)),
                    const SizedBox(width: 4),
                    Text(
                      _getGradeLabel(reviewState.score),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _getGradeColor(reviewState.score),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 16),

          // Total Score Input
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Evaluation Score (0 - 100)',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Weighted aggregate from rubric criteria',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 110,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _scoreController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _getGradeColor(reviewState.score),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          isDense: true,
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null) {
                            reviewNotifier.setScore(parsed);
                          }
                        },
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rubrics Breakdown
          Text(
            'Evaluation Rubrics Breakdown',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textHeading),
          ),
          const SizedBox(height: 10),

          ...reviewState.rubrics.asMap().entries.map((entry) {
            final idx = entry.key;
            final rubric = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rubric.category,
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textHeading),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${rubric.currentScore} / ${rubric.maxScore} pts',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: Slider(
                      value: rubric.currentScore.toDouble(),
                      min: 0,
                      max: rubric.maxScore.toDouble(),
                      divisions: rubric.maxScore,
                      onChanged: (val) => reviewNotifier.updateRubricScore(idx, val.toInt()),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // Qualitative Comments & Feedback Area
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reviewer Comments & Feedback *',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                tooltip: 'Quick Insert Snippets',
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Snippets', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
                onSelected: _insertQuickFeedback,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Mathematical proofs in Section 2.2 require formal convergence criteria.',
                    child: Text('Insert: ES-EKF Math Proof Note'),
                  ),
                  const PopupMenuItem(
                    value: 'Add comparative baseline benchmarks for FAST-LIO2 with citation.',
                    child: Text('Insert: Baseline Citation Note'),
                  ),
                  const PopupMenuItem(
                    value: 'Ensure ethical clearance and IRB consent protocols are appended in Appendix B.',
                    child: Text('Insert: IRB Ethics Clearance Note'),
                  ),
                  const PopupMenuItem(
                    value: 'Outstanding experimental rigor, robust field testing, and clear documentation.',
                    child: Text('Insert: Commendation Note'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _commentsController,
            maxLines: 5,
            onChanged: (val) => reviewNotifier.updateComments(val),
            decoration: const InputDecoration(
              hintText: 'Enter structured feedback, defense recommendations, or required revisions for the student group...',
            ),
          ),
        ],
      ),
    );
  }
}
