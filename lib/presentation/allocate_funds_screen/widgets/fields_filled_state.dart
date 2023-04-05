import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldsFilledState extends StateNotifier<bool> {
  FieldsFilledState() : super(false);

  void setFilled(bool filled) {
    state = filled;
  }
}

final fieldsFilledStateProvider =
    StateNotifierProvider<FieldsFilledState, bool>((ref) {
  return FieldsFilledState();
});
