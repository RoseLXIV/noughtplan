import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noughtplan/core/budget_info/models/budget_necessary_categories_payload.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class BudgetDebtInfoStorage {
  const BudgetDebtInfoStorage();

  Future<bool> saveBudgetDebtInfo({
    required BudgetId budgetId,
    required Map<String, double> debtExpense,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.budgets,
          )
          .where(
            FirebaseFieldName.budget_id,
            isEqualTo: budgetId,
          )
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.debtExpense: debtExpense,
        });
        return true;
      }

      final payload = BudgetNecessaryInfoPayload(
        necessaryExpense: debtExpense,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .doc(budgetId) // Use UserId directly to update the document
          .set(payload);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDebtAmounts({
    required BudgetId budgetId,
    required Map<String, double> debtAmounts,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.debtExpense: debtAmounts,
        });
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSavingsAmounts({
    required BudgetId budgetId,
    required Map<String, double> savings,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.savings: savings,
        });
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteZeroValueDebtCategories(
      {required BudgetId budgetId}) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        final categories = budgetInfo.docs.first.data();
        final debtExpense = categories['debtExpense'] as Map<String, dynamic>;

        final updatedDebtExpense = Map<String, dynamic>.fromIterable(
            debtExpense.entries.where((entry) => entry.value != 0.0),
            key: (entry) => entry.key,
            value: (entry) => entry.value);

        await budgetInfo.docs.first.reference.update({
          'debtExpense': updatedDebtExpense,
        });

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
