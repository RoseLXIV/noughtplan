import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';

final authenticatorProvider = Provider<Authenticator>((ref) {
  return const Authenticator();
});
