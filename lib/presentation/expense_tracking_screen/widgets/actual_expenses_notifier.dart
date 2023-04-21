import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActualExpensesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ActualExpensesNotifier() : super([]);

  void updateActualExpenses(List<Map<String, dynamic>> newExpenses) {
    state = newExpenses;
  }

  void removeExpenseAtIndex(int index) {
    state = List<Map<String, dynamic>>.from(state)..removeAt(index);
  }
}
