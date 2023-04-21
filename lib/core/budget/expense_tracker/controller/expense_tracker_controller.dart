import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';

part 'expense_tracker_state.dart';

final expenseTrackerProvider =
    StateNotifierProvider<ExpenseTrackerController, ExpenseTrackerState>(
  (ref) => ExpenseTrackerController(
    ref.read(budgetStateProvider.notifier),
  ),
);

class ExpenseTrackerController extends StateNotifier<ExpenseTrackerState> {
  final BudgetStateNotifier _budgetStateNotifier;
  ExpenseTrackerController(
    this._budgetStateNotifier,
  ) : super(const ExpenseTrackerState());

  String? _selectedCategory;
  String _amountText = '';

  String? get selectedCategory => _selectedCategory;
  String get amountText => _amountText;

  void onCategoryChange(String value) {
    _selectedCategory = value;
    final category = Category.dirty(value);
    state = state.copyWith(
      category: category,
      status: Formz.validate([category, state.amount]),
    );
    print('Category: $value');
    print('Status: ${state.status}');
  }

  void onAmountChange(String value) {
    _amountText = value;
    // Remove commas from the amount value
    String sanitizedValue = value.replaceAll(',', '');

    final amount = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      amount: amount,
      status: Formz.validate([state.category, amount]),
    );
    print('Amount: $value');
    print('Status: ${state.status}');
  }

  Future<void> addActualExpenseToBudget(
      String budgetId, Map<String, dynamic> expenseData, WidgetRef ref) {
    return _budgetStateNotifier.addActualExpense(
        budgetId: budgetId, expenseData: expenseData, ref: ref);
  }

  // Future<bool> saveExpense() async {
  //   if (!state.status.isValidated) {
  //     return false;
  //   }
  //   state = state.copyWith(status: FormzStatus.submissionInProgress);
  //   try {
  //     String amountWithoutCommas = state.amount.value.replaceAll(',', '');
  //     double amount = double.parse(amountWithoutCommas);

  //     print('Successfully saved expense');
  //     state = state.copyWith(status: FormzStatus.submissionSuccess);
  //     return true;
  //   } catch (e) {
  //     state = state.copyWith(
  //         status: FormzStatus.submissionFailure, errorMessage: 'Error: $e');
  //     print('Error: $e');
  //     return false;
  //   } finally {
  //     state = state.copyWith(status: FormzStatus.pure);
  //   }
  // }
}
