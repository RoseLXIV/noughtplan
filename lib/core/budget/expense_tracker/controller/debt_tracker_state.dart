part of 'debt_tracker_controller.dart';

class DebtTrackerState extends Equatable {
  final Category category;
  final Amount amount;
  final Amount outstanding;
  final Amount interest;
  final Frequency frequency;
  final Tracker tracker; // Added Tracker
  final FormzStatus status;
  final String? errorMessage;

  const DebtTrackerState({
    this.category = const Category.pure(),
    this.amount = const Amount.pure(),
    this.outstanding = const Amount.pure(),
    this.interest = const Amount.pure(),
    this.frequency = const Frequency.pure(),
    this.tracker = const Tracker.pure(), // Initialized Tracker
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  DebtTrackerState copyWith({
    Category? category,
    Amount? amount,
    Amount? outstanding,
    Amount? interest,
    Frequency? frequency,
    Tracker? tracker, // Added Tracker
    FormzStatus? status,
    String? errorMessage,
  }) {
    return DebtTrackerState(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      outstanding: outstanding ?? this.outstanding,
      interest: interest ?? this.interest,
      frequency: frequency ?? this.frequency,
      tracker: tracker ?? this.tracker, // Added Tracker
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        category,
        amount,
        outstanding,
        interest,
        frequency,
        tracker, // Added Tracker
        status,
        errorMessage,
      ];
}
