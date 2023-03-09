part of 'signin_controller.dart';

enum PasswordVisibility { hidden, visible }

class SignInState extends Equatable {
  final Email email;
  final PasswordSignIn password;
  final PasswordVisibility passwordVisibility;
  final FormzStatus status;
  final String? errorMessage;

  const SignInState({
    this.email = const Email.pure(),
    this.password = const PasswordSignIn.pure(),
    this.passwordVisibility = PasswordVisibility.hidden,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  SignInState copyWith({
    Email? email,
    PasswordSignIn? password,
    PasswordVisibility? passwordVisibility,
    FormzStatus? status,
    bool? buttonTapped,
    String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        passwordVisibility,
        status,
      ];
}
