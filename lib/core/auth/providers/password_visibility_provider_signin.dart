import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/signin/controller/signin_controller.dart';

final passwordVisibilityProviderSignIn = StateProvider<PasswordVisibility>(
  (ref) => PasswordVisibility.hidden,
);
