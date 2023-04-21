import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Budget {
  final String budgetId;
  final String budgetName;
  final DateTime budgetDate;
  final String budgetType;
  final String currency;
  final Map<String, double>? debtExpense;
  final String debtType;
  final Map<String, double>? discretionaryExpense;
  final String userId;
  final Map<String, double>? necessaryExpense;
  final double salary;
  final String savingType;
  final String spendingType;
  final List<Map<String, dynamic>> actualExpenses;

  Budget({
    required this.budgetId,
    required this.budgetName,
    required this.budgetDate,
    required this.budgetType,
    required this.currency,
    required this.debtExpense,
    required this.debtType,
    required this.discretionaryExpense,
    required this.userId,
    required this.necessaryExpense,
    required this.salary,
    required this.savingType,
    required this.spendingType,
    required this.actualExpenses,
  });

  // You can also add factory methods to create instances from your data source
  factory Budget.fromMap(Map<String, dynamic> map) {
    // print('map: $map'); // Print the entire map to see the field names

    final budgetDate = (map['budget_date'] as Timestamp).toDate();

    return Budget(
      budgetId: map['budget_id'],
      budgetName: map['budget_name'] as String? ?? '',
      budgetDate: budgetDate,
      budgetType: map['budget_type'],
      currency: map['currency'],
      debtExpense: Map<String, double>.from(map['debtExpense']),
      debtType: map['debt_type'],
      discretionaryExpense:
          Map<String, double>.from(map['discretionaryExpense']),
      userId: map['id'],
      necessaryExpense: Map<String, double>.from(map['necessaryExpense']),
      salary: map['salary'],
      savingType: map['saving_type'],
      spendingType: map['spending_type'],
      actualExpenses: map['actualExpenses'] != null
          ? List<Map<String, dynamic>>.from(map['actualExpenses'])
          : [],
    );
  }
  Budget copyWith({
    String? budgetId,
    String? budgetName,
    DateTime? budgetDate,
    String? budgetType,
    String? currency,
    Map<String, double>? debtExpense,
    String? debtType,
    Map<String, double>? discretionaryExpense,
    String? userId,
    Map<String, double>? necessaryExpense,
    double? salary,
    String? savingType,
    String? spendingType,
    List<Map<String, dynamic>>? actualExpenses,
  }) {
    return Budget(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      budgetDate: budgetDate ?? this.budgetDate,
      budgetType: budgetType ?? this.budgetType,
      currency: currency ?? this.currency,
      debtExpense: debtExpense ?? this.debtExpense,
      debtType: debtType ?? this.debtType,
      discretionaryExpense: discretionaryExpense ?? this.discretionaryExpense,
      userId: userId ?? this.userId,
      necessaryExpense: necessaryExpense ?? this.necessaryExpense,
      salary: salary ?? this.salary,
      savingType: savingType ?? this.savingType,
      spendingType: spendingType ?? this.spendingType,
      actualExpenses: actualExpenses ?? this.actualExpenses,
    );
  }

  String toString() {
    return 'Budget('
        'budgetId: $budgetId, '
        'budgetName: $budgetName, '
        'budgetDate: $budgetDate, '
        'budgetType: $budgetType, '
        'currency: $currency, '
        'debtExpense: $debtExpense, '
        'debtType: $debtType, '
        'discretionaryExpense: $discretionaryExpense, '
        'userId: $userId, '
        'necessaryExpense: $necessaryExpense, '
        'salary: $salary, '
        'savingType: $savingType, '
        'spendingType: $spendingType, '
        'actualExpenses: $actualExpenses)';
  }
}
