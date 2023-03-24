import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'budget_status.dart';

@immutable
class BudgetState {
  final BudgetStatus? status;
  final bool isLoading;
  final UserId? userId;
  final double? salary; // Add the salary property

  const BudgetState({
    required this.status,
    required this.isLoading,
    required this.userId,
    this.salary, // Add the salary property to the constructor
  });

  const BudgetState.unknown()
      : status = null,
        isLoading = false,
        userId = null,
        salary = null; // Set the salary property to null

  BudgetState copiedWithIsLoading(bool isLoading) => BudgetState(
        status: status,
        isLoading: isLoading,
        userId: userId,
        // salary: salary, // Include the salary property in the new instance
      );

  BudgetState copyWithSalary(double salary) => BudgetState(
        status: status,
        isLoading: isLoading,
        userId: userId,
        salary: salary, // Include the salary property in the new instance
      );

  @override
  bool operator ==(covariant BudgetState other) =>
      identical(this, other) ||
      (status == other.status &&
          isLoading == other.isLoading &&
          userId == other.userId &&
          salary ==
              other.salary); // Include the salary property in the comparison

  @override
  int get hashCode => Object.hash(status, isLoading, userId,
      salary); // Include the salary property in the hashCode
}
