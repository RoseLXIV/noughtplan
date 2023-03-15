import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/budget/models/budget_state.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_info_storage.dart';

class BudgetStateNotifier extends StateNotifier<BudgetState> {
  final Authenticator _authenticator;
  final BudgetInfoStorage _budgetInfoStorage;

  BudgetStateNotifier(this._authenticator)
      : _budgetInfoStorage = const BudgetInfoStorage(),
        super(const BudgetState.unknown());

  Future<void> saveBudgetInfo({
    required double salary,
    required String currency,
    required String budgetType,
  }) async {
    state = state.copiedWithIsLoading(true);

    // Get the user ID from the Authenticator
    final userId = _authenticator.userId;

    // Ensure userId is not null before proceeding
    if (userId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
      );
      return;
    }

    final result = await _budgetInfoStorage.saveBudgetInfo(
      id: userId,
      salary: salary,
      currency: currency,
      budgetType: budgetType,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
      );
    }
  }
}
