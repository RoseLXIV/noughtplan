import 'package:flutter/material.dart';
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
import 'package:noughtplan/presentation/budget_screen/widgets/debts_provider.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/goals_provider.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/actual_expenses_provider.dart';

class BudgetStateNotifier extends StateNotifier<BudgetState> {
  final Authenticator _authenticator;
  final BudgetInfoStorage _budgetInfoStorage;
  final BudgetNecessaryInfoStorage _budgetNecessaryInfoStorage;
  final BudgetDebtInfoStorage _budgetDebtInfoStorage;
  final BudgetDiscretionaryInfoStorage _budgetDiscretionaryInfoStorage;
  final BudgetIdStorage _budgetIdStorage;

  final ValueNotifier<int> _budgetCount = ValueNotifier<int>(0);

  BudgetStateNotifier(this._authenticator)
      : _budgetInfoStorage = const BudgetInfoStorage(),
        _budgetNecessaryInfoStorage = const BudgetNecessaryInfoStorage(),
        _budgetDebtInfoStorage = const BudgetDebtInfoStorage(),
        _budgetDiscretionaryInfoStorage =
            const BudgetDiscretionaryInfoStorage(),
        _budgetIdStorage = const BudgetIdStorage(),
        super(const BudgetState.unknown()) {
    fetchUserBudgets();
  }

  ValueNotifier<int> get budgetCountValueNotifier => _budgetCount;

