import 'package:noughtplan/core/auth/backend/authenticator.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/auth/notifiers/auth_state_notifier.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/core/auth/authentication_repository.dart';
import 'package:noughtplan/core/auth/providers/auth_repo_provider.dart';

part 'forgot_password_state.dart';

final forgotPasswordProvider = StateNotifierProvider.autoDispose<
    ForgotPasswordController, ForgotPasswordState>(
  (ref) => ForgotPasswordController(
    ref.watch(authRepoProvider),
    ref.read(authStateProvider.notifier),
  ),
);

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthStateNotifier _authStateNotifier;

  ForgotPasswordController(
    this._authenticationRepository,
    this._authStateNotifier,
  ) : super(const ForgotPasswordState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate(
        [email],
      ),
    );
  }

  Future<ForgotPasswordResult> forgotPassword() async {
    if (!state.status.isValidated) return ForgotPasswordResult.inProgress;
    state = state.copyWith(status: FormzStatus.submissionInProgress);

    try {
      await _authStateNotifier.forgotPassword(email: state.email.value);
      state = state.copyWith(status: FormzStatus.submissionSuccess);
      return ForgotPasswordResult.success;
    } on ForgotPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
      return ForgotPasswordResult.failure;
    }
  }
}
