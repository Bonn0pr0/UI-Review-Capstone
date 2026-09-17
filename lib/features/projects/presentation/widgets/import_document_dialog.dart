import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/project_provider.dart';

class ImportDocumentDialog extends ConsumerStatefulWidget {
  const ImportDocumentDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ImportDocumentDialog(),
    );
  }

  @override
  ConsumerState<ImportDocumentDialog> createState() => _ImportDocumentDialogState();
}

class _ImportDocumentDialogState extends ConsumerState<ImportDocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _projectTitleController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _versionController = TextEditingController(text: 'v1.0');
  final _studentMembersController = TextEditingController();
  final _abstractController = TextEditingController();

  String _selectedCategory = 'Robotics & AI';
  String? _selectedFileName;
  String? _selectedFileSize;
  bool _isDragging = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  final _categories = [
    'Robotics & AI',
    'Cybersecurity & HealthTech',
    'Machine Learning & IoT',
    'Biomedical & Neural Eng',
    'CleanTech & Systems',
    'Software Architecture',
  ];

  @override
  void dispose() {
    _projectTitleController.dispose();
    _groupNameController.dispose();
    _versionController.dispose();
    _studentMembersController.dispose();
    _abstractController.dispose();
    super.dispose();
  }

  void _simulateFileSelection() {
    setState(() {
      _selectedFileName = 'Capstone_Report_Draft_${DateTime.now().millisecondsSinceEpoch % 1000}.pdf';
      _selectedFileSize = '12.4 MB';
      if (_projectTitleController.text.isEmpty) {
        _projectTitleController.text = 'Next-Gen Semantic Search Engine for Academic Papers';
        _groupNameController.text = 'Nexus Labs (Group 08)';
        _studentMembersController.text = 'Ryan Vance, Jessica Wu, Tariq Al-Mansoor';
        _abstractController.text = 'An investigation into dense vector retrieval and hierarchical clustering for indexing multi-disciplinary academic dissertations with sub-second latency.';
      }
    });
  }

  Future<void> _handleImport() async {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or drop a PDF document first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.2;
      });

      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _uploadProgress = 0.6);

      await Future.delayed(const Duration(milliseconds: 400));
      setState(() => _uploadProgress = 1.0);

      final members = _studentMembersController.text
          .split(',')
          .map((m) => m.trim())
          .where((m) => m.isNotEmpty)
          .toList();

      await ref.read(projectProvider.notifier).importDocument(
            projectName: _projectTitleController.text.trim(),
            groupName: _groupNameController.text.trim(),
            documentTitle: _selectedFileName!,
            category: _selectedCategory,
            version: _versionController.text.trim(),
            studentMembers: members.isEmpty ? ['Team Member 1', 'Team Member 2'] : members,
            abstractText: _abstractController.text.trim().isEmpty
                ? 'Comprehensive capstone documentation and evaluation artifacts.'
                : _abstractController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('Document "$_selectedFileName" imported successfully!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      backgroundColor: AppColors.surface,
      child: Container(
        width: 640,
        constraints: const BoxConstraints(maxHeight: 740),
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.upload_file_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Import Capstone Document',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textHeading,
                            ),
                          ),
                          Text(
                            'Upload PDF submission for faculty peer review & AI audit',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File Upload Drop Zone Simulation
                      InkWell(
                        onTap: _isUploading ? null : _simulateFileSelection,
                        onHover: (hovering) => setState(() => _isDragging = hovering),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _selectedFileName != null
                                ? AppColors.primaryLight.withValues(alpha: 0.5)
                                : (_isDragging ? AppColors.surfaceHover : AppColors.background),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedFileName != null
                                  ? AppColors.primary
                                  : (_isDragging ? AppColors.primary : AppColors.border),
                              width: _selectedFileName != null ? 1.5 : 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _selectedFileName == null
                              ? Column(
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 38,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Click to browse or drop Capstone PDF here',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textHeading,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Supported formats: PDF, DOCX (Max size: 50MB)',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        color: AppColors.error,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _selectedFileName!,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textHeading,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Size: $_selectedFileSize • Ready for evaluation',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.success,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: _simulateFileSelection,
                                      icon: const Icon(Icons.refresh_rounded, size: 16),
                                      label: const Text('Change'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form Fields
                      Text(
                        'Project Title *',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _projectTitleController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Autonomous Drone Navigation in GPS-Denied Environments',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Project title is required' : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Student Group / Team Name *',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _groupNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. AeroTech Syndicate (Group 04)',
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Group name is required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Version *',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _versionController,
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. v1.0',
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Version required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Domain Category',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
                                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textHeading),
                                      items: _categories.map((cat) {
                                        return DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedCategory = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Student Team Members (Comma-separated)',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _studentMembersController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Alex Morgan, David Kim, Elena Rostova',
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Executive Summary / Abstract',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textHeading),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _abstractController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Enter brief abstract or scope description...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Upload Progress Bar if active
              if (_isUploading) ...[
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Uploading and parsing PDF structure...',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
                        ),
                        Text(
                          '${(_uploadProgress * 100).toInt()}%',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _handleImport,
                    icon: _isUploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.upload_rounded, size: 18),
                    label: Text(_isUploading ? 'Importing...' : 'Import Document'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
