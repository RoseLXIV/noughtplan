import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';

part 'debt_tracker_state.dart';

final debtTrackerProvider =
    StateNotifierProvider<DebtTrackerController, DebtTrackerState>(
  (ref) => DebtTrackerController(
    ref.read(budgetStateProvider.notifier),
  ),
);

class DebtTrackerController extends StateNotifier<DebtTrackerState> {
  final BudgetStateNotifier _budgetStateNotifier;
  DebtTrackerController(
    this._budgetStateNotifier,
  ) : super(const DebtTrackerState());

  String? _selectedCategory;
  String _amountText = '';
  String _outstandingText = '';
  String _interestText = '';
  String _frequencyText = '';
  String _trackerTypeText = '';

  String? get selectedCategory => _selectedCategory;
  String get amountText => _amountText;
  String get outstandingText => _outstandingText;
  String get interestText => _interestText;
  String get frequencyText => _frequencyText;
  String get trackerTypeText => _trackerTypeText;

  void onCategoryChange(String value) {
    _selectedCategory = value;
    final category = Category.dirty(value);
    state = state.copyWith(
      category: category,
      status: Formz.validate([
        category,
        state.amount,
        state.outstanding,
        state.interest,
        state.frequency
      ]),
    );
  }

  void onAmountChange(String value) {
    _amountText = value;
    // Remove commas from the amount value
    String sanitizedValue = value.replaceAll(',', '');

    final amount = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      amount: amount,
      status: Formz.validate([
        state.category,
        amount,
        state.outstanding,
        state.interest,
        state.frequency
      ]),
    );
  }

  void onOutstandingChange(String value) {
    _outstandingText = value;
    // Remove commas from the amount value
    String sanitizedValue = value.replaceAll(',', '');

    final outstanding = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      outstanding: outstanding,
      status: Formz.validate([
        state.category,
        state.amount,
        outstanding,
        state.interest,
        state.frequency
      ]),
    );
  }

  void onInterestChange(String value) {
    _interestText = value;
    // Remove commas from the amount value
    String sanitizedValue = value.replaceAll(',', '');

    final interest = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      interest: interest,
      status: Formz.validate([
        state.category,
        state.amount,
        state.outstanding,
        interest,
        state.frequency
      ]),
    );
  }

  void onFrequencyChange(String value) {
    _frequencyText = value;
    final frequency = Frequency.dirty(value);
    state = state.copyWith(
      frequency: frequency,
      status: Formz.validate([
        state.category,
        state.amount,
        state.outstanding,
        state.interest,
        frequency
      ]),
    );
  }

  void onTrackerTypeChange(String value) {
    _trackerTypeText = value;
    final tracker = Tracker.dirty(value);
    state = state.copyWith(
      tracker: tracker,
      status: Formz.validate([
        state.category,
        state.amount,
        state.outstanding,
        state.interest,
        state.frequency,
        tracker
      ]),
    );
    print('Tracker: $value');
    print('Status: ${state.status}');
  }

  Future<void> addDebtToBudget(
      String budgetId, Map<String, dynamic> debtData, WidgetRef ref) {
    return _budgetStateNotifier.addDebt(
        budgetId: budgetId, debtData: debtData, ref: ref);
  }
}
