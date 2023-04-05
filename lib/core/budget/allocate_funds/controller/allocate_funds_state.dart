part of 'allocate_funds_controller.dart';

class AllocateFundsState extends Equatable {
  final Amount amount;
  final NecessaryAmount necessaryAmount;
  final DiscretionaryAmount discretionaryAmount;
  final FormzStatus status;
  final String? errorMessage;

  const AllocateFundsState({
    this.amount = const Amount.pure(),
    this.necessaryAmount = const NecessaryAmount.pure(),
    this.discretionaryAmount = const DiscretionaryAmount.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  AllocateFundsState copyWith({
    Amount? amount,
    NecessaryAmount? necessaryAmount,
    DiscretionaryAmount? discretionaryAmount,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return AllocateFundsState(
      amount: amount ?? this.amount,
      necessaryAmount: necessaryAmount ?? this.necessaryAmount,
      discretionaryAmount: discretionaryAmount ?? this.discretionaryAmount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        necessaryAmount,
        discretionaryAmount,
        status,
        errorMessage,
      ];
}
