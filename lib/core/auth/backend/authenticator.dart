import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.device;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // unique ID on iOS
    } else {
      return null; // Unsupported platform
    }
  }

  Future<String?> get deviceId async {
    return await getDeviceId();
  }

  Future<String?> fetchDeviceId() async {
    // Get the user ID from the Authenticator
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final docSnapshot = await userDoc.get();

    return docSnapshot.data()?['device_id'];
  }

  Future<void> _updateUserWithDeviceId(String userId, String deviceId) async {
    final userQuery = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .limit(1);

    final querySnapshot = await userQuery.get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;

      // Use the .data() function to access fields of the document
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Check if 'device_id' exists
      if (data.containsKey('device_id')) {
        // If it exists, update it
        await docSnapshot.reference.update({'device_id': deviceId});
      } else {
        // If it doesn't exist, add it
        data['device_id'] = deviceId;
        await docSnapshot.reference.set(data);
      }
    } else {
      // No user document with the given userId exists, you can choose to create a new one here
      print('No user found with id: $userId');
    }
  }

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
      String? deviceId = await getDeviceId();
      if (deviceId == null) {
        print('Failed to get device ID');
        // Handle this case as per your application logic
      } else {
        await _updateUserWithDeviceId(
            FirebaseAuth.instance.currentUser!.uid, deviceId);
      }
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
      String? deviceId = await getDeviceId();
      if (deviceId == null) {
        print('Failed to get device ID');
        // Handle this case as per your application logic
      } else {
        await _updateUserWithDeviceId(
            FirebaseAuth.instance.currentUser!.uid, deviceId);
      }
      return AuthResult.success;
    } on PlatformException catch (e) {
      print('PlatformException: ${e.code}');
      return AuthResult.aborted;
    } catch (e) {
      print('Error: ${e}');
      return AuthResult.failure;
    }
  }

  Future<AuthResult> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Set the display name
      await userCredential.user!.updateDisplayName(name);

      // Force a refresh of the user object to get the latest data
      await userCredential.user!.reload();
      String? deviceId = await getDeviceId();
      if (deviceId == null) {
        print('Failed to get device ID');
        // Handle this case as per your application logic
      } else {
        await _updateUserWithDeviceId(
            FirebaseAuth.instance.currentUser!.uid, deviceId);
      }
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
      } else {
        print('An error occurred: ${e.message}');
      }
      return AuthResult.failure;
    } catch (e) {
      return AuthResult.failure;
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
      String? deviceId = await getDeviceId();
      if (deviceId == null) {
        print('Failed to get device ID');
        // Handle this case as per your application logic
      } else {
        await _updateUserWithDeviceId(
            FirebaseAuth.instance.currentUser!.uid, deviceId);
      }
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthExpection: ${e.code}');
      return AuthResult.failure;
    } on PlatformException catch (e) {
      print('PlatformException: ${e.code}');
      return AuthResult.failure;
    } catch (e) {
      print('Catch: ${e}');
      return AuthResult.failure;
    }
  }

  Future<ForgotPasswordResult> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      return ForgotPasswordResult.success;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthExpection: ${e.code}');
      return ForgotPasswordResult.failure;
    }
  }
}
