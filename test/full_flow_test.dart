import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_document_review/main.dart';
import 'package:capstone_document_review/core/widgets/status_badge.dart';

void main() {
  testWidgets('End-to-End Capstone Review Desktop Workflow Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: CapstoneReviewApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Dashboard presence
    expect(find.text('ReviewHub'), findsOneWidget);
    expect(find.text('Pending Reviews'), findsOneWidget);
    expect(find.text('Needs Revision'), findsWidgets);

    // 2. Navigate to Projects & Docs
    final projectsNav = find.text('Projects & Docs');
    expect(projectsNav, findsOneWidget);
    await tester.tap(projectsNav);
    await tester.pumpAndSettle();

    expect(find.text('Capstone Projects'), findsOneWidget);
    expect(find.text('Import Document'), findsOneWidget);
    expect(find.byType(StatusBadge), findsWidgets);

    // 3. Open Review Workspace from table
    final reviewButtons = find.widgetWithText(ElevatedButton, 'Review');
    expect(reviewButtons, findsWidgets);
    await tester.tap(reviewButtons.first);
    await tester.pumpAndSettle();

    // 4. Verify 60/40 Split View in Review Workspace
    expect(find.text('CAPSTONE FINAL DEFENSE MANUSCRIPT'), findsOneWidget);
    expect(find.text('AI Document Evaluation'), findsOneWidget);
    expect(find.text('AI output is advisory. Reviewer judgment is final.'), findsOneWidget);
    expect(find.text('Faculty Manual Evaluation'), findsOneWidget);
    expect(find.text('Approve Document'), findsOneWidget);
    expect(find.text('Request Revision'), findsOneWidget);

    // 5. Test Accept finding toggle
    final acceptButtons = find.text('Accept Finding');
    if (acceptButtons.evaluate().isNotEmpty) {
      await tester.tap(acceptButtons.first);
      await tester.pumpAndSettle();
      expect(find.text('Accepted'), findsWidgets);
    }

    // 6. Test Confirmation Dialog trigger on Approve
    await tester.tap(find.text('Approve Document'));
    await tester.pumpAndSettle();

    expect(find.text('Approve Capstone Document?'), findsOneWidget);
    expect(find.text('Confirm Approval'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Cancel approval
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Approve Capstone Document?'), findsNothing);

    // 7. Test Confirmation Dialog trigger on Request Revision
    await tester.tap(find.text('Request Revision'));
    await tester.pumpAndSettle();

    expect(find.text('Request Revisions from Group?'), findsOneWidget);
    expect(find.text('Send Revision Request'), findsOneWidget);

    // Cancel dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });
}