  Future<int> fetchBudgetCount() async {
    state = state.copiedWithIsLoading(true);

    // Get the device ID from the Authenticator
    final deviceId = await _authenticator.getDeviceId();

    try {
      final count = await _budgetInfoStorage.getBudgetCount(deviceId!);
      print('Budget Count: $count');

      // Update the ValueNotifier with the new budget count
      _budgetCount.value = count;

      state = state.copiedWithIsLoading(false);

      return count;
    } catch (e) {
      state = state.copiedWithIsLoading(false);
      print('Error: $e');
      rethrow;
    }
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

  Future<void> saveBudgetInfoUpdate({
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

    final result = await _budgetInfoStorage.saveBudgetInfoUpdate(
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
    final userId = await _authenticator.userId;
    final deviceId =
        await _authenticator.getDeviceId(); // Fetch the device_id here
    print('Device ID: $deviceId');

    // Ensure userId and deviceId are not null before proceeding
    if (userId == null || deviceId == null) {
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
      deviceId: deviceId, // Pass the device_id here
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

  Future<void> deleteBudgetsWithNoName() async {
    try {
      // Get the userId from _authenticator
      final userId = _authenticator.userId;
      if (userId == null) {
        state = BudgetState(
          status: BudgetStatus.failure,
          isLoading: false,
          userId: null,
          budgets: [],
        );
        return;
      }

      // Call the deleteBudgetsWithNoName function from BudgetInfoStorage
      await _budgetInfoStorage.deleteBudgetsWithNoName(userId);

      // Update the state to reflect successful deletion
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [], // Update this to remove the deleted budget from the list
      );
    } catch (e) {
      // Handle any errors that might occur during the deletion
      print(e);
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: _authenticator.userId,
        budgets: [], // Update this to keep the current list of budgets
      );
    }
  }

  Future<void> deleteBudgetsWithNoNameAndUser() async {
    try {
      // Get the userId from _authenticator
      final userId = _authenticator.userId;
      print('userId Delete Notifier: $userId');
      if (userId == null) {
        state = BudgetState(
          status: BudgetStatus.failure,
          isLoading: false,
          userId: null,
          budgets: [],
        );
        return;
      }

      // Call the deleteBudgetsWithNoName function from BudgetInfoStorage
      await _budgetInfoStorage.deleteBudgetsWithNoName(userId);

      // Call the deleteAllUserBudgets function from BudgetInfoStorage
      await _budgetInfoStorage.deleteAllUserBudgets(userId);

      // Call the deleteUser function from BudgetInfoStorage
      await _budgetInfoStorage.deleteUser(userId);

      // Update the state to reflect successful deletion
      state = BudgetState(
        status: BudgetStatus.success,
        isLoading: false,
        userId: userId,
        budgets: [], // Update this to remove the deleted budget from the list
      );
    } catch (e) {
      // Handle any errors that might occur during the deletion
      print(e);
      state = BudgetState(
        status: BudgetStatus.failure,
        isLoading: false,
        userId: _authenticator.userId,
        budgets: [], // Update this to keep the current list of budgets
      );
    }
  }

  Future<void> deleteExpense(String budgetId, int index, WidgetRef ref) async {
    try {
      // Call the deleteExpense function from BudgetInfoStorage
      await _budgetInfoStorage.deleteExpense(budgetId, index);

      // Remove the expense from ActualExpensesNotifier
      ref.read(actualExpensesProvider.notifier).removeExpenseAtIndex(index);

      // ...rest of the code
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  Future<void> deleteWeeklyExpenses(
      String budgetId, DateTime selectedDate, WidgetRef ref) async {
    try {
      state = state.copiedWithIsLoading(true);
      // Call the deleteWeeklyExpenses function from BudgetInfoStorage
      await _budgetInfoStorage.deleteWeeklyExpenses(budgetId, selectedDate);

      // Update the expenses in ActualExpensesNotifier
      ref.read(actualExpensesProvider.notifier).loadExpenses(budgetId);
      state = state.copiedWithIsLoading(false);
    } catch (e) {
      print('Error deleting weekly expenses: $e');
      state = state.copiedWithIsLoading(false);
    }
  }

  Future<void> deleteMonthlyExpenses(
      String budgetId, DateTime selectedDate, WidgetRef ref) async {
    try {
      state = state.copiedWithIsLoading(true);
      // Call the deleteMonthlyExpenses function from BudgetInfoStorage
      await _budgetInfoStorage.deleteMonthlyExpenses(budgetId, selectedDate);

      // Update the expenses in ActualExpensesNotifier
      ref.read(actualExpensesProvider.notifier).loadExpenses(budgetId);
      state = state.copiedWithIsLoading(false);
    } catch (e) {
      print('Error deleting monthly expenses: $e');
      state = state.copiedWithIsLoading(false);
    }
  }

  Future<void> deleteGoal(
      String budgetId, int index, int reversedIndex, WidgetRef ref) async {
    try {
      ref.read(goalsProvider.notifier).removeGoalAtIndex(index);
      await _budgetInfoStorage.deleteGoal(budgetId, reversedIndex);
    } catch (e) {
      print('Error deleting goal: $e');
    }
  }

  Future<void> deleteDebt(
      String budgetId, int index, int reversedIndex, WidgetRef ref) async {
    try {
      ref.read(debtsProvider.notifier).removeDebtAtIndex(index);
      await _budgetInfoStorage.deleteDebt(budgetId, reversedIndex);
    } catch (e) {
      print('Error deleting debt: $e');
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

  Future<List<Budget?>> fetchUserBudgets() async {
    try {
      final userId = _authenticator.userId;
      if (userId == null) {
        print('userId is null');
        return [];
      }

      final userBudgets =
          await _budgetInfoStorage.getUserBudgets(userId: userId);
      // print('User budgets: $userBudgets');
      return userBudgets;
    } catch (e) {
      return [];
    }
  }

  Future<void> addActualExpense(
      {required String? budgetId,
      required Map<String, dynamic> expenseData,
      required WidgetRef ref}) async {
    if (budgetId == null) {
      state = state.copyWith(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
      return;
    }
    state = state.copyWith(isLoading: true);

    final success = await _budgetInfoStorage.addActualExpense(
      budgetId: budgetId,
      expenseData: expenseData,
    );

    if (success) {
      List<Budget?> updatedBudgets = await fetchUserBudgets();
      state = state.copyWith(
        status: BudgetStatus.success,
        isLoading: false,
        budgets: updatedBudgets,
      );
      // print('Updated budgets: $updatedBudgets');
      // Get the updated budget
      final updatedBudget =
          updatedBudgets.firstWhere((b) => b?.budgetId == budgetId);
      // print('Updated budgets AFTER: $updatedBudget');

      // Update the actual expenses
      if (updatedBudget != null) {
        final actualExpensesNotifier =
            ref.read(actualExpensesProvider.notifier);
        actualExpensesNotifier
            .updateActualExpenses(updatedBudget.actualExpenses);
      }

      print('Updated budgets: $updatedBudgets');
    } else {
      state = state.copyWith(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
    }
  }

  Future<void> addGoal(
      {required String? budgetId,
      required Map<String, dynamic> goalData,
      required WidgetRef ref}) async {
    if (budgetId == null) {
      state = state.copyWith(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
      return;
    }
    state = state.copyWith(isLoading: true);

    final success = await _budgetInfoStorage.addGoal(
      budgetId: budgetId,
      goalData: goalData,
    );

    if (success) {
      List<Budget?> updatedBudgets = await fetchUserBudgets();
      state = state.copyWith(
        status: BudgetStatus.success,
        isLoading: false,
        budgets: updatedBudgets,
      );

      // Get the updated budget
      final updatedBudget =
          updatedBudgets.firstWhere((b) => b?.budgetId == budgetId);

      // Update the goals
      if (updatedBudget != null) {
        final goalsNotifier = await ref.read(goalsProvider.notifier);
        goalsNotifier.updateGoals(updatedBudget.goals);
      }

      print('Updated budgets: $updatedBudgets');
    } else {
      state = state.copyWith(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
    }
  }

  Future<void> addDebt(
      {required String? budgetId,
      required Map<String, dynamic> debtData,
      required WidgetRef ref}) async {
    if (budgetId == null) {
      state = state.copyWith(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
      return;
    }
    state = state.copyWith(isLoading: true);

    final success = await _budgetInfoStorage.addDebt(
      budgetId: budgetId,
      debtData: debtData,
    );

    if (success) {
      List<Budget?> updatedBudgets = await fetchUserBudgets();
      state = state.copyWith(
        status: BudgetStatus.success,
        isLoading: false,
        budgets: updatedBudgets,
      );

      // Get the updated budget
      final updatedBudget =
          updatedBudgets.firstWhere((b) => b?.budgetId == budgetId);

      // Update the debts
      if (updatedBudget != null) {
        final debtsNotifier = ref.read(debtsProvider
            .notifier); // Make sure you have a corresponding notifier and provider for the debts
        debtsNotifier.updateDebts(updatedBudget
            .debts); // And a corresponding method to update the debts in the notifier
      }

      print('Updated budgets: $updatedBudgets');
    } else {
      state = state.copyWith(
        status: BudgetStatus.failure,
        isLoading: false,
        budgets: [],
      );
    }
  }
}
