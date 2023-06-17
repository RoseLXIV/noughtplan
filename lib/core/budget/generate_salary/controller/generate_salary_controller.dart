import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:uuid/uuid.dart'; // Replace with the correct path

part 'generate_salary_state.dart';

// Define a debounce duration
const Duration _debounceDuration = Duration(milliseconds: 300);

// Create a Timer instance
Timer? _debounceTimer;

final FocusNode _salaryFocusNode = FocusNode();

final generateSalaryProvider =
    StateNotifierProvider<GenerateSalaryController, GenerateSalaryState>(
  (ref) => GenerateSalaryController(
    ref.read(budgetStateProvider.notifier),
    // Replace with the correct provider
  ),
);

class GenerateSalaryController extends StateNotifier<GenerateSalaryState> {
  final BudgetStateNotifier
      _budgetStateNotifier; // Replace with the correct provider
  GenerateSalaryController(
    this._budgetStateNotifier,
  ) : super(const GenerateSalaryState());

  // void updateSalary(String value) {
  //   final salary = Salary.dirty(value);
  //   state = state.copyWith(
  //     salary: salary,
  //     status: Formz.validate([salary, state.currency, state.budgetType]),
  //   );
  // }
  // Future<void> setSalary(double salary) async {
  //   print('setSalary: $salary');
  //   final formattedSalary = NumberFormat('#,##0.00').format(salary);
  //   onSalaryChange(formattedSalary);
  //   state = state.copyWith(
  //     salary: Salary.dirty(formattedSalary),
  //   );
  // }

  Future<void> initializeSalary(double salary) async {
    print('initializeSalary: $salary');
    final formattedSalary = NumberFormat('#,##0.00').format(salary);
    onSalaryChange(formattedSalary);
  }

  Future<void> initializeCurrency(String currency) async {
    print('initializeCurrency: $currency');
    onCurrencyChange(currency);
  }

  Future<void> initializeBudgetType(String budgetType) async {
    print('initializeBudgetType: $budgetType');
    onBudgetTypeChange(budgetType);
  }

  void onSalaryChange(String value) {
    // Cancel the previous timer if it's still active
    _debounceTimer?.cancel();

    // Start a new timer to debounce the execution
    _debounceTimer = Timer(_debounceDuration, () {
      print('onSalaryChange: $value');
      if (value.isNotEmpty) {
        // Remove commas from the salary value
        String sanitizedValue = value.replaceAll(',', '');

        // Only update the state if the value actually changes
        if (mounted && sanitizedValue != state.salary.value) {
          final salary = Salary.dirty(sanitizedValue);

          // Check if the sanitized value is zero or invalid
          if (sanitizedValue == "0" || salary.invalid) {
            state = state.copyWith(
              salary: salary,
              status: FormzStatus.invalid,
            );
          } else {
            state = state.copyWith(
              salary: salary,
              status:
                  Formz.validate([salary, state.currency, state.budgetType]),
            );
          }
        }
      } else {
        // If the value is empty, set the salary to empty and mark as invalid
        final salary = Salary.dirty(value);
        state = state.copyWith(
          salary: salary,
          status: FormzStatus.invalid,
        );
      }
    });
  }

  void onCurrencyChange(String value) {
    final currency = Currency.dirty(value);
    state = state.copyWith(
      currency: currency,
      status: Formz.validate([state.salary, currency, state.budgetType]),
    );
  }

  void onBudgetTypeChange(String value) {
    final budgetType = BudgetType.dirty(value);
    state = state.copyWith(
      budgetType: budgetType,
      status: Formz.validate([state.salary, state.currency, budgetType]),
    );
  }

  Future<bool> saveBudgetInfo() async {
    if (!state.status.isValidated) {
      return false;
    }
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      String salaryWithoutCommas = state.salary.value.replaceAll(',', '');
      double salary = double.parse(salaryWithoutCommas);

      var uuid = Uuid();
      String budgetId = uuid.v4();

      state = state.copyWith(budgetId: budgetId);

      await _budgetStateNotifier.saveBudgetInfoSubscriber(
        budgetId: budgetId,
        salary: salary,
        currency: state.currency.value,
        budgetType: state.budgetType.value,
      );
      print('Successfully saved budget info');
      state = state.copyWith(
          status: FormzStatus.submissionSuccess, budgetId: budgetId);
      return true;
    } catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: 'Error: $e');
      print('Error: $e');
      return false;
    } finally {
      state = state.copyWith(status: FormzStatus.pure);
    }
  }

  Future<bool> saveBudgetInfoUpdate(BudgetId budgetId) async {
    if (!state.status.isValidated) {
      return false;
    }
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      String salaryWithoutCommas = state.salary.value.replaceAll(',', '');
      double salary = double.parse(salaryWithoutCommas);

      await _budgetStateNotifier.saveBudgetInfoUpdate(
        budgetId: budgetId,
        salary: salary,
        currency: state.currency.value,
        budgetType: state.budgetType.value,
      );
      print('Successfully saved budget info');
      state = state.copyWith(
          status: FormzStatus.submissionSuccess, budgetId: budgetId);
      return true;
    } catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: 'Error: $e');
      print('Error: $e');
      return false;
    } finally {
      state = state.copyWith(status: FormzStatus.pure);
    }
  }
}
