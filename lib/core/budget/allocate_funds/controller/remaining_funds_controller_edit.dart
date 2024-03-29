// remaining_funds_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller.dart';
import 'package:noughtplan/core/budget/generate_salary/controller/generate_salary_controller_edit.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/widgets/listdiscretionary_item_widget.dart';
import 'package:noughtplan/presentation/allocate_funds_screen_edit/widgets/listdiscretionary_item_widget_edit.dart';

class RemainingFundsControllerEdit extends StateNotifier<double> {
  double _previousFunds;
  double _initialValue;
  double _initialRemainingFunds;

  final EditedCategoriesDiscretionaryControllerEdit
      editedCategoriesControllerEdit;

  RemainingFundsControllerEdit({
    required double initialValue,
    required this.editedCategoriesControllerEdit,
  })  : _previousFunds = initialValue,
        _initialValue = initialValue,
        _initialRemainingFunds = initialValue,
        super(initialValue);

  void updateFunds(double amount, double oldAmount) {
    _previousFunds = state;

    state = state - amount + oldAmount;
  }

  void updateFundsForAutoAssign(
      WidgetRef ref, double amount, double necessaryTotal, double editedTotal) {
    double editedTotal = ref
        .read(enteredAmountsDiscretionaryProvider.notifier)
        .getEditedAmounts(ref);
    state = _initialValue - necessaryTotal - editedTotal;

    state = state - amount;
  }

  void resetRemainingFunds(WidgetRef ref, double necessaryTotal,
      double editedTotal, double debtTotal) {
    state = _initialRemainingFunds - necessaryTotal - debtTotal - editedTotal;
  }

  double get stateFunds => state;

  void resetFundsNecessary(double discretionaryTotal, double debtTotal) {
    state = _initialValue - discretionaryTotal - debtTotal;
  }

  void resetFundsDiscretionary(double necessaryTotal, double debtTotal) {
    state = _initialValue - necessaryTotal - debtTotal;

    resetEditedFlagsDiscretionary();
  }

  void resetFundsDebt(double necessaryTotal, double discretionaryTotal) {
    state = _initialValue - necessaryTotal - discretionaryTotal;
  }

  void resetEditedFlagsDiscretionary() {
    // Get the discretionary category keys
    final categoryKeys = editedCategoriesControllerEdit.state.keys.toList();

    // Set the 'edited' flag for all categories to false
    categoryKeys.forEach((category) {
      editedCategoriesControllerEdit.setEdited(category, false);
    });
  }

  void setInitialValue(double value) {
    state = value;
  }

  Future<void> updateInitialValue(double value) async {
    if (mounted) {
      await Future.delayed(Duration.zero);
      if (mounted) {
        state = value;
      }
    }
  }

  double get initialValue => _initialValue;
}

final remainingFundsProviderEdit =
    StateNotifierProvider.autoDispose<RemainingFundsControllerEdit, double>(
        (ref) {
  final generateSalaryState = ref.watch(generateSalaryProviderEdit);
  final salary = generateSalaryState.salary.value;
  final salaryDouble = double.tryParse(salary) ?? 0.0;
  print('salaryDouble: $salaryDouble');

  final editedCategoriesControllerEdit =
      ref.watch(editedCategoriesDiscretionaryProviderEdit.notifier);

  return RemainingFundsControllerEdit(
    initialValue: salaryDouble,
    editedCategoriesControllerEdit: editedCategoriesControllerEdit,
  );
});
