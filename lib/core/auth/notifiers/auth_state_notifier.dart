import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/auth/forgot_password/controller/forgot_password_controller.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/auth/models/auth_state.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'package:noughtplan/core/user_info/models/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unkown()) {
    if (_authenticator.isSignedIn) {
      state = AuthState(
          result: AuthResult.success,
          userId: _authenticator.userId,
          isLoading: false);
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unkown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(result: result, userId: userId, isLoading: false);
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(result: result, userId: userId, isLoading: false);
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfoSignUp(userId: userId, email: email, name: name);
      state = AuthState(
        result: AuthResult.success,
        userId: userId,
        isLoading: false,
      );
    } else {
      state = AuthState(result: result, userId: null, isLoading: false);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userId = _authenticator.userId;
    if (result == AuthResult.success) {
      // await saveUserInfoSignIn(userId: userId);
      state = AuthState(
        result: AuthResult.success,
        userId: userId,
        isLoading: false,
      );
      print('AuthStateNotifier: ${state.result}');
    }
    state = AuthState(result: result, userId: null, isLoading: false);
    print('AuthStateNotifier: ${state.result}');
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.forgotPassword(email: email);
    if (result == ForgotPasswordResult.success) {
      state = AuthState(
        result: AuthResult.aborted,
        userId: null,
        isLoading: false,
      );
    } else {
      state =
          AuthState(result: AuthResult.aborted, userId: null, isLoading: false);
    }
  }

  Future<void> saveUserInfoSignUp(
          {required UserId userId,
          required String email,
          required String name}) =>
      _userInfoStorage.saveUserInfo(
          id: userId, name: name, email: _authenticator.email);

  Future<void> saveUserInfo({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
          id: userId,
          name: _authenticator.displayName,
          email: _authenticator.email);
}
