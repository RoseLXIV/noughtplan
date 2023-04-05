import 'package:formz/formz.dart';

enum NecessaryAmountValidationError { empty }

class NecessaryAmount
    extends FormzInput<String, NecessaryAmountValidationError> {
  const NecessaryAmount.pure() : super.pure('');
  const NecessaryAmount.dirty([String value = '']) : super.dirty(value);

  @override
  NecessaryAmountValidationError? validator(String value) {
    return value.trim().isEmpty ? NecessaryAmountValidationError.empty : null;
  }

  static String? showNecessaryAmountErrorMessage(
      NecessaryAmountValidationError? error) {
    if (error == NecessaryAmountValidationError.empty) {
      return 'Please enter amount';
    } else {
      return null;
    }
  }
}
