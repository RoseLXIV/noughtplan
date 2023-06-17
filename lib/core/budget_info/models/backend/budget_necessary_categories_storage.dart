import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noughtplan/core/budget_info/models/budget_necessary_categories_payload.dart';
import 'package:noughtplan/core/budget_info/models/budget_savings_categories_payload.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class BudgetNecessaryInfoStorage {
  const BudgetNecessaryInfoStorage();

  Future<bool> saveBudgetNecessaryInfo({
    required BudgetId budgetId,
    required Map<String, double> necessaryExpense,
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
          FirebaseFieldName.necessaryExpense: necessaryExpense,
        });
        return true;
      }

      final payload = BudgetNecessaryInfoPayload(
        necessaryExpense: necessaryExpense,
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

  Future<bool> saveSavingsNecessaryInfo({
    required BudgetId budgetId,
    required Map<String, double> savings,
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
          FirebaseFieldName.savings: savings,
        });
        return true;
      }

      final payload = BudgetSavingsInfoPayload(
        savings: savings,
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
}
