import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/budget_info/models/budget_info_payload.dart';

@immutable
class BudgetInfoStorage {
  const BudgetInfoStorage();

  Future<bool> saveBudgetInfo({
    required UserId id,
    required BudgetId budgetId,
    required double salary,
    required String currency,
    required String budgetType,
  }) async {
    try {
      // print(id);
      final budgetInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.budgets,
          )
          .where(
            FirebaseFieldName.id,
            isEqualTo: id.toString(),
          )
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.budget_id: budgetId.toString(),
          FirebaseFieldName.salary: salary,
          FirebaseFieldName.currency: currency,
          FirebaseFieldName.budget_type: budgetType,
        });
        return true;
      }

      final payload = BudgetInfoPayload(
        userId: id,
        budgetId: budgetId,
        salary: salary,
        currency: currency,
        budgetType: budgetType,
      );
      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.budgets,
          )
          .add(payload);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveBudgetInfoSubscriber({
    required UserId id,
    required BudgetId budgetId,
    required double salary,
    required String currency,
    required String budgetType,
  }) async {
    try {
      final payload = BudgetInfoPayload(
        userId: id,
        budgetId: budgetId,
        salary: salary,
        currency: currency,
        budgetType: budgetType,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .add(payload);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAmounts({
    required BudgetId budgetId,
    required Map<String, double> necessaryAmounts,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.necessaryExpense: necessaryAmounts,
        });
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSurplus({
    required BudgetId budgetId,
    required double remainingFunds,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          'necessaryExpense.Surplus': remainingFunds,
        });
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteZeroValueCategories({
    required BudgetId budgetId,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        final categories = budgetInfo.docs.first.data();
        final necessaryExpense =
            categories['necessaryExpense'] as Map<String, dynamic>;

        final updatedNecessaryExpense = Map<String, dynamic>.fromIterable(
            necessaryExpense.entries.where((entry) => entry.value != 0.0),
            key: (entry) => entry.key,
            value: (entry) => entry.value);

        await budgetInfo.docs.first.reference.update({
          'necessaryExpense': updatedNecessaryExpense,
        });

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> updateSpendingType({
    required BudgetId budgetId,
    required double totalNecessaryExpense,
    required double totalDiscretionaryExpense,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        final spendingType = categorizeSpender(
          totalNecessaryExpense,
          totalDiscretionaryExpense,
        );

        await budgetInfo.docs.first.reference.update({
          'spending_type': spendingType,
        });

        print('Spending type updated to $spendingType');

        return spendingType;
      }

      return null;
    } catch (e) {
      print('Failed to update spending type: $e');
      return null;
    }
  }

  Future<String?> updateSavingType({
    required String budgetId,
    required String spendingType,
    required double totalSavings,
    required double salary,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId)
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        final savingType = categorizeSaver(
          spendingType: spendingType,
          savings: totalSavings,
          salary: salary,
        );

        await budgetInfo.docs.first.reference.update({
          'saving_type': savingType,
        });

        print('Saving type updated to $savingType');

        return savingType;
      }

      return null;
    } catch (e) {
      print('Failed to update saving type: $e');
      return null;
    }
  }

  Future<String?> updateDebtType({
    required String budgetId,
    required double debt,
    required double income,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId)
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        final debtType = assignDebtType(debt, income);

        await budgetInfo.docs.first.reference.update({
          'debt_type': debtType,
        });

        print('Debt type updated to $debtType');
        return debtType;
      }

      return null;
    } catch (e) {
      print('Failed to update debt type: $e');
      return null;
    }
  }

  Future<bool> updateBudgetNameAndDate({
    required String budgetId,
    required String budgetName,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId)
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.budget_name: budgetName,
          FirebaseFieldName.budget_date: DateTime.now(),
        });

        print('Budget name and date updated to $budgetName');
        return true;
      }

      return false;
    } catch (e) {
      print('Failed to update budget name and date: $e');
      return false;
    }
  }

  Future<String> fetchCurrency({required BudgetId budgetId}) async {
    print('Budget ID inside storage: $budgetId');

    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        return budgetInfo.docs.first.get(FirebaseFieldName.currency) as String;
      } else {
        throw Exception(
          'No budget found for the specified user',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch currency: $e');
    }
  }
}

String categorizeSpender(
    double totalNecessaryExpense, double totalDiscretionaryExpense) {
  if ((totalNecessaryExpense - totalDiscretionaryExpense).abs() < 150) {
    return 'Balanced Spender';
  }
  if (totalDiscretionaryExpense > totalNecessaryExpense) {
    return 'Impulsive Spender';
  }
  return 'Necessary Spender';
}

String categorizeSaver({
  required String spendingType,
  required double savings,
  required double salary,
}) {
  if (savings <= 0) {
    return 'Non-Saver';
  }

  if (spendingType == 'Impulsive Spender') {
    if (savings < salary * 0.1) {
      return 'Overspender';
    } else if (savings > salary * 0.2) {
      return 'Wealthy';
    } else {
      return 'Moderate Saver';
    }
  } else if (spendingType == 'Necessary Spender') {
    if (savings < salary * 0.1) {
      return 'Cautious';
    } else if (savings > salary * 0.2) {
      return 'Frugal';
    } else {
      return 'Prudent Saver';
    }
  } else if (spendingType == 'Balanced Spender') {
    if (savings < salary * 0.1) {
      return 'Limited Saver';
    } else if (savings > salary * 0.2) {
      return 'Strategic';
    } else {
      return 'Balanced Saver';
    }
  } else {
    return 'Unknown';
  }
}

String assignDebtType(
  double debt,
  double income,
) {
  double debtToIncomeRatio = debt / income;
  if (debtToIncomeRatio == 0) {
    return "Debt Free";
  } else if (debtToIncomeRatio < 0.1) {
    return "Minimal Debt";
  } else if (debtToIncomeRatio >= 0.1 && debtToIncomeRatio <= 0.35) {
    return "Moderate Debt";
  } else if (debtToIncomeRatio > 0.35 && debtToIncomeRatio <= 0.42) {
    return "Danger Zone";
  } else {
    return "High Debt";
  }
}
