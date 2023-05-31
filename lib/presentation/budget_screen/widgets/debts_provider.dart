import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';

final debtsProvider =
    StateNotifierProvider<DebtsNotifier, List<Map<String, dynamic>>>((ref) {
  final budgetNotifier = ref.watch(budgetStateProvider.notifier);
  return DebtsNotifier(budgetNotifier: budgetNotifier);
});

class DebtsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final BudgetStateNotifier budgetNotifier;

  DebtsNotifier({required this.budgetNotifier}) : super([]) {}

  void loadDebts(String? budgetId) async {
    // Assuming your BudgetStateNotifier class has a method to get the debts.
    final budgets = await budgetNotifier.fetchUserBudgets();

    final updatedBudget = budgets.firstWhere((b) => b?.budgetId == budgetId);

    // Assuming your budget has a field 'debts'
    // This will just get the debts of the first budget
    // Replace this with your actual logic
    if (updatedBudget != null) {
      final debts = updatedBudget.debts;
      state = debts;
    }
  }

  void updateDebts(List<Map<String, dynamic>> newDebts) {
    state = newDebts;
  }

  void removeDebtAtIndex(int index) {
    state = List<Map<String, dynamic>>.from(state)..removeAt(index);
  }
}
