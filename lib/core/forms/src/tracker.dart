import 'package:formz/formz.dart';

enum TrackerValidationError { empty }

class Tracker extends FormzInput<String, TrackerValidationError> {
  const Tracker.pure() : super.pure('');
  const Tracker.dirty([String value = '']) : super.dirty(value);

  @override
  TrackerValidationError? validator(String value) {
    return value.trim().isEmpty ? TrackerValidationError.empty : null;
  }

  static String? showTrackerErrorMessage(TrackerValidationError? error) {
    if (error == TrackerValidationError.empty) {
      return 'Please select tracker type';
    } else {
      return null;
    }
  }
}
