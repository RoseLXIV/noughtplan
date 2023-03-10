import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/auth/models/auth_state.dart';
import 'package:noughtplan/core/auth/notifiers/auth_state_notifier.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:noughtplan/core/auth/authentication_repository.dart';
import 'package:noughtplan/core/auth/providers/auth_repo_provider.dart';

part 'signup_state.dart';

final signUpProvider =
    StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
  (ref) => SignUpController(
    ref.watch(authRepoProvider),
    ref.read(authStateProvider.notifier),
  ),
);

// ref.watch(authRepoProvider)
class SignUpController extends StateNotifier<SignUpState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthStateNotifier _authStateNotifier;
  SignUpController(
    this._authenticationRepository,
    this._authStateNotifier,
  ) : super(const SignUpState());

  void onNameChange(String value) {
    final name = Name.dirty(value);
    state = state.copyWith(
      name: name,
      status: Formz.validate(
        [
          name,
          state.email,
          state.password,
          state.termsAndCondition,
        ],
      ),
    );
  }

  void onEmailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate(
        [
          state.name,
          email,
          state.password,
          state.termsAndCondition,
        ],
      ),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate(
        [
          state.name,
          state.email,
          password,
          state.termsAndCondition,
        ],
      ),
    );
  }

  void onTermsAndConditionChange(bool value) {
    final termsAndCondition = TermsAndCondition.dirty(value);

    state = state.copyWith(
      termsAndCondition: termsAndCondition,
      status: Formz.validate(
        [
          state.name,
          state.email,
          state.password,
          termsAndCondition,
        ],
      ),
    );
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (!state.status.isValidated) return;
    state = state.copyWith(status: FormzStatus.submissionInProgress);

    try {
      await _authStateNotifier.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
      );
      // AuthResult.success;
      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}
