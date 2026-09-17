import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;
  final String avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.avatarUrl,
  });
}

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final UserProfile? user;

  const AuthState({
    this.isAuthenticated = true,
    this.isLoading = false,
    this.errorMessage,
    this.user = const UserProfile(
      id: 'rev-101',
      name: 'Dr. Sarah Vance',
      email: 's.vance@university.edu',
      role: 'Lead Capstone Reviewer',
      department: 'Dept. of Computer Science & Engineering',
      avatarUrl: '',
    ),
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    UserProfile? user,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    if (email.contains('@') && password.length >= 6) {
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: const UserProfile(
          id: 'rev-101',
          name: 'Dr. Sarah Vance',
          email: 's.vance@university.edu',
          role: 'Lead Capstone Reviewer',
          department: 'Dept. of Computer Science & Engineering',
          avatarUrl: '',
        ),
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid credentials. Password must be at least 6 characters.',
      );
      return false;
    }
  }

  void logout() {
    state = const AuthState(
      isAuthenticated: false,
      user: null,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
