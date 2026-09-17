import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_document_review/main.dart';

void main() {
  testWidgets('Capstone review app shell loads successfully with desktop resolution', (WidgetTester tester) async {
    // Set standard desktop testing resolution
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

    // Verify Shell branding and navigation elements
    expect(find.text('ReviewHub'), findsOneWidget);
    expect(find.text('Capstone Portal'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Projects & Docs'), findsOneWidget);
    expect(find.text('Review Workspace'), findsOneWidget);
  });
}
