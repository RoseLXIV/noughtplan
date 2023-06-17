import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';

final goalsProvider =
    StateNotifierProvider<GoalsNotifier, List<Map<String, dynamic>>>((ref) {
  final budgetNotifier = ref.watch(budgetStateProvider.notifier);
  return GoalsNotifier(budgetNotifier: budgetNotifier);
});

class GoalsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final BudgetStateNotifier budgetNotifier;

  GoalsNotifier({required this.budgetNotifier}) : super([]) {}

  Future<void> loadGoals(String? budgetId) async {
    // Assuming your BudgetStateNotifier class has a method to get the goals.
    final budgets = await budgetNotifier.fetchUserBudgets();

    final updatedBudget = budgets.firstWhere((b) => b?.budgetId == budgetId);

    // Assuming your budget has a field 'goals'
    // This will just get the goals of the first budget
    // Replace this with your actual logic
    if (updatedBudget != null) {
      final goals = updatedBudget.goals;
      state = goals;
    }
  }

  void updateGoals(List<Map<String, dynamic>> newGoals) {
    state = newGoals;
  }

  void removeGoalAtIndex(int index) {
    state = List<Map<String, dynamic>>.from(state)..removeAt(index);
  }
}
