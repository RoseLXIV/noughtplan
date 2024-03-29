import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/auth/notifiers/auth_state_notifier.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';

part 'signin_state.dart';

final signInProvider =
    StateNotifierProvider.autoDispose<SignInController, SignInState>(
  (ref) => SignInController(
    ref.read(authStateProvider.notifier),
  ),
);

class SignInController extends StateNotifier<SignInState> {
  final AuthStateNotifier _authStateNotifier;
  SignInController(
    this._authStateNotifier,
  ) : super(const SignInState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }

  void onPasswordChange(String value) {
    final password = PasswordSignIn.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    );
  }

  void resetValidation() {
    state = state.copyWith(
      email: Email.pure(),
      password: PasswordSignIn.pure(),
      status: FormzStatus.pure,
    );
  }

  Future<AuthResult> signInWithEmailAndPassword() async {
    if (!state.status.isValidated)
      state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await _authStateNotifier.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      return AuthResult.success;
      // state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignInWithEmailAndPasswordFailureAuth catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: 'Error: $e');
      return AuthResult.failure;
    } catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: 'Error: $e');
      return AuthResult.failure;
    } finally {
      state = state.copyWith(status: FormzStatus.pure);
    }
  }
}
