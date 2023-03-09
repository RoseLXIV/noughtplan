import 'package:formz/formz.dart';

enum PasswordValidationError { empty, invalid, pattern }

final passwordRegex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.invalid;
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(value)) {
      return PasswordValidationError.pattern;
    } else {
      return null;
    }
  }

  static String? showPasswordErrorMessage(PasswordValidationError? error) {
    if (error == PasswordValidationError.empty) {
      return 'Please enter a password';
    } else if (error == PasswordValidationError.invalid) {
      return 'Your password must be at least 8 characters long';
    } else if (error == PasswordValidationError.pattern) {
      return 'Password needs uppercase, lowercase, and numbers';
    } else {
      return null;
    }
  }
}
