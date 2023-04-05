import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/budget/notifiers/budget_state_notifier.dart'; // Replace with the correct path

part 'allocate_funds_state.dart';

final allocateFundsProvider = StateNotifierProvider.autoDispose<
    AllocateFundsController, AllocateFundsState>(
  (ref) => AllocateFundsController(
    ref.read(budgetStateProvider.notifier),
  ),
);

class AllocateFundsController extends StateNotifier<AllocateFundsState> {
  final BudgetStateNotifier _budgetStateNotifier;

  AllocateFundsController(
    this._budgetStateNotifier,
  ) : super(const AllocateFundsState());

  void onAmountChange(String value) {
    final amount = Amount.dirty(value);
    state = state.copyWith(
      amount: amount,
      status: Formz.validate(
          [amount, state.necessaryAmount, state.discretionaryAmount]),
    );
  }

  void onNecessaryAmountChange(String value) {
    final necessaryAmount = NecessaryAmount.dirty(value);
    state = state.copyWith(
      necessaryAmount: necessaryAmount,
      status: Formz.validate(
          [state.amount, necessaryAmount, state.discretionaryAmount]),
    );
  }

  void onDiscretionaryAmountChange(String value) {
    final discretionaryAmount = DiscretionaryAmount.dirty(value);
    state = state.copyWith(
      discretionaryAmount: discretionaryAmount,
      status: Formz.validate(
          [state.amount, state.necessaryAmount, discretionaryAmount]),
    );
  }

  void resetValidationNecessary() {
    state = state.copyWith(
      necessaryAmount: const NecessaryAmount.pure(),
      status: Formz.validate([
        state.amount,
        state.discretionaryAmount,
        const NecessaryAmount.pure()
      ]),
    );
  }

  void resetValidationDiscretionary() {
    state = state.copyWith(
      discretionaryAmount: const DiscretionaryAmount.pure(),
      status: Formz.validate([
        state.amount,
        state.necessaryAmount,
        const DiscretionaryAmount.pure()
      ]),
    );
  }

  void resetValidationDebt() {
    state = state.copyWith(
      amount: const Amount.pure(),
      status: Formz.validate([
        state.necessaryAmount,
        state.discretionaryAmount,
        const Amount.pure()
      ]),
    );
  }

  void initialValidationNecessary(String inputAmount) {
    if (inputAmount.isNotEmpty && double.parse(inputAmount) > 0) {
      final necessaryAmount = NecessaryAmount.dirty(inputAmount);
      state = state.copyWith(
        necessaryAmount: necessaryAmount,
        status: Formz.validate(
            [state.amount, necessaryAmount, state.discretionaryAmount]),
      );
    }
  }

  void initialValidationDiscretionary(String inputAmount) {
    if (inputAmount.isNotEmpty && double.parse(inputAmount) > 0) {
      final discretionaryAmount = DiscretionaryAmount.dirty(inputAmount);
      state = state.copyWith(
        discretionaryAmount: discretionaryAmount,
        status: Formz.validate(
            [state.amount, state.necessaryAmount, discretionaryAmount]),
      );
    }
  }

  void initialValidationDebt(String inputAmount) {
    if (inputAmount.isNotEmpty && double.parse(inputAmount) > 0) {
      final amount = Amount.dirty(inputAmount);
      state = state.copyWith(
        amount: amount,
        status: Formz.validate(
            [amount, state.necessaryAmount, state.discretionaryAmount]),
      );
    }
  }

  Future<bool> saveBudgetInfo() async {
    if (!state.status.isValidated) {
      return false;
    }
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
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
