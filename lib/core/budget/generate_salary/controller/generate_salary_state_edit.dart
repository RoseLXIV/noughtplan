part of 'generate_salary_controller_edit.dart';

class GenerateSalaryStateEdit extends Equatable {
  final Salary salary;
  final Currency currency;
  final BudgetType budgetType;
  final FormzStatus status;
  final String? errorMessage;
  final String? budgetId;

  const GenerateSalaryStateEdit({
    this.salary = const Salary.pure(),
    this.currency = const Currency.pure(),
    this.budgetType = const BudgetType.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.budgetId,
  });

  GenerateSalaryStateEdit copyWith({
    Salary? salary,
    Currency? currency,
    BudgetType? budgetType,
    FormzStatus? status,
    String? errorMessage,
    String? budgetId,
  }) {
    return GenerateSalaryStateEdit(
      salary: salary ?? this.salary,
      currency: currency ?? this.currency,
      budgetType: budgetType ?? this.budgetType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      budgetId: budgetId ?? this.budgetId,
    );
  }

  @override
  List<Object?> get props => [
        salary,
        currency,
        budgetType,
        status,
        errorMessage,
        budgetId,
      ];
}
