import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/budget/models/budget_state.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_debt_categories_storage.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_discretionary_categories_storage.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_necessary_categories_storage.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_info_storage.dart';

class BudgetStateNotifier extends StateNotifier<BudgetState> {
  final Authenticator _authenticator;
  final BudgetInfoStorage _budgetInfoStorage;
  final BudgetNecessaryInfoStorage _budgetNecessaryInfoStorage;
  final BudgetDebtInfoStorage _budgetDebtInfoStorage;
  final BudgetDiscretionaryInfoStorage _budgetDiscretionaryInfoStorage;

  BudgetStateNotifier(this._authenticator)
      : _budgetInfoStorage = const BudgetInfoStorage(),
        _budgetNecessaryInfoStorage = const BudgetNecessaryInfoStorage(),
        _budgetDebtInfoStorage = const BudgetDebtInfoStorage(),
        _budgetDiscretionaryInfoStorage =
            const BudgetDiscretionaryInfoStorage(),
        super(const BudgetState.unknown()) {
    // fetchSalary();
  }

  Future<void> saveBudgetInfo({
    required double salary,
    required String currency,
    required String budgetType,
  }) async {
    state = state.copiedWithIsLoading(true);

    // Get the user ID from the Authenticator
    final userId = _authenticator.userId;
    print(userId);

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

  // Future<void> fetchSalary() async {
  //   state = state.copiedWithIsLoading(true);

  //   final userId = _authenticator.userId;
  //   print(userId);

  //   if (userId == null) {
  //     state = BudgetState(
  //       status: BudgetStatus.failure,
  //       isLoading: false,
  //       userId: null,
  //     );
  //     return;
  //   }

  //   try {
  //     final salary = await _budgetInfoStorage.fetchSalary(userId);
  //     print('Salary: $salary');
  //     state = state.copyWithSalary(salary);
  //     state = BudgetState(
  //       status: BudgetStatus.success,
  //       isLoading: false,
  //       userId: userId,
  //     ).copiedWithIsLoading(false);
  //   } catch (e) {
  //     state = BudgetState(
  //       status: BudgetStatus.failure,
  //       isLoading: false,
  //       userId: userId,
  //     );
  //   }
  // }

  Future<void> saveBudgetNecessaryInfo({
    required Map<String, double> necessaryExpense,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(userId);

    if (userId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
      );
      return;
    }

    final result = await _budgetNecessaryInfoStorage.saveBudgetNecessaryInfo(
      id: userId,
      necessaryExpense: necessaryExpense,
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

  Future<void> saveBudgetDebtInfo({
    required Map<String, double> debtExpense,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(userId);

    if (userId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
      );
      return;
    }

    final result = await _budgetDebtInfoStorage.saveBudgetDebtInfo(
      id: userId,
      debtExpense: debtExpense,
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

  Future<void> saveBudgetDiscretionaryInfo({
    required Map<String, double> discretionaryExpense,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(userId);

    if (userId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
      );
      return;
    }

    final result =
        await _budgetDiscretionaryInfoStorage.saveBudgetDiscretionaryInfo(
      id: userId,
      discretionaryExpense: discretionaryExpense,
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
