import 'package:formz/formz.dart';

enum DiscretionaryAmountValidationError { empty }

class DiscretionaryAmount
    extends FormzInput<String, DiscretionaryAmountValidationError> {
  const DiscretionaryAmount.pure() : super.pure('');
  const DiscretionaryAmount.dirty([String value = '']) : super.dirty(value);

  @override
  DiscretionaryAmountValidationError? validator(String value) {
    return value.trim().isEmpty
        ? DiscretionaryAmountValidationError.empty
        : null;
  }

  static String? showDiscretionaryAmountErrorMessage(
      DiscretionaryAmountValidationError? error) {
    if (error == DiscretionaryAmountValidationError.empty) {
      return 'Please enter amount';
    } else {
      return null;
    }
  }
}
