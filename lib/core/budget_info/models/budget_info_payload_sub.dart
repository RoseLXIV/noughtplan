import 'dart:collection';
import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class BudgetInfoPayloadSub extends MapView<String, dynamic> {
  BudgetInfoPayloadSub({
    required UserId userId,
    required BudgetId budgetId,
    required double salary,
    required String currency,
    required String budgetType,
    required String deviceId,
  }) : super({
          FirebaseFieldName.id: userId,
          FirebaseFieldName.budget_id: budgetId,
          FirebaseFieldName.salary: salary,
          FirebaseFieldName.currency: currency,
          FirebaseFieldName.budget_type: budgetType,
          'device_id': deviceId,
        });
}
