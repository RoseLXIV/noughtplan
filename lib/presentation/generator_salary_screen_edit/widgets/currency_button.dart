import 'package:hooks_riverpod/hooks_riverpod.dart';

class Currency {
  final String code;
  final String flagImagePath;

  Currency(this.code, this.flagImagePath);
}

final List<Currency> currencies = [
  Currency('USD', 'assets/images/usa_flag.png'),
  Currency('EUR', 'assets/images/eu_flag.png'),
  Currency('JPY', 'assets/images/japan_flag.png'),
  Currency('GBP', 'assets/images/uk_flag.png'),
  Currency('AUD', 'assets/images/australia_flag.png'),
];

final selectedCurrencyProvider = StateProvider((ref) => currencies[0]);
