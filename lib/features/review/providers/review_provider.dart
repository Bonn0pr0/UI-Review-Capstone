import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/ai_finding.dart';

enum AIAnalysisStatus {
  idle,
  analyzing,
  completed,
}

class RubricScore {
  final String category;
  final int maxScore;
  int currentScore;

  RubricScore({
    required this.category,
    required this.maxScore,
    required this.currentScore,
  });
}

class ReviewState {
  final String documentId;
  final AIAnalysisStatus aiStatus;
  final double aiProgress;
  final String aiStepLabel;
  final List<AIFinding> findings;
  final int score;
  final String manualComments;
  final int currentPage;
  final double zoomLevel;
  final bool isSidebarOutlineOpen;
  final List<RubricScore> rubrics;

  const ReviewState({
    required this.documentId,
    this.aiStatus = AIAnalysisStatus.idle,
    this.aiProgress = 0.0,
    this.aiStepLabel = '',
    this.findings = const [],
    this.score = 85,
    this.manualComments = '',
    this.currentPage = 1,
    this.zoomLevel = 1.0,
    this.isSidebarOutlineOpen = true,
    this.rubrics = const [],
  });

  ReviewState copyWith({
    String? documentId,
    AIAnalysisStatus? aiStatus,
    double? aiProgress,
    String? aiStepLabel,
    List<AIFinding>? findings,
    int? score,
    String? manualComments,
    int? currentPage,
    double? zoomLevel,
    bool? isSidebarOutlineOpen,
    List<RubricScore>? rubrics,
  }) {
    return ReviewState(
      documentId: documentId ?? this.documentId,
      aiStatus: aiStatus ?? this.aiStatus,
      aiProgress: aiProgress ?? this.aiProgress,
      aiStepLabel: aiStepLabel ?? this.aiStepLabel,
      findings: findings ?? this.findings,
      score: score ?? this.score,
      manualComments: manualComments ?? this.manualComments,
      currentPage: currentPage ?? this.currentPage,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isSidebarOutlineOpen: isSidebarOutlineOpen ?? this.isSidebarOutlineOpen,
      rubrics: rubrics ?? this.rubrics,
    );
  }
}

final _mockFindingsDoc1 = [
  AIFinding(
    id: 'AI-FND-01',
    documentId: 'DOC-2026-001',
    severity: FindingSeverity.critical,
    title: 'Unproven Covariance Convergence in ES-EKF Formulation',
    referenceText: '“point clouds are filtered through a voxel grid with a leaf size of 0.05m before scan-to-map registration without explicit observability bounds.”',
    suggestion: 'Provide explicit Lyapunov stability proof or state observability matrix rank condition in Section 2.2 to justify convergence under degenerate linear motions.',
    pageNumber: 2,
    category: 'Mathematical Rigor & Methodology',
    isAccepted: false,
    isIgnored: false,
  ),
  AIFinding(
    id: 'AI-FND-02',
    documentId: 'DOC-2026-001',
    severity: FindingSeverity.warning,
    title: 'Missing Baseline Reference for FAST-LIO2 Benchmark',
    referenceText: '“...outperforming benchmark FAST-LIO2 (1.12%) under rapid rotational maneuvers.”',
    suggestion: 'Cite the original FAST-LIO2 publication (Xu et al., IEEE T-RO 2022) and clarify if standard factory parameters or tuned hyperparameters were utilized.',
    pageNumber: 3,
    category: 'Literature & Citations',
    isAccepted: false,
    isIgnored: false,
  ),
  AIFinding(
    id: 'AI-FND-03',
    documentId: 'DOC-2026-001',
    severity: FindingSeverity.suggestion,
    title: 'Thermal Throttling Mitigation on Jetson Orin Nano',
    referenceText: '“Jetson Orin Nano (8GB) running Ubuntu 22.04 LTS and ROS 2 Humble”',
    suggestion: 'Include active cooling power draw metrics (Wattage) and GPU core temperatures during continuous 20Hz point cloud registration tests.',
    pageNumber: 2,
    category: 'Hardware Feasibility',
    isAccepted: false,
    isIgnored: false,
  ),
  AIFinding(
    id: 'AI-FND-04',
    documentId: 'DOC-2026-001',
    severity: FindingSeverity.suggestion,
    title: 'Figure 3.2 Axis Notation Ambiguity',
    referenceText: '“Figure 3.2: 3D Volumetric Trajectory drift comparisons”',
    suggestion: 'Ensure Z-axis altitude units are explicitly labeled as meters (m) rather than raw sensor frame millimeters.',
    pageNumber: 3,
    category: 'Visual Clarity',
    isAccepted: false,
    isIgnored: false,
  ),
];

