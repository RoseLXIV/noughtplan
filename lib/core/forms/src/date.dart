import 'package:formz/formz.dart';

enum DateValidationError { empty }

class Date extends FormzInput<DateTime?, DateValidationError> {
  const Date.pure() : super.pure(null);
  const Date.dirty([DateTime? value]) : super.dirty(value);

  @override
  DateValidationError? validator(DateTime? value) {
    return value == null ? DateValidationError.empty : null;
  }

  static String? showDateErrorMessage(DateValidationError? error) {
    if (error == DateValidationError.empty) {
      return 'Please select a date';
    } else {
      return null;
    }
  }
}
