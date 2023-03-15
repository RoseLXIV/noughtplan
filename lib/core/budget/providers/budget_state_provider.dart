import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Authenticator
import 'package:noughtplan/core/auth/providers/authenticator_provider.dart';
import 'package:noughtplan/core/budget/models/budget_state.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';

final budgetStateProvider =
    StateNotifierProvider<BudgetStateNotifier, BudgetState>((ref) {
  final authenticator = ref
      .read(authenticatorProvider); // Read the authenticator from your provider
  return BudgetStateNotifier(authenticator);
});
