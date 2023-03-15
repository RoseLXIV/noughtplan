import 'package:formz/formz.dart';

enum CurrencyValidationError { invalid }

class Currency extends FormzInput<String, CurrencyValidationError> {
  const Currency.pure() : super.pure('');
  const Currency.dirty([String value = '']) : super.dirty(value);

  @override
  CurrencyValidationError? validator(String value) {
    // Add the list of supported currency codes.
    List<String> supportedCurrencies = [
      'USD',
      'JMD',
    ];

    return supportedCurrencies.contains(value)
        ? null
        : CurrencyValidationError.invalid;
  }

  static String? showCurrencyErrorMessage(CurrencyValidationError? error) {
    if (error == CurrencyValidationError.invalid) {
      return 'Required';
    } else {
      return null;
    }
  }
}