class ReviewNotifier extends Notifier<ReviewState> {
  @override
  ReviewState build() {
    return ReviewState(
      documentId: 'DOC-2026-001',
      aiStatus: AIAnalysisStatus.completed,
      findings: _mockFindingsDoc1,
      score: 88,
      manualComments:
          'Strong engineering execution and hardware prototyping. Please address the mathematical proofs for the ES-EKF matrix in Section 2 before final publication.',
      rubrics: [
        RubricScore(category: 'Problem Statement & Scope', maxScore: 20, currentScore: 19),
        RubricScore(category: 'Methodology & Engineering Rigor', maxScore: 30, currentScore: 26),
        RubricScore(category: 'Experimental Validation', maxScore: 30, currentScore: 27),
        RubricScore(category: 'Documentation & Presentation', maxScore: 20, currentScore: 16),
      ],
    );
  }

  void setDocument(String docId) {
    if (state.documentId == docId) return;

    state = ReviewState(
      documentId: docId,
      aiStatus: AIAnalysisStatus.idle,
      findings: [],
      score: 85,
      manualComments: '',
      currentPage: 1,
      zoomLevel: 1.0,
      rubrics: [
        RubricScore(category: 'Problem Statement & Scope', maxScore: 20, currentScore: 18),
        RubricScore(category: 'Methodology & Engineering Rigor', maxScore: 30, currentScore: 25),
        RubricScore(category: 'Experimental Validation', maxScore: 30, currentScore: 25),
        RubricScore(category: 'Documentation & Presentation', maxScore: 20, currentScore: 17),
      ],
    );
  }

  Future<void> runAIAnalysis() async {
    state = state.copyWith(
      aiStatus: AIAnalysisStatus.analyzing,
      aiProgress: 0.1,
      aiStepLabel: 'Parsing document structure & extracted text...',
    );

    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      aiProgress: 0.4,
      aiStepLabel: 'Cross-referencing methodology with IEEE benchmarks...',
    );

    await Future.delayed(const Duration(milliseconds: 700));
    state = state.copyWith(
      aiProgress: 0.75,
      aiStepLabel: 'Checking citations, formula proofs, and figures...',
    );

    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      aiProgress: 1.0,
      aiStepLabel: 'Analysis complete. 4 findings detected.',
      aiStatus: AIAnalysisStatus.completed,
      findings: _mockFindingsDoc1,
    );
  }

  void toggleAcceptFinding(String findingId) {
    state = state.copyWith(
      findings: state.findings.map((f) {
        if (f.id == findingId) {
          return f.copyWith(
            isAccepted: !f.isAccepted,
            isIgnored: false,
          );
        }
        return f;
      }).toList(),
    );
  }

  void toggleIgnoreFinding(String findingId) {
    state = state.copyWith(
      findings: state.findings.map((f) {
        if (f.id == findingId) {
          return f.copyWith(
            isIgnored: !f.isIgnored,
            isAccepted: false,
          );
        }
        return f;
      }).toList(),
    );
  }

  void setScore(int newScore) {
    state = state.copyWith(score: newScore.clamp(0, 100));
  }

  void updateComments(String comments) {
    state = state.copyWith(manualComments: comments);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page.clamp(1, 40));
  }

  void setZoomLevel(double zoom) {
    state = state.copyWith(zoomLevel: zoom.clamp(0.5, 2.5));
  }

  void toggleSidebarOutline() {
    state = state.copyWith(isSidebarOutlineOpen: !state.isSidebarOutlineOpen);
  }

  void updateRubricScore(int index, int newScore) {
    final updatedRubrics = [...state.rubrics];
    updatedRubrics[index].currentScore = newScore.clamp(0, updatedRubrics[index].maxScore);

    // Auto-calculate aggregate score
    final total = updatedRubrics.fold<int>(0, (sum, r) => sum + r.currentScore);
    state = state.copyWith(
      rubrics: updatedRubrics,
      score: total,
    );
  }
}

final reviewProvider = NotifierProvider<ReviewNotifier, ReviewState>(ReviewNotifier.new);
