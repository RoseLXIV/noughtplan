part of 'generate_salary_controller.dart';

class GenerateSalaryState extends Equatable {
  final Salary salary;
  final Currency currency;
  final BudgetType budgetType;
  final FormzStatus status;
  final String? errorMessage;

  const GenerateSalaryState({
    this.salary = const Salary.pure(),
    this.currency = const Currency.pure(),
    this.budgetType = const BudgetType.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  GenerateSalaryState copyWith({
    Salary? salary,
    Currency? currency,
    BudgetType? budgetType,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return GenerateSalaryState(
      salary: salary ?? this.salary,
      currency: currency ?? this.currency,
      budgetType: budgetType ?? this.budgetType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        salary,
        currency,
        budgetType,
        status,
        errorMessage,
      ];
}
