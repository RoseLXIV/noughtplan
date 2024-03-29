// remaining_funds_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdiscretionary_item_widget.dart';

class RemainingFundsController extends StateNotifier<double> {
  double _previousFunds;
  double _initialValue;
  double _initialRemainingFunds;

  final EditedCategoriesDiscretionaryController editedCategoriesController;

  RemainingFundsController({
    required double initialValue,
    required this.editedCategoriesController,
  })  : _previousFunds = initialValue,
        _initialValue = initialValue,
        _initialRemainingFunds = initialValue,
        super(initialValue);

  void updateFunds(double amount, double oldAmount) {
    _previousFunds = state;

    state = state - amount + oldAmount;
  }

  void updateFundsForAutoAssign(
      WidgetRef ref,
      double amount,
      double necessaryTotal,
      double editedTotal,
      double debtTotal,
      double savingsTotal) {
    double editedTotal = ref
        .read(enteredAmountsDiscretionaryProvider.notifier)
        .getEditedAmounts(ref);
    state =
        _initialValue - necessaryTotal - editedTotal - debtTotal - savingsTotal;

    state = state - amount;
  }

  void resetRemainingFunds(WidgetRef ref, double necessaryTotal,
      double editedTotal, double debtTotal, double savingsTotal) {
    state = _initialRemainingFunds -
        necessaryTotal -
        debtTotal -
        savingsTotal -
        editedTotal;
  }

  double get stateFunds => state;

  void resetFundsNecessary(
      double discretionaryTotal, double debtTotal, double savingsTotal) {
    state = _initialValue - discretionaryTotal - debtTotal - savingsTotal;
  }

  void resetFundsDiscretionary(
      double necessaryTotal, double debtTotal, double savingsTotal) {
    state = _initialValue - necessaryTotal - debtTotal - savingsTotal;

    resetEditedFlagsDiscretionary();
  }

  void resetFundsDebt(
      double necessaryTotal, double discretionaryTotal, double savingsTotal) {
    state = _initialValue - necessaryTotal - discretionaryTotal - savingsTotal;
  }

  void resetFundsSavings(
      double necessaryTotal, double discretionaryTotal, double debtTotal) {
    state = _initialValue - necessaryTotal - discretionaryTotal - debtTotal;
  }

  void resetEditedFlagsDiscretionary() {
    // Get the discretionary category keys
    final categoryKeys = editedCategoriesController.state.keys.toList();

    // Set the 'edited' flag for all categories to false
    categoryKeys.forEach((category) {
      editedCategoriesController.setEdited(category, false);
    });
  }

  void setInitialValue(double value) {
    state = value;
  }

  Future<void> updateSalary(double salary) async {
    _initialValue = salary;
    state = salary;
  }

  Future<void> updateInitialValue(double value) async {
    await Future.delayed(Duration.zero);
    if (mounted) {
      state = value;
    }
  }

  double get initialValue => _initialValue;
}

final remainingFundsProvider =
    StateNotifierProvider.autoDispose<RemainingFundsController, double>((ref) {
  final generateSalaryState = ref.watch(generateSalaryProvider);
  final salary = generateSalaryState.salary.value;
  final salaryDouble = double.tryParse(salary) ?? 0.0;

  final editedCategoriesController =
      ref.watch(editedCategoriesDiscretionaryProvider.notifier);

  return RemainingFundsController(
    initialValue: salaryDouble,
    editedCategoriesController: editedCategoriesController,
  );
});
