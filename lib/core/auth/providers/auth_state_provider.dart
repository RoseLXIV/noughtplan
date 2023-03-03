import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/models/auth_state.dart';
import 'package:noughtplan/core/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
