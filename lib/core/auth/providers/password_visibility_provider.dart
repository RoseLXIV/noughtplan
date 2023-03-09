import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/signup/controller/signup_controller.dart';

final passwordVisibilityProvider = StateProvider<PasswordVisibility>(
  (ref) => PasswordVisibility.hidden,
);
