part of "signup_controller.dart";

enum PasswordVisibility { hidden, visible }

class SignUpState extends Equatable {
  final Name name;
  final Email email;
  final Password password;
  final PasswordVisibility passwordVisibility;
  final TermsAndCondition termsAndCondition;
  final FormzStatus status;
  final String? errorMessage;

  const SignUpState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordVisibility = PasswordVisibility.hidden,
    this.termsAndCondition = const TermsAndCondition.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  SignUpState copyWith({
    Name? name,
    Email? email,
    Password? password,
    PasswordVisibility? passwordVisibility,
    TermsAndCondition? termsAndCondition,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      termsAndCondition: termsAndCondition ?? this.termsAndCondition,
      // termsAccepted: termsAccepted ?? this.termsAccepted,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        passwordVisibility,
        termsAndCondition,
        // termsAccepted,
        status,
      ];
}
