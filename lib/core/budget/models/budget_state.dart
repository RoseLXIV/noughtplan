import 'package:flutter/foundation.dart' show immutable;
import 'package:noughtplan/core/posts/typedefs/user_id.dart';
import 'budget_status.dart';

@immutable
class BudgetState {
  final BudgetStatus? status;
  final bool isLoading;
  final UserId? userId;

  const BudgetState({
    required this.status,
    required this.isLoading,
    required this.userId,
  });

  const BudgetState.unknown()
      : status = null,
        isLoading = false,
        userId = null;

  BudgetState copiedWithIsLoading(bool isLoading) => BudgetState(
        status: status,
        isLoading: isLoading,
        userId: userId,
      );

  @override
  bool operator ==(covariant BudgetState other) =>
      identical(this, other) ||
      (status == other.status &&
          isLoading == other.isLoading &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(status, isLoading, userId);
}
