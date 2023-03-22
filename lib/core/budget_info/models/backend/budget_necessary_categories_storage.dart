import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noughtplan/core/budget_info/models/budget_necessary_categories_payload.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class BudgetNecessaryInfoStorage {
  const BudgetNecessaryInfoStorage();

  Future<bool> saveBudgetNecessaryInfo({
    required UserId id,
    required Map<String, double> necessaryExpense,
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
          FirebaseFieldName.necessaryExpense: necessaryExpense,
        });
        return true;
      }

      final payload = BudgetNecessaryInfoPayload(
        necessaryExpense: necessaryExpense,
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
}
