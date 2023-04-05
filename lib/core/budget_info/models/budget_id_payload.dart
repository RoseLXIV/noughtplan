import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/budget_id.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class BudgetIdPayload extends MapView<String, String> {
  BudgetIdPayload({
    required BudgetId id,
    required UserId userId,
  }) : super({
          FirebaseFieldName.budget_id: id,
          FirebaseFieldName.id: userId,
        });
}
