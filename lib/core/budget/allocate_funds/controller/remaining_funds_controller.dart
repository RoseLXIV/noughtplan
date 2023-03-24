// remaining_funds_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';

class RemainingFundsController extends StateNotifier<double> {
  double _previousFunds;
  double _initialValue;

  RemainingFundsController(double initialValue)
      : _previousFunds = initialValue,
        _initialValue = initialValue,
        super(initialValue);

  void updateFunds(double amount, double oldAmount) {
    _previousFunds = state;
    print('RemainingFundsController - Previous: $_previousFunds');
    state = state - amount + oldAmount;
    print('RemainingFundsController - Updated State: $state');
    print('RemainingFundsController - Updated amount: $amount');
    print('RemainingFundsController - Updated oldAmount: $oldAmount');
    print('RemainingFundsController - Updated funds: $state');
  }

  void resetFunds() {
    state = _initialValue;
    // _previousFunds = _initialValue;
    print('RemainingFundsController - Reset funds: $state');
  }
}

final remainingFundsProvider =
    StateNotifierProvider.autoDispose<RemainingFundsController, double>((ref) {
  final generateSalaryState = ref.watch(generateSalaryProvider);
  final salary = generateSalaryState.salary.value;
  final salaryDouble = double.tryParse(salary) ?? 0.0;
  return RemainingFundsController(salaryDouble);
});
