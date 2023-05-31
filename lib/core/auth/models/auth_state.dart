import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
}

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;
  final String? deviceId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
    this.deviceId,
  });

  AuthState copiedWith({
    AuthResult? result,
    bool? isLoading,
    UserId? userId,
    String? deviceId,
  }) =>
      AuthState(
        result: result ?? this.result,
        isLoading: isLoading ?? this.isLoading,
        userId: userId ?? this.userId,
        deviceId: deviceId ?? this.deviceId,
      );

  const AuthState.unkown()
      : result = null,
        isLoading = false,
        userId = null,
        deviceId = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
        deviceId: deviceId,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId &&
          deviceId == other.deviceId);

  @override
  int get hashCode => Object.hash(result, isLoading, userId, deviceId);
}
