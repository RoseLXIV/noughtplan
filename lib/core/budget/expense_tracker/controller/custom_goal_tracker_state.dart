part of 'custom_goal_tracker_controller.dart';

class CustomGoalTrackerState extends Equatable {
  final Category category;
  final Amount amount;
  final Amount recurringAmount; // Add this line
  final Frequency frequency;
  final Tracker tracker;
  final FormzStatus status;
  final String? errorMessage;

  const CustomGoalTrackerState({
    this.category = const Category.pure(),
    this.amount = const Amount.pure(),
    this.recurringAmount = const Amount.pure(), // Add this line
    this.frequency = const Frequency.pure(),
    this.tracker = const Tracker.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  CustomGoalTrackerState copyWith({
    Category? category,
    Amount? amount,
    Amount? recurringAmount, // Add this line
    Frequency? frequency,
    Tracker? tracker,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return CustomGoalTrackerState(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      recurringAmount: recurringAmount ?? this.recurringAmount, // Add this line
      frequency: frequency ?? this.frequency,
      tracker: tracker ?? this.tracker,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        category,
        amount,
        recurringAmount, // Add this line
        frequency,
        tracker,
        status,
        errorMessage,
      ];
}
