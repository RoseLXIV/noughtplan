import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noughtplan/core/budget_info/models/budget_discretionary_categories_payload.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class BudgetDiscretionaryInfoStorage {
  const BudgetDiscretionaryInfoStorage();

  Future<bool> saveBudgetDiscretionaryInfo({
    required BudgetId budgetId,
    required Map<String, double> discretionaryExpense,
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
          FirebaseFieldName.discretionaryExpense: discretionaryExpense,
        });
        return true;
      }

      final payload = BudgetDiscretionaryInfoPayload(
        discretionaryExpense: discretionaryExpense,
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

  Future<bool> updateDiscretionaryAmounts({
    required BudgetId budgetId,
    required Map<String, double> discretionaryAmounts,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        await budgetInfo.docs.first.reference.update({
          FirebaseFieldName.discretionaryExpense: discretionaryAmounts,
        });
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteZeroValueDiscretionaryCategories(
      {required BudgetId budgetId}) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.budget_id, isEqualTo: budgetId.toString())
          .limit(1)
          .get();

      if (budgetInfo.docs.isNotEmpty) {
        final categories = budgetInfo.docs.first.data();
        final discretionaryExpense =
            categories['discretionaryExpense'] as Map<String, dynamic>;

        final updatedDiscretionaryExpense = Map<String, dynamic>.fromIterable(
            discretionaryExpense.entries.where((entry) => entry.value != 0.0),
            key: (entry) => entry.key,
            value: (entry) => entry.value);

        await budgetInfo.docs.first.reference.update({
          'discretionaryExpense': updatedDiscretionaryExpense,
        });

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
