import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';

part 'custom_goal_tracker_state.dart';

final customGoalTrackerProvider =
    StateNotifierProvider<CustomGoalTrackerController, CustomGoalTrackerState>(
  (ref) => CustomGoalTrackerController(
    ref.read(budgetStateProvider.notifier),
  ),
);

class CustomGoalTrackerController
    extends StateNotifier<CustomGoalTrackerState> {
  final BudgetStateNotifier _budgetStateNotifier;
  CustomGoalTrackerController(
    this._budgetStateNotifier,
  ) : super(const CustomGoalTrackerState());

  String? _goalName = '';
  String _amountText = '';
  String _recurringAmountText = '';
  String _frequencyText = '';
  String _trackerTypeText = '';

  String? get goalName => _goalName;
  String get amountText => _amountText;
  String get recurringAmountText => _recurringAmountText;
  String get frequencyText => _frequencyText;
  String get trackerTypeText => _trackerTypeText;

  void onCategoryChange(String value) {
    _goalName = value;
    final category = Category.dirty(value);
    state = state.copyWith(
      category: category,
      status: Formz.validate([
        category,
        state.amount,
        state.recurringAmount,
        state.frequency,
        state.tracker,
      ]),
    );
    print('Category: $value');
    print('Status: ${state.status}');
  }

  void onAmountChange(String value) {
    _amountText = value;
    String sanitizedValue = value.replaceAll(',', '');

    final amount = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      amount: amount,
      status: Formz.validate([
        state.category,
        amount,
        state.recurringAmount,
        state.frequency,
        state.tracker,
      ]),
    );
    print('Amount: $value');
    print('Status: ${state.status}');
  }

  void onRecurringAmountChange(String value) {
    _recurringAmountText = value;
    String sanitizedValue = value.replaceAll(',', '');

    final recurringAmount = Amount.dirty(sanitizedValue);
    state = state.copyWith(
      recurringAmount: recurringAmount,
      status: Formz.validate([
        state.category,
        state.amount,
        recurringAmount,
        state.frequency,
        state.tracker,
      ]),
    );
    print('Recurring Amount: $value');
    print('Status: ${state.status}');
  }

  void onFrequencyChange(String value) {
    _frequencyText = value;
    final frequency = Frequency.dirty(value);
    state = state.copyWith(
      frequency: frequency,
      status: Formz.validate([
        state.category,
        state.amount,
        state.recurringAmount,
        frequency,
        state.tracker,
      ]),
    );
    print('Frequency: $value');
    print('Status: ${state.status}');
  }

  void onTrackerTypeChange(String value) {
    _trackerTypeText = value;
    final tracker = Tracker.dirty(value);
    state = state.copyWith(
      tracker: tracker,
      status: Formz.validate([
        state.category,
        state.amount,
        state.recurringAmount,
        state.frequency,
        tracker,
      ]),
    );
    print('Tracker: $value');
    print('Status: ${state.status}');
  }

  void reset() {
    _goalName = '';
    _amountText = '';
    _recurringAmountText = '';
    _frequencyText = '';
    _trackerTypeText = '';

    state = state.copyWith(
      category: Category.pure(),
      amount: Amount.pure(),
      recurringAmount: Amount.pure(),
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

  Future<void> addCustomCategory(
      String budgetId, String newCategory, double newAmount) {
    return _budgetStateNotifier.addCustomCategoryToNecessaryExpense(
        budgetId: budgetId, newCategory: newCategory, newAmount: newAmount);
  }
}
