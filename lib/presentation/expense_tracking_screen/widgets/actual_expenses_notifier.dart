import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';

class ActualExpensesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final BudgetStateNotifier _budgetNotifier;

  ActualExpensesNotifier(this._budgetNotifier) : super([]);

  void updateActualExpenses(List<Map<String, dynamic>> newExpenses) {
    state = newExpenses;
  }

  void removeExpenseAtIndex(int index) {
    state = List<Map<String, dynamic>>.from(state)..removeAt(index);
  }

  Future<void> loadExpenses(String? budgetId) async {
    try {
      final budgets = await _budgetNotifier.fetchUserBudgets();
      final updatedBudget = budgets.firstWhere((b) => b?.budgetId == budgetId);

      if (updatedBudget != null) {
        state = List<Map<String, dynamic>>.from(updatedBudget.actualExpenses);
      }
    } catch (e) {
      print('Error loading expenses: $e');
    }
  }
}
