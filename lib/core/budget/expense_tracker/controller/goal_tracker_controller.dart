import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';

part 'goal_tracker_state.dart';

final goalTrackerProvider =
    StateNotifierProvider<GoalTrackerController, GoalTrackerState>(
  (ref) => GoalTrackerController(
    ref.read(budgetStateProvider.notifier),
  ),
);

class GoalTrackerController extends StateNotifier<GoalTrackerState> {
  final BudgetStateNotifier _budgetStateNotifier;
  GoalTrackerController(
    this._budgetStateNotifier,
  ) : super(const GoalTrackerState());

  String? _selectedCategory;
  String _amountText = '';
  String _frequencyText = ''; // Added this line
  String _trackerTypeText = '';

  String? get selectedCategory => _selectedCategory;
  String get amountText => _amountText;
  String get frequencyText => _frequencyText; // Added this line
  String get trackerTypeText => _trackerTypeText;

  void onCategoryChange(String value) {
    _selectedCategory = value;
    final category = Category.dirty(value);
    state = state.copyWith(
      category: category,
      status: Formz.validate([
        category,
        state.amount,
        state.frequency,
        state.tracker
      ]), // Updated this line
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
      status: Formz.validate([
        state.category,
        amount,
        state.frequency,
        state.tracker
      ]), // Updated this line
    );
    print('Amount: $value');
    print('Status: ${state.status}');
  }

  // Added this method
  void onFrequencyChange(String value) {
    _frequencyText = value;
    final frequency = Frequency.dirty(value);
    state = state.copyWith(
      frequency: frequency,
      status: Formz.validate(
          [state.category, state.amount, frequency, state.tracker]),
    );
    print('Frequency: $value');
    print('Status: ${state.status}');
  }

  void onTrackerTypeChange(String value) {
    _trackerTypeText = value;
    final tracker = Tracker.dirty(value);
    state = state.copyWith(
      tracker: tracker,
      status: Formz.validate(
          [state.category, state.amount, state.frequency, tracker]),
    );

    print('Tracker: $value');
    print('_amountText: $_amountText');
    print('_frequencyText: $_frequencyText');
    print('_selectedCategory: $_selectedCategory');
    print('Status: ${state.status}');
  }

  void reset() {
    _selectedCategory = null;
    _amountText = '';
    _frequencyText = '';
    _trackerTypeText = '';

    state = state.copyWith(
      category: Category.pure(),
      amount: Amount.pure(),
      frequency: Frequency.pure(),
      tracker: Tracker.pure(),
      status: FormzStatus.pure,
    );
  }

  Future<void> addGoalToBudget(
      String budgetId, Map<String, dynamic> goalData, WidgetRef ref) {
    return _budgetStateNotifier.addGoal(
        budgetId: budgetId, goalData: goalData, ref: ref);
  }
}
