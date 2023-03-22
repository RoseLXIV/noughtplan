import 'dart:collection';
import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
// import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class BudgetNecessaryInfoPayload extends MapView<String, dynamic> {
  BudgetNecessaryInfoPayload({
    required Map<String, double> necessaryExpense,
  }) : super({
          FirebaseFieldName.necessaryExpense: necessaryExpense,
        });
}
