import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'budget_status.dart';

@immutable
class BudgetState {
  final BudgetStatus? status;
  final bool isLoading;
  final UserId? userId;
  final double? salary;
  final List<Budget?> budgets; // Add the budgets property

  const BudgetState({
    required this.status,
    required this.isLoading,
    required this.userId,
    this.salary,
    required this.budgets, // Add the budgets property to the constructor
  });

  const BudgetState.unknown()
      : status = null,
        isLoading = false,
        userId = null,
        salary = null,
        budgets = const []; // Set the budgets property to an empty list

  BudgetState copiedWithIsLoading(bool isLoading) => BudgetState(
        status: status,
        isLoading: isLoading,
        userId: userId,
        salary: salary,
        budgets: budgets, // Include the budgets property in the new instance
      );

  BudgetState copyWithSalary(double salary) => BudgetState(
        status: status,
        isLoading: isLoading,
        userId: userId,
        salary: salary,
        budgets: budgets, // Include the budgets property in the new instance
      );

  BudgetState copiedWithStatusAndBudgets({
    required BudgetStatus status,
    required bool isLoading,
    required List<Budget?> budgets,
  }) {
    return BudgetState(
      status: status,
      isLoading: isLoading,
      userId: userId,
      budgets: budgets,
    );
  }

  @override
  bool operator ==(covariant BudgetState other) =>
      identical(this, other) ||
      (status == other.status &&
          isLoading == other.isLoading &&
          userId == other.userId &&
          salary == other.salary &&
          budgets ==
              other.budgets); // Include the budgets property in the comparison

  @override
  int get hashCode => Object.hash(status, isLoading, userId, salary,
      budgets); // Include the budgets property in the hashCode
}
