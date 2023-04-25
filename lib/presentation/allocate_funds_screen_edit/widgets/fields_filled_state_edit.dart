import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldsFilledStateEdit extends StateNotifier<bool> {
  FieldsFilledStateEdit() : super(false);

  void setFilled(bool filled) {
    state = filled;
  }
}

final fieldsFilledStateProviderEdit =
    StateNotifierProvider<FieldsFilledStateEdit, bool>((ref) {
  return FieldsFilledStateEdit();
});
