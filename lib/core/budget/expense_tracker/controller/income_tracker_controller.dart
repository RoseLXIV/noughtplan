import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';

part 'income_tracker_state.dart';

final incomeTrackerProvider =
    StateNotifierProvider<IncomeTrackerController, IncomeTrackerState>(
  (ref) => IncomeTrackerController(
    ref.read(budgetStateProvider.notifier),
  ),
);

class IncomeTrackerController extends StateNotifier<IncomeTrackerState> {
  final BudgetStateNotifier _budgetStateNotifier;
  IncomeTrackerController(
    this._budgetStateNotifier,
  ) : super(const IncomeTrackerState());

  String? _selectedCategory = 'Income';
  String _amountText = '';

  String? get selectedCategory => _selectedCategory;
  String get amountText => _amountText;

  void onAmountChange(String value) {
    _amountText = value;
    // Remove commas from the amount value
    String sanitizedValue = value.replaceAll(',', '');

    final amount = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      amount: amount,
      status: Formz.validate([amount]),
    );
    print('Amount: $value');
    print('Status: ${state.status}');
  }

  void reset() {
    _amountText = '';

    state = state.copyWith(
      amount: Amount.pure(),
      status: FormzStatus.pure,
    );
  }

  Future<void> addActualExpenseToBudget(
      String budgetId, Map<String, dynamic> expenseData, WidgetRef ref) {
    return _budgetStateNotifier.addActualExpense(
        budgetId: budgetId, expenseData: expenseData, ref: ref);
  }
}
