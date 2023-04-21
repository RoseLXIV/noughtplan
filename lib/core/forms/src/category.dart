import 'package:formz/formz.dart';

enum CategoryValidationError { empty }

class Category extends FormzInput<String, CategoryValidationError> {
  const Category.pure() : super.pure('');
  const Category.dirty([String value = '']) : super.dirty(value);

  @override
  CategoryValidationError? validator(String value) {
    return value.trim().isEmpty ? CategoryValidationError.empty : null;
  }

  static String? showCategoryErrorMessage(CategoryValidationError? error) {
    if (error == CategoryValidationError.empty) {
      return 'Please select a category';
    } else {
      return null;
    }
  }
}
