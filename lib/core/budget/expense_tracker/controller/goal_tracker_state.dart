part of 'goal_tracker_controller.dart';

class GoalTrackerState extends Equatable {
  final Category category;
  final Amount amount;
  final Frequency frequency;
  final Tracker tracker; // Add this line
  final FormzStatus status;
  final String? errorMessage;

  const GoalTrackerState({
    this.category = const Category.pure(),
    this.amount = const Amount.pure(),
    this.frequency = const Frequency.pure(),
    this.tracker = const Tracker
        .pure(), // Add this line with the default value for the tracker
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  GoalTrackerState copyWith({
    Category? category,
    Amount? amount,
    Frequency? frequency,
    Tracker? tracker, // Add this line
    FormzStatus? status,
    String? errorMessage,
  }) {
    return GoalTrackerState(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      tracker: tracker ?? this.tracker, // Add this line
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        category,
        amount,
        frequency,
        tracker, // Add this line
        status,
        errorMessage,
      ];
}
