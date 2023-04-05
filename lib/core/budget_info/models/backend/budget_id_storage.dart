import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

import '../budget_id_payload.dart';

@immutable
class BudgetIdStorage {
  const BudgetIdStorage();

  Future<bool> saveBudgetId(
      {required BudgetId id, required UserId userId}) async {
    try {
      final budgetDocs = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.budgets)
          .where(FirebaseFieldName.id, isEqualTo: userId.toString())
          .get();

      if (budgetDocs.docs.isNotEmpty) {
        await budgetDocs.docs.first.reference.update({
          FirebaseFieldName.budget_id: id.toString(),
        });
      } else {
        final payload = BudgetIdPayload(id: id, userId: userId);
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.budgets)
            .add(payload);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
