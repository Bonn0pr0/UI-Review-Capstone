import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/project.dart';
import '../../../core/models/activity.dart';
import 'package:flutter/material.dart';

class ProjectFilterState {
  final String searchQuery;
  final DocumentStatus? statusFilter;
  final String? categoryFilter;

  const ProjectFilterState({
    this.searchQuery = '',
    this.statusFilter,
    this.categoryFilter,
  });

  ProjectFilterState copyWith({
    String? searchQuery,
    DocumentStatus? Function()? statusFilter,
    String? Function()? categoryFilter,
  }) {
    return ProjectFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      categoryFilter: categoryFilter != null ? categoryFilter() : this.categoryFilter,
    );
  }
}

class ProjectListState {
  final List<ProjectDocument> documents;
  final List<ActivityItem> recentActivities;
  final bool isUploading;

  const ProjectListState({
    required this.documents,
    required this.recentActivities,
    this.isUploading = false,
  });

  ProjectListState copyWith({
    List<ProjectDocument>? documents,
    List<ActivityItem>? recentActivities,
    bool? isUploading,
  }) {
    return ProjectListState(
      documents: documents ?? this.documents,
      recentActivities: recentActivities ?? this.recentActivities,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

final _initialDocuments = [
  ProjectDocument(
    id: 'DOC-2026-001',
    projectName: 'Autonomous Drone Navigation in GPS-Denied Environments',
    groupName: 'AeroTech Syndicate (Group 04)',
    documentTitle: 'Capstone_Final_Report_AeroTech_v2.1.pdf',
    version: 'v2.1',
    submissionDate: DateTime.now().subtract(const Duration(hours: 3)),
    status: DocumentStatus.inReview,
    pageCount: 38,
    fileSize: '14.2 MB',
    category: 'Robotics & AI',
    studentMembers: ['Alex Morgan', 'David Kim', 'Elena Rostova', 'Marcus Chen'],
    score: null,
    reviewerComments: 'Initial methodology section needs tighter mathematical proofs for the EKF localization matrix.',
    abstractText: 'This project addresses real-time simultaneous localization and mapping (SLAM) for quadcopters operating in subterranean and indoor environments without GPS availability. We introduce a lightweight visual-inertial odometry pipeline combined with LiDAR depth integration running on an onboard NVIDIA Jetson Orin Nano.',
    fullMockContent: '''CHAPTER 1: INTRODUCTION & PROBLEM STATEMENT
1.1 Background
Unmanned Aerial Vehicles (UAVs) have witnessed extensive adoption across search-and-rescue, industrial inspection, and defense scenarios. However, existing navigation paradigms rely critically on Global Navigation Satellite Systems (GNSS) signals. In subterranean mine shafts, dense forests, and steel-reinforced urban canyons, GNSS signals suffer severe attenuation and multipath degradation.

1.2 Objectives and Deliverables
The core objective of the AeroTech Capstone Project is to architect, build, and benchmark an end-to-end autonomous navigation stack capable of:
1. Maintaining 3D positional drift below 1.2% over a 500-meter transit.
2. Generating 3D volumetric occupancy octrees in real time at >= 20 Hz.
3. Executing collision-free trajectory re-planning within a 45-millisecond latency envelope.

CHAPTER 2: SYSTEM ARCHITECTURE & SENSOR SUITE
2.1 Hardware Configuration
The quadcopter platform is built upon a carbon-fiber X-frame with 10-inch carbon props. The sensor payload comprises:
• Livox Mid-360 solid-state LiDAR (360° horizontal x 59° vertical FOV)
• Stereo Global Shutter Camera pair (120 FPS, 1280x720) with synchronized hardware triggering
• Bosch Sensortec BMI088 6-DOF Industrial IMU sampled at 1 kHz
• Jetson Orin Nano (8GB) running Ubuntu 22.04 LTS and ROS 2 Humble

2.2 Algorithmic Pipeline
Our state estimation module employs an Error-State Extended Kalman Filter (ES-EKF) fusing high-rate IMU pre-integration with LiDAR-inertial surface matching constraints. Point clouds are filtered through a voxel grid with a leaf size of 0.05m before scan-to-map registration.

CHAPTER 3: EXPERIMENTAL VALIDATION AND BENCHMARKS
3.1 Test Environments
Field evaluations were conducted across three test sites:
1. Civil Engineering Underground Steam Tunnel (180m length, zero ambient lighting)
2. Abandoned Multi-Storey Parking Garage (2 levels, high acoustic/multipath echo)
3. Simulated Forest Canopy Testbed with wire-mesh obstacles

3.2 Drift Metric Comparisons
Across 15 autonomous runs, the mean position error at endpoint closure was measured at 0.84% of total trajectory distance, outperforming benchmark FAST-LIO2 (1.12%) under rapid rotational maneuvers.''',
  ),
  ProjectDocument(
    id: 'DOC-2026-002',
    projectName: 'Distributed Privacy-Preserving EHR System Using Zero-Knowledge Proofs',
    groupName: 'CipherHealth (Group 12)',
    documentTitle: 'CipherHealth_Architecture_Proposal_v1.0.pdf',
    version: 'v1.0',
    submissionDate: DateTime.now().subtract(const Duration(hours: 14)),
    status: DocumentStatus.pending,
    pageCount: 45,
    fileSize: '8.7 MB',
    category: 'Cybersecurity & HealthTech',
    studentMembers: ['Sofia Alvarez', 'Liam O\'Connor', 'Priya Patel'],
    score: null,
    reviewerComments: null,
    abstractText: 'We propose a cryptographic framework for electronic health records (EHR) interoperability that allows medical researchers to execute zero-knowledge verifiable queries on patient telemetry without revealing Personally Identifiable Information (PII) or raw genomic records.',
    fullMockContent: '''CHAPTER 1: PRIVACY CHALLENGES IN MODERN HEALTHCARE
Health information exchange networks frequently struggle between data utility and compliance with HIPAA and GDPR statutes. Medical research organizations often require statistical verification over cohorts without accessing underlying raw clinical identifiers.

CHAPTER 2: ZERO-KNOWLEDGE PROTOCOL FORMULATION
Our architecture implements zk-SNARKs (PLONK with KZG polynomial commitments). Patient nodes store encrypted shards across a distributed IPFS layer. When an authorized clinic queries patient eligibility for clinical trials, the patient sidecar engine computes a succinct non-interactive proof of condition satisfaction without disclosing diagnostic codes.''',
  ),
  ProjectDocument(
    id: 'DOC-2026-003',
    projectName: 'Real-Time Edge AI for Wildfire Early Detection and Spread Modeling',
    groupName: 'PyroWatch Systems (Group 07)',
    documentTitle: 'PyroWatch_Final_Submission_v3.0.pdf',
    version: 'v3.0',
    submissionDate: DateTime.now().subtract(const Duration(days: 1)),
    status: DocumentStatus.approved,
    pageCount: 52,
    fileSize: '22.4 MB',
    category: 'Machine Learning & IoT',
    studentMembers: ['Ethan Zhang', 'Maya Lin', 'Lucas Silva', 'Aria Bennett'],
    score: 94,
    reviewerComments: 'Exceptional experimental rigor and hardware demonstration. Field telemetry validates thermal vision accuracy.',
    abstractText: 'PyroWatch deploys a mesh of low-power solar-powered edge vision nodes equipped with thermal and optical cameras. Utilizing a quantized MobileNetV4 backbone and cellular NB-IoT backhaul, the system achieves 98.4% smoke detection accuracy within 45 seconds of ignition.',
    fullMockContent: '''CHAPTER 1: INTRODUCTION
Wildfires represent catastrophic ecological and economic disasters. Existing satellite detection systems suffer from orbit latency between 15 minutes to 4 hours, during which brush fires expand exponentially.

CHAPTER 2: EMBEDDED SYSTEM SPECIFICATIONS
Each PyroWatch sensor tower incorporates dual microbolometers (8-14 µm) with custom CNN models compiled via TensorRT for ultra-low power execution on Raspberry Pi CM4 + Coral Edge TPU accelerators.''',
  ),
  ProjectDocument(
    id: 'DOC-2026-004',
    projectName: 'Adaptive Brain-Computer Interface for Upper Limb Neuro-Rehabilitation',
    groupName: 'NeuroLinkers (Group 02)',
    documentTitle: 'NeuroLinkers_Midterm_Review_v1.4.pdf',
    version: 'v1.4',
    submissionDate: DateTime.now().subtract(const Duration(days: 2)),
    status: DocumentStatus.revisionNeeded,
    pageCount: 30,
    fileSize: '11.1 MB',
    category: 'Biomedical & Neural Eng',
    studentMembers: ['Chloe Dubois', 'Amir Hassan', 'Kaitlyn Reed'],
    score: 72,
    reviewerComments: 'Requires IRB ethics approval documentation in Appendix B and clinical participant safety threshold metrics.',
    abstractText: 'An adaptive non-invasive 16-channel EEG headset integrated with a robotic exoskeleton glove. Utilizes motor imagery classification to assist stroke rehabilitation patients in regaining motor control through closed-loop sensory feedback.',
    fullMockContent: '''CHAPTER 1: CLINICAL NEED
Stroke remains the leading cause of adult long-term disability worldwide. Rehabilitation protocols require intensive, repetitive motor training to promote neuroplasticity.

CHAPTER 2: SIGNAL PROCESSING & ARTIFACT REJECTION
Raw EEG traces are preprocessed via Common Spatial Pattern (CSP) filters and continuous wavelet transforms to extract mu and beta band desynchronization during imagined finger flexion maneuvers.''',
  ),
  ProjectDocument(
    id: 'DOC-2026-005',
    projectName: 'High-Throughput Decentralized Energy Trading Grid for Microgrids',
    groupName: 'VoltLedger (Group 19)',
    documentTitle: 'VoltLedger_Whitepaper_v2.0.pdf',
    version: 'v2.0',
    submissionDate: DateTime.now().subtract(const Duration(days: 3)),
    status: DocumentStatus.pending,
    pageCount: 36,
    fileSize: '6.9 MB',
    category: 'CleanTech & Systems',
    studentMembers: ['Noah Becker', 'Zoe Katsaros', 'Arjun Mehta'],
    score: null,
    reviewerComments: null,
    abstractText: 'A high-throughput layer-2 rollup protocol on Ethereum designed for automated peer-to-peer solar energy trading among microgrid residential nodes with smart meter hardware attestation.',
    fullMockContent: '''CHAPTER 1: DISTRIBUTED ENERGY GENERATION
Residential solar PV adoption necessitates decentralized settlement layers that handle dynamic spot market pricing without incurring prohibitive transaction gas fees.''',
  ),
];

final _initialActivities = [
  ActivityItem(
    id: 'ACT-01',
    title: 'Review Started',
    description: 'Dr. Sarah Vance initiated evaluation on AeroTech Capstone v2.1',
    projectName: 'Autonomous Drone Navigation in GPS-Denied Environments',
    documentTitle: 'Capstone_Final_Report_AeroTech_v2.1.pdf',
    user: 'Dr. Sarah Vance',
    timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    status: DocumentStatus.inReview,
    icon: Icons.rate_review_outlined,
  ),
  ActivityItem(
    id: 'ACT-02',
    title: 'Document Approved',
    description: 'PyroWatch Systems Final Submission scored 94/100',
    projectName: 'Real-Time Edge AI for Wildfire Early Detection',
    documentTitle: 'PyroWatch_Final_Submission_v3.0.pdf',
    user: 'Prof. Jason Myers',
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    status: DocumentStatus.approved,
    icon: Icons.check_circle_outline_rounded,
  ),
  ActivityItem(
    id: 'ACT-03',
    title: 'Revision Requested',
    description: 'IRB ethics documentation requested for NeuroLinkers v1.4',
    projectName: 'Adaptive Brain-Computer Interface',
    documentTitle: 'NeuroLinkers_Midterm_Review_v1.4.pdf',
    user: 'Dr. Sarah Vance',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    status: DocumentStatus.revisionNeeded,
    icon: Icons.warning_amber_rounded,
  ),
  ActivityItem(
    id: 'ACT-04',
    title: 'New Document Uploaded',
    description: 'CipherHealth submitted v1.0 Proposal for faculty review',
    projectName: 'Distributed Privacy-Preserving EHR System',
    documentTitle: 'CipherHealth_Architecture_Proposal_v1.0.pdf',
    user: 'Sofia Alvarez (Student Lead)',
    timestamp: DateTime.now().subtract(const Duration(hours: 14)),
    status: DocumentStatus.pending,
    icon: Icons.upload_file_rounded,
  ),
];

class ProjectNotifier extends Notifier<ProjectListState> {
  @override
  ProjectListState build() {
    return ProjectListState(
      documents: _initialDocuments,
      recentActivities: _initialActivities,
    );
  }

  void updateDocumentReview({
    required String documentId,
    required DocumentStatus newStatus,
    required int? score,
    required String comments,
  }) {
    state = state.copyWith(
      documents: state.documents.map((doc) {
        if (doc.id == documentId) {
          return doc.copyWith(
            status: newStatus,
            score: score,
            reviewerComments: comments,
          );
        }
        return doc;
      }).toList(),
      recentActivities: [
        ActivityItem(
          id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
          title: newStatus == DocumentStatus.approved ? 'Document Approved' : 'Revision Requested',
          description: 'Document $documentId updated with status: ${newStatus.label}',
          projectName: state.documents.firstWhere((d) => d.id == documentId).projectName,
          documentTitle: state.documents.firstWhere((d) => d.id == documentId).documentTitle,
          user: 'Dr. Sarah Vance',
          timestamp: DateTime.now(),
          status: newStatus,
          icon: newStatus.icon,
        ),
        ...state.recentActivities,
      ],
    );
  }

  Future<void> importDocument({
    required String projectName,
    required String groupName,
    required String documentTitle,
    required String category,
    required String version,
    required List<String> studentMembers,
    required String abstractText,
  }) async {
    state = state.copyWith(isUploading: true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final newDoc = ProjectDocument(
      id: 'DOC-2026-${(state.documents.length + 1).toString().padLeft(3, '0')}',
      projectName: projectName,
      groupName: groupName,
      documentTitle: documentTitle,
      version: version,
      submissionDate: DateTime.now(),
      status: DocumentStatus.pending,
      pageCount: 24,
      fileSize: '5.4 MB',
      category: category,
      studentMembers: studentMembers,
      abstractText: abstractText,
      fullMockContent: 'CHAPTER 1: INTRODUCTION\n$abstractText\n\nCHAPTER 2: IMPLEMENTATION DETAILS\nDetails provided during project execution.',
    );

    state = state.copyWith(
      isUploading: false,
      documents: [newDoc, ...state.documents],
      recentActivities: [
        ActivityItem(
          id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'New Document Imported',
          description: '$documentTitle imported for $projectName',
          projectName: projectName,
          documentTitle: documentTitle,
          user: 'Review Coordinator',
          timestamp: DateTime.now(),
          status: DocumentStatus.pending,
          icon: Icons.upload_file_rounded,
        ),
        ...state.recentActivities,
      ],
    );
  }
}

class ProjectFilterNotifier extends Notifier<ProjectFilterState> {
  @override
  ProjectFilterState build() {
    return const ProjectFilterState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(DocumentStatus? status) {
    state = state.copyWith(statusFilter: () => status);
  }

  void setCategoryFilter(String? category) {
    state = state.copyWith(categoryFilter: () => category);
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, ProjectListState>(ProjectNotifier.new);

final projectFilterProvider = NotifierProvider<ProjectFilterNotifier, ProjectFilterState>(ProjectFilterNotifier.new);

final filteredProjectsProvider = Provider<List<ProjectDocument>>((ref) {
  final projectState = ref.watch(projectProvider);
  final filter = ref.watch(projectFilterProvider);

  return projectState.documents.where((doc) {
    final matchesQuery = filter.searchQuery.isEmpty ||
        doc.projectName.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
        doc.groupName.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
        doc.documentTitle.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
        doc.id.toLowerCase().contains(filter.searchQuery.toLowerCase());

    final matchesStatus = filter.statusFilter == null || doc.status == filter.statusFilter;
    final matchesCategory = filter.categoryFilter == null || doc.category == filter.categoryFilter;

    return matchesQuery && matchesStatus && matchesCategory;
  }).toList();
});
