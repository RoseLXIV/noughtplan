import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/budget/models/budget_state.dart';
import 'package:noughtplan/core/budget/models/budget_status.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_debt_categories_storage.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_discretionary_categories_storage.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_id_storage.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_necessary_categories_storage.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/budget_info/models/backend/budget_info_storage.dart';

class BudgetStateNotifier extends StateNotifier<BudgetState> {
  final Authenticator _authenticator;
  final BudgetInfoStorage _budgetInfoStorage;
  final BudgetNecessaryInfoStorage _budgetNecessaryInfoStorage;
  final BudgetDebtInfoStorage _budgetDebtInfoStorage;
  final BudgetDiscretionaryInfoStorage _budgetDiscretionaryInfoStorage;
  final BudgetIdStorage _budgetIdStorage;

  BudgetStateNotifier(this._authenticator)
      : _budgetInfoStorage = const BudgetInfoStorage(),
        _budgetNecessaryInfoStorage = const BudgetNecessaryInfoStorage(),
        _budgetDebtInfoStorage = const BudgetDebtInfoStorage(),
        _budgetDiscretionaryInfoStorage =
            const BudgetDiscretionaryInfoStorage(),
        _budgetIdStorage = const BudgetIdStorage(),
        super(const BudgetState.unknown()) {
    // fetchSalary();
  }

  Future<void> saveBudgetInfo({
    required BudgetId budgetId,
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
        budgets: [],
      );
      return;
    }

    final result = await _budgetInfoStorage.saveBudgetInfo(
      id: userId,
      budgetId: budgetId,
      salary: salary,
      currency: currency,
      budgetType: budgetType,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> saveBudgetInfoSubscriber({
    required BudgetId budgetId,
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
        budgets: [],
      );
      return;
    }

    final result = await _budgetInfoStorage.saveBudgetInfoSubscriber(
      id: userId,
      budgetId: budgetId,
      salary: salary,
      currency: currency,
      budgetType: budgetType,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
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
    required budgetId,
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
        budgets: [],
      );
      return;
    }

