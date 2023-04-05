import 'package:formz/formz.dart';

enum AmountValidationError { empty }

class Amount extends FormzInput<String, AmountValidationError> {
  const Amount.pure() : super.pure('');
  const Amount.dirty([String value = '']) : super.dirty(value);

  @override
  AmountValidationError? validator(String value) {
    return value.trim().isEmpty ? AmountValidationError.empty : null;
  }

  static String? showAmountErrorMessage(AmountValidationError? error) {
    if (error == AmountValidationError.empty) {
      return 'Please enter amount';
    } else {
      return null;
    }
  }
}
