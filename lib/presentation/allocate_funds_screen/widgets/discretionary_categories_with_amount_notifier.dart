import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscretionaryCategoriesWithAmountNotifier
    extends StateNotifier<Map<String, double>> {
  DiscretionaryCategoriesWithAmountNotifier() : super({});

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

final discretionaryCategoriesWithAmountProvider = StateNotifierProvider<
    DiscretionaryCategoriesWithAmountNotifier,
    Map<String, double>>((ref) => DiscretionaryCategoriesWithAmountNotifier());
