import 'dart:collection';
import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
// import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class BudgetDebtInfoPayload extends MapView<String, dynamic> {
  BudgetDebtInfoPayload({
    required Map<String, double> debtExpense,
  }) : super({
          FirebaseFieldName.necessaryExpense: debtExpense,
        });
}
