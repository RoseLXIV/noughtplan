part of 'generate_salary_controller.dart';

class GenerateSalaryState extends Equatable {
  final Salary salary;
  final Currency currency;
  final BudgetType budgetType;
  final FormzStatus status;
  final String? errorMessage;
  final String? budgetId;
  final bool? saveAndContinuePressed;

  const GenerateSalaryState({
    this.salary = const Salary.pure(),
    this.currency = const Currency.pure(),
    this.budgetType = const BudgetType.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.budgetId,
    this.saveAndContinuePressed,
  });

  GenerateSalaryState copyWith({
    Salary? salary,
    Currency? currency,
    BudgetType? budgetType,
    FormzStatus? status,
    String? errorMessage,
    String? budgetId,
    bool? saveAndContinuePressed,
  }) {
    return GenerateSalaryState(
      salary: salary ?? this.salary,
      currency: currency ?? this.currency,
      budgetType: budgetType ?? this.budgetType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      budgetId: budgetId ?? this.budgetId,
      saveAndContinuePressed:
          saveAndContinuePressed ?? this.saveAndContinuePressed,
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
        saveAndContinuePressed,
      ];
}
