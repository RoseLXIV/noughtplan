import 'dart:collection';

import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId id,
    required String? name,
    required String? email,
  }) : super({
          FirebaseFieldName.id: id,
          FirebaseFieldName.name: name ?? '',
          FirebaseFieldName.email: email ?? '',
        });
}
