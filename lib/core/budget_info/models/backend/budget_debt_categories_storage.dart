import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noughtplan/core/budget_info/models/budget_necessary_categories_payload.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class BudgetDebtInfoStorage {
  const BudgetDebtInfoStorage();

  Future<bool> saveBudgetDebtInfo({
    required UserId id,
    required Map<String, double> debtExpense,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.budgets,
          )
          .where(
            FirebaseFieldName.id,
            isEqualTo: id,
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
          .doc(id) // Use UserId directly to update the document
          .set(payload);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDebtAmounts({
    required UserId id,
    required Map<String, double> debtAmounts,
  }) async {
    try {
      final budgetInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.id, isEqualTo: id.toString())
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
}
