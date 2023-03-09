import 'package:formz/formz.dart';

class TermsAndCondition extends FormzInput<bool, bool> {
  const TermsAndCondition.pure() : super.pure(false);
  const TermsAndCondition.dirty([bool value = false]) : super.dirty(value);

  @override
  bool? validator(bool? value) {
    return value == true ? null : false;
  }
}
