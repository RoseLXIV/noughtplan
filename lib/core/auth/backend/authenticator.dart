import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';

class SignUpWithEmailAndPasswordFailureAuth implements Exception {
  final String code;
  const SignUpWithEmailAndPasswordFailureAuth(this.code);
}

class SignInWithEmailAndPasswordFailureAuth implements Exception {
  final String code;
  const SignInWithEmailAndPasswordFailureAuth(this.code);
}

class ForgotPasswordFailureAuth implements Exception {
  final String code;
  const ForgotPasswordFailureAuth(this.code);
}

class SignInWithGoogleFailureAuth implements Exception {}

class SignOutFailureAuth implements Exception {}

class Authenticator {
  const Authenticator();

  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isSignedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;
  bool get isEmailVerified =>
      FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;
    if (token == null) {
      return AuthResult.aborted;
    }
    final OAuthCredentials = FacebookAuthProvider.credential(token);
    try {
      await FirebaseAuth.instance.signInWithCredential(OAuthCredentials);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredential &&
          email != null &&
          credential != null) {
        final authResult =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (authResult.contains(Constants.googleCom)) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [Constants.emailScope],
    );
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return AuthResult.aborted;
    }
    final googleAuth = await googleUser.authentication;
    final authCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(authCredentials);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }

  Future<AuthResult> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailureAuth(e.code);
    }
  }

  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailureAuth(e.code);
    }
  }
}
