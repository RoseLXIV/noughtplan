import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:noughtplan/core/constants/budgets.dart';

Future<String> callChatGPT(String prompt) async {
  final apiKey = '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';
  final url = 'https://api.openai.com/v1/engines/text-davinci-003/completions';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = json.encode({
    'prompt': prompt,
    'max_tokens': 1000,
    'n': 1,
    'stop': null,
    'temperature': 1,
  });

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['choices'][0]['text'].trim();
  } else {
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to load data from ChatGPT API');
  }
}

Future<List<String>> getSuggestions(Budget updatedSelectedBudget) async {
  // Prepare the prompt for the ChatGPT API
  String prompt =
      '...'; // Prepare the prompt based on the updatedSelectedBudget
  String response = await callChatGPT(prompt);
  List<String> suggestions = response.split('\n');
  return suggestions;
}

Future<List<String>> getHighlights(
    Budget updatedSelectedBudget, String firstName) async {
  // Prepare the prompt for the ChatGPT API
  String prompt =
      "Pretend that you are a friendly Personal Finance Advisor.Cut the formalities and provide a personalized analysis of $firstName's budget for the past month. I want you to seperate each Highlight into a numbered list item. Please direct your response to the user, $firstName'. Here are the budget details: Budget ID: ${updatedSelectedBudget.budgetId}, Budget Name: ${updatedSelectedBudget.budgetName}, Budget Date: ${updatedSelectedBudget.budgetDate}, Budget Type: ${updatedSelectedBudget.budgetType}, Currency: ${updatedSelectedBudget.currency}, Debt Expenses: ${updatedSelectedBudget.debtExpense}, Debt Type: ${updatedSelectedBudget.debtType}, Discretionary Expenses: ${updatedSelectedBudget.discretionaryExpense}, User ID: ${updatedSelectedBudget.userId}, Necessary Expenses: ${updatedSelectedBudget.necessaryExpense}, Salary: ${updatedSelectedBudget.salary}, Saving Type: ${updatedSelectedBudget.savingType}, Spending Type: ${updatedSelectedBudget.spendingType}. The actual expenses for the past month include: ${updatedSelectedBudget.actualExpenses}.";
  String response = await callChatGPT(prompt);
  List<String> highlights = response.split('\n');
  return highlights;
}

Future<List<String>> getAchievements(Budget updatedSelectedBudget) async {
  // Prepare the prompt for the ChatGPT API
  String prompt =
      '...'; // Prepare the prompt based on the updatedSelectedBudget
  String response = await callChatGPT(prompt);
  List<String> achievements = response.split('\n');
  return achievements;
}
