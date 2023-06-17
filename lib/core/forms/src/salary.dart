import 'package:formz/formz.dart';

enum SalaryValidationError { invalid }

class Salary extends FormzInput<String, SalaryValidationError> {
  const Salary.pure() : super.pure('');
  const Salary.dirty([String value = '']) : super.dirty(value);

  static final _salaryRegExp = RegExp(r'^\d+(\.\d{1,2})?$');

  @override
  SalaryValidationError? validator(String value) {
    if (!_salaryRegExp.hasMatch(value) || double.parse(value) == 0) {
      return SalaryValidationError.invalid;
    }
    return null;
  }

  static String? showSalaryErrorMessage(SalaryValidationError? error) {
    if (error == SalaryValidationError.invalid) {
      return 'Please enter a valid salary amount';
    } else {
      return null;
    }
  }
}
