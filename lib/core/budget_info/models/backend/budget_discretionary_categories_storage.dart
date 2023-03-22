import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noughtplan/core/budget_info/models/budget_discretionary_categories_payload.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class BudgetDiscretionaryInfoStorage {
  const BudgetDiscretionaryInfoStorage();

  Future<bool> saveBudgetDiscretionaryInfo({
    required UserId id,
    required Map<String, double> discretionaryExpense,
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
          FirebaseFieldName.discretionaryExpense: discretionaryExpense,
        });
        return true;
      }

      final payload = BudgetDiscretionaryInfoPayload(
        discretionaryExpense: discretionaryExpense,
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
