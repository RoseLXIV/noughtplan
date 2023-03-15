import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/models/auth_state.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/budget/models/budget_state.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.isLoading;
});

final budgetIsLoadingProvider = Provider<bool>((ref) {
  final budgetState = ref.watch(budgetStateProvider);

  return budgetState.isLoading;
});
