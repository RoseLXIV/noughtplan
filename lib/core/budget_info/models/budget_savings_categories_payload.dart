import 'dart:collection';
import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
// import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class BudgetSavingsInfoPayload extends MapView<String, dynamic> {
  BudgetSavingsInfoPayload({
    required Map<String, double> savings,
  }) : super({
          FirebaseFieldName.savings: savings,
        });
}
