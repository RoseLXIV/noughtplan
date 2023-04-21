import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/widgets/actual_expenses_notifier.dart';

final actualExpensesProvider =
    StateNotifierProvider<ActualExpensesNotifier, List<Map<String, dynamic>>>(
        (ref) {
  return ActualExpensesNotifier();
});
