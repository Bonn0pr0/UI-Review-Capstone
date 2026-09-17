import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationTab {
  dashboard,
  projects,
  reviews,
  settings,
}

class NavigationState {
  final NavigationTab currentTab;
  final String? activeDocumentId;

  const NavigationState({
    this.currentTab = NavigationTab.dashboard,
    this.activeDocumentId,
  });

  NavigationState copyWith({
    NavigationTab? currentTab,
    String? activeDocumentId,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      activeDocumentId: activeDocumentId ?? this.activeDocumentId,
    );
  }
}

class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    return const NavigationState();
  }

  void setTab(NavigationTab tab) {
    state = state.copyWith(currentTab: tab);
  }

  void openReviewWorkspace(String documentId) {
    state = NavigationState(
      currentTab: NavigationTab.reviews,
      activeDocumentId: documentId,
    );
  }
}

final navigationProvider = NotifierProvider<NavigationNotifier, NavigationState>(NavigationNotifier.new);
