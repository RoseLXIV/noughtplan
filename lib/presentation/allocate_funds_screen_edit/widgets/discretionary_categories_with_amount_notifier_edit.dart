import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscretionaryCategoriesWithAmountNotifierEdit
    extends StateNotifier<Map<String, double>> {
  DiscretionaryCategoriesWithAmountNotifierEdit() : super({});

  void updateCategoryAmount(String category, double amount) {
    state = {
      ...state,
      category: amount,
    };
  }

  void clearCategoriesAmount() {
    state = {};
  }
}

final discretionaryCategoriesWithAmountProviderEdit = StateNotifierProvider<
        DiscretionaryCategoriesWithAmountNotifierEdit, Map<String, double>>(
    (ref) => DiscretionaryCategoriesWithAmountNotifierEdit());
