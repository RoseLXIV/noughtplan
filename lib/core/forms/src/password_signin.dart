import 'package:formz/formz.dart';

enum PasswordValidationErrorSignIn { empty, invalid, pattern }

final passwordRegexSignIn =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

class PasswordSignIn extends FormzInput<String, PasswordValidationErrorSignIn> {
  const PasswordSignIn.pure() : super.pure('');
  const PasswordSignIn.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationErrorSignIn? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationErrorSignIn.empty;
    } else if (value.length < 8) {
      return PasswordValidationErrorSignIn.invalid;
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(value)) {
      return PasswordValidationErrorSignIn.pattern;
    } else {
      return null;
    }
  }

  static String? showPasswordErrorMessage(
      PasswordValidationErrorSignIn? error) {
    if (error == PasswordValidationErrorSignIn.empty) {
      return '';
    } else if (error == PasswordValidationErrorSignIn.invalid) {
      return 'Password is Invalid';
    } else if (error == PasswordValidationErrorSignIn.pattern) {
      return 'Password is Invalid';
    } else {
      return null;
    }
  }
}
