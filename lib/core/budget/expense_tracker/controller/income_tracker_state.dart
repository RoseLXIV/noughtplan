part of 'income_tracker_controller.dart';

class IncomeTrackerState extends Equatable {
  final Category category;
  final Amount amount;
  final FormzStatus status;
  final String? errorMessage;

  const IncomeTrackerState({
    this.category = const Category.pure(),
    this.amount = const Amount.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  IncomeTrackerState copyWith({
    Category? category,
    Amount? amount,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return IncomeTrackerState(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        category,
        amount,
        status,
        errorMessage,
      ];
}
