import 'dart:collection';
import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class BudgetInfoPayload extends MapView<String, dynamic> {
  BudgetInfoPayload({
    required UserId userId,
    required BudgetId budgetId,
    required double salary,
    required String currency,
    required String budgetType,
  }) : super({
          FirebaseFieldName.id: userId,
          FirebaseFieldName.budget_id: budgetId,
          FirebaseFieldName.salary: salary,
          FirebaseFieldName.currency: currency,
          FirebaseFieldName.budget_type: budgetType,
        });
}
