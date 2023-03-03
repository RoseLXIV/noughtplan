import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:noughtplan/core/constants/firebase_collection_name.dart';
import 'package:noughtplan/core/constants/firebase_field_name.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();
  Future<bool> saveUserInfo({
    required UserId id,
    required String? name,
    required String? email,
  }) async {
    try {
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(
            FirebaseFieldName.id,
            isEqualTo: id,
          )
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.name: name,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }
      final payload = UserInfoPayload(id: id, name: name, email: email);
      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .add(payload);

      return true;
    } catch (e) {
      return false;
    }
  }
}
