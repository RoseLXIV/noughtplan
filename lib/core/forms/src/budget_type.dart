import 'package:formz/formz.dart';

enum BudgetTypeValidationError { invalid }

class BudgetType extends FormzInput<String, BudgetTypeValidationError> {
  const BudgetType.pure() : super.pure('');
  const BudgetType.dirty([String value = '']) : super.dirty(value);

  @override
  BudgetTypeValidationError? validator(String value) {
    // Update the list of supported budget types.
    List<String> supportedBudgetTypes = [
      'Zero-Based Budgeting',
    ];

    return supportedBudgetTypes.contains(value)
        ? null
        : BudgetTypeValidationError.invalid;
  }

  static String? showBudgetTypeErrorMessage(BudgetTypeValidationError? error) {
    if (error == BudgetTypeValidationError.invalid) {
      return 'Required';
    } else {
      return null;
    }
  }
}
