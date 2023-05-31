import 'package:formz/formz.dart';

enum FrequencyValidationError { empty }

class Frequency extends FormzInput<String, FrequencyValidationError> {
  const Frequency.pure() : super.pure('');
  const Frequency.dirty([String value = '']) : super.dirty(value);

  @override
  FrequencyValidationError? validator(String value) {
    return value.trim().isEmpty ? FrequencyValidationError.empty : null;
  }

  static String? showFrequencyErrorMessage(FrequencyValidationError? error) {
    if (error == FrequencyValidationError.empty) {
      return 'Please select frequency of payment';
    } else {
      return null;
    }
  }
}
