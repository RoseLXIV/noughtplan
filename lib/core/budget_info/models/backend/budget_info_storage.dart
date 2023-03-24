import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/budget_info/models/budget_info_payload.dart';

@immutable
class BudgetInfoStorage {
  const BudgetInfoStorage();

  Future<bool> saveBudgetInfo({
    required UserId id,
    required double salary,
    required String currency,
    required String budgetType,
  }) async {
    try {
      print(id);
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
          FirebaseFieldName.salary: salary,
          FirebaseFieldName.currency: currency,
          FirebaseFieldName.budget_type: budgetType,
        });
        return true;
      }

      final payload = BudgetInfoPayload(
        userId: id,
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

  // Future<double> fetchSalary(UserId id) async {
  //   try {
  //     final budgetInfo = await FirebaseFirestore.instance
  //         .collection(FirebaseCollectionName.budgets)
  //         .where(FirebaseFieldName.id, isEqualTo: id.toString())
  //         .limit(1)
  //         .get();

  //     if (budgetInfo.docs.isNotEmpty) {
  //       final salary = budgetInfo.docs.first.get(FirebaseFieldName.salary);
  //       return salary.toDouble();
  //     } else {
  //       throw Exception('Salary not found for user $id');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching salary: $e');
  //   }
  // }
}