    final result = await _budgetNecessaryInfoStorage.saveBudgetNecessaryInfo(
      budgetId: budgetId,
      necessaryExpense: necessaryExpense,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> saveBudgetDebtInfo({
    required String? budgetId,
    required Map<String, double> debtExpense,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(budgetId);

    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    final result = await _budgetDebtInfoStorage.saveBudgetDebtInfo(
      budgetId: budgetId,
      debtExpense: debtExpense,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> saveBudgetDiscretionaryInfo({
    required String? budgetId,
    required Map<String, double> discretionaryExpense,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(budgetId);

    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    final result =
        await _budgetDiscretionaryInfoStorage.saveBudgetDiscretionaryInfo(
      budgetId: budgetId,
      discretionaryExpense: discretionaryExpense,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> updateAmounts({
    required String? budgetId,
    required Map<String, double> necessaryAmounts,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    // print(userId);

    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    final result = await _budgetInfoStorage.updateAmounts(
      budgetId: budgetId,
      necessaryAmounts: necessaryAmounts,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> updateDiscretionaryAmounts({
    required String? budgetId,
    required Map<String, double> discretionaryAmounts,
  }) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(budgetId);

    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    final result =
        await _budgetDiscretionaryInfoStorage.updateDiscretionaryAmounts(
      budgetId: budgetId,
      discretionaryAmounts: discretionaryAmounts,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> updateDebtAmounts(
      {required String? budgetId,
      required Map<String, double> debtAmounts}) async {
    state = state.copiedWithIsLoading(true);

    final userId = _authenticator.userId;
    print(budgetId);

    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    final result = await _budgetDebtInfoStorage.updateDebtAmounts(
      budgetId: budgetId,
      debtAmounts: debtAmounts,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> saveBudgetId({
    required BudgetId budgetId,
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
        budgets: [],
      );
      return;
    }

    final result = await _budgetIdStorage.saveBudgetId(
      userId: userId,
      id: budgetId,
    );
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> updateSurplus({
    required String? budgetId,
    required double remainingFunds,
  }) async {
    final userId = _authenticator.userId;
    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    state = state.copiedWithIsLoading(true);

    final result = await _budgetInfoStorage.updateSurplus(
      budgetId: budgetId,
      remainingFunds: remainingFunds,
    );

    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> deleteZeroValueCategories({required String? budgetId}) async {
    final userId = _authenticator.userId;
    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return;
    }

    state = state.copiedWithIsLoading(true);

    final result =
        await _budgetInfoStorage.deleteZeroValueCategories(budgetId: budgetId);
    await _budgetDiscretionaryInfoStorage
        .deleteZeroValueDiscretionaryCategories(budgetId: budgetId);
    await _budgetDebtInfoStorage.deleteZeroValueDebtCategories(
        budgetId: budgetId);

    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    // Call the deleteBudget function from BudgetInfoStorage
    final result = await _budgetInfoStorage.deleteBudget(budgetId);

    // If the budget is successfully deleted, update the UI
    if (result) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: _authenticator.userId,
        budgets: [], // Update this to remove the deleted budget from the list
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: _authenticator.userId,
        budgets: [], // Update this to keep the current list of budgets
      );
    }
  }

  Future<String?> updateSpendingType({
    required String? budgetId,
    required double totalNecessaryExpense,
    required double totalDiscretionaryExpense,
  }) async {
    final userId = _authenticator.userId;
    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return null;
    }

    state = state.copiedWithIsLoading(true);

    final spendingType = await _budgetInfoStorage.updateSpendingType(
      budgetId: budgetId,
      totalNecessaryExpense: totalNecessaryExpense,
      totalDiscretionaryExpense: totalDiscretionaryExpense,
    );

    if (spendingType != null) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
      return spendingType;
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
      return null;
    }
  }

  Future<String?> updateSavingType({
    required String? budgetId,
    required String spendingType,
    required double totalSavings,
    required double salary,
  }) async {
    final userId = _authenticator.userId;
    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return null;
    }

    state = state.copiedWithIsLoading(true);

    final savingType = await _budgetInfoStorage.updateSavingType(
      budgetId: budgetId,
      spendingType: spendingType,
      totalSavings: totalSavings,
      salary: salary,
    );

    if (savingType != null) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: userId,
        budgets: [],
      );
    }

    return savingType;
  }

  Future<String?> updateDebtType({
    required String? budgetId,
    required double debt,
    required double income,
  }) async {
    final userId = _authenticator.userId;
    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return null;
    }

    state = state.copiedWithIsLoading(true);

    final debtType = await _budgetInfoStorage.updateDebtType(
      budgetId: budgetId,
      debt: debt,
      income: income,
    );

    state = state.copiedWithIsLoading(false);

    return debtType;
  }

  Future<void> updateBudgetNameAndDate({
    required String? budgetId,
    required String budgetName,
  }) async {
    if (budgetId == null) {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: null,
        budgets: [],
      );
      return null;
    }
    state = state.copiedWithIsLoading(true);

    final success = await _budgetInfoStorage.updateBudgetNameAndDate(
      budgetId: budgetId,
      budgetName: budgetName,
    );

    if (success) {
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: _authenticator.userId,
        budgets: [],
      );
    } else {
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: _authenticator.userId,
        budgets: [],
      );
    }
  }

  Future<String> getCurrency({required String? budgetId}) async {
    try {
      final currency =
          await _budgetInfoStorage.fetchCurrency(budgetId: budgetId ?? '');
      return currency;
    } catch (e) {
      throw Exception('Failed to get currency: $e');
    }
  }

  Future<void> fetchUserBudgets() async {
    try {
      final userId = _authenticator.userId;
      print(userId);

      // Ensure userId is not null before proceeding
      if (userId == null) {
        state = BudgetState(
          status: BudgetStatus.failure,
          isLoading: false,
          userId: null,
          budgets: [],
        );
        print('userId is null');
        return;
      }
      // Set the state to loading
      state = state.copiedWithIsLoading(true);

      // Fetch the user's budgets
      final userBudgets =
          await _budgetInfoStorage.getUserBudgets(userId: userId);

      // print('userBudgets: $userBudgets');

      // Update the state with the fetched budgets
      state = state.copiedWithStatusAndBudgets(
        status: BudgetStatus.success,
        isLoading: false,
        budgets: userBudgets,
      );
    } catch (e) {
      // Handle the error case
      state = state.copiedWithStatusAndBudgets(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
    }
  }
}
