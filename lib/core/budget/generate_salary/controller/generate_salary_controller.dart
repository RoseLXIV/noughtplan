import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart'; // Replace with the correct path

part 'generate_salary_state.dart';

final generateSalaryProvider = StateNotifierProvider.autoDispose<
    GenerateSalaryController, GenerateSalaryState>(
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

  void onSalaryChange(String value) {
    // Remove commas from the salary value
    String sanitizedValue = value.replaceAll(',', '');

    final salary = Salary.dirty(sanitizedValue);
    state = state.copyWith(
      salary: salary,
      status: Formz.validate([salary, state.currency, state.budgetType]),
    );
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
      await _budgetStateNotifier.saveBudgetInfo(
        salary: salary,
        currency: state.currency.value,
        budgetType: state.budgetType.value,
      );
      print('Successfully saved budget info');
      state = state.copyWith(status: FormzStatus.submissionSuccess);
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
