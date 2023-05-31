import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/presentation/chat_bot_screen/chat_bot_screen.dart';

Future<String> callChatGPT(String prompt) async {
  final apiKey = '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';
  final url = 'https://api.openai.com/v1/engines/text-davinci-003/completions';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = json.encode({
    'prompt': prompt,
    'max_tokens': 200,
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

Future<String> callChatGPTBot(
  String messageContent,
  String firstName,
  Budget budget,
  List<Message> conversationHistory, {
  int contextMessagesCount = 10,
}) async {
  final apiKey = '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';
  final url = 'https://api.openai.com/v1/chat/completions';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  String budgetDetailsMessage =
      "My name is $firstName and my budget details are as follows:"
      "\nBudget ID: ${budget.budgetId}"
      "\nBudget Name: ${budget.budgetName}"
      "\nBudget Date: ${budget.budgetDate}"
      "\nBudget Type: ${budget.budgetType}"
      "\nCurrency: ${budget.currency}"
      "\nDebt Expenses: ${budget.debtExpense}"
      "\nDebt Type: ${budget.debtType}"
      "\nDiscretionary Expenses: ${budget.discretionaryExpense}"
      "\nUser ID: ${budget.userId}"
      "\nNecessary Expenses: ${budget.necessaryExpense}"
      "\nSalary: ${budget.salary}"
      "\nSaving Type: ${budget.savingType}"
      "\nSpending Type: ${budget.spendingType}";

  // Prepare the conversation history for the API request
  List<Map<String, dynamic>> messages = [
    {
      "role": "system",
      "content":
          "You are a Personal Financial Advisor for TheNoughtPlan. Please provide detailed responses and reference the user's budget details. Keep responses under 150 words. Keep responses concise with proper spacing and paragraphing."
    },
    {"role": "user", "content": budgetDetailsMessage},
  ];

  int startIndex = conversationHistory.length > contextMessagesCount
      ? conversationHistory.length - contextMessagesCount
      : 0;

  for (int i = startIndex; i < conversationHistory.length; i++) {
    Message msg = conversationHistory[i];
    messages.add({
      'role': msg.isUser ? 'user' : 'assistant',
      'content': msg.text,
    });
  }

  final body = json.encode({
    'model': 'gpt-3.5-turbo',
    'messages': messages,
    'max_tokens': 300,
    'n': 1,
    'temperature': 0.7,
  });

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['choices'][0]['message']['content'].trim();
  } else {
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    throw Exception('Failed to load data from ChatGPT API');
  }
}

Future<List<String>> getSuggestions(
    Budget updatedSelectedBudget, String firstName) async {
  // Prepare the prompt for the ChatGPT API
  String prompt =
      "As a Financial Coach for the Budgeting App, TheNoughtPlan, provide a numbered list of suggestions and recommendations for $firstName based on their budget details. Consider $firstName's spending type (${updatedSelectedBudget.spendingType}), saving type (${updatedSelectedBudget.savingType}), and debt type (${updatedSelectedBudget.debtType}). Speak about things they can improve on. Address the user, $firstName. Here are the budget details: Budget ID: ${updatedSelectedBudget.budgetId}, Budget Name: ${updatedSelectedBudget.budgetName}, Budget Date: ${updatedSelectedBudget.budgetDate}, Budget Type: ${updatedSelectedBudget.budgetType}, Currency: ${updatedSelectedBudget.currency}, Debt Expenses: ${updatedSelectedBudget.debtExpense}, Debt Type: ${updatedSelectedBudget.debtType}, Discretionary Expenses: ${updatedSelectedBudget.discretionaryExpense}, User ID: ${updatedSelectedBudget.userId}, Necessary Expenses: ${updatedSelectedBudget.necessaryExpense}, Salary: ${updatedSelectedBudget.salary}, Saving Type: ${updatedSelectedBudget.savingType}, Spending Type: ${updatedSelectedBudget.spendingType}. The actual expenses for the past month include: ${updatedSelectedBudget.actualExpenses}. Do not include a valediction in your response and do not use words like 'Firstly', 'Secondly', 'Thirdly', 'Finally', 'Lastly', etc. Keep responses under 300 words";
  String response = await callChatGPT(prompt);
  String decodedResponse = utf8.decode(response.codeUnits);
  List<String> suggestions =
      decodedResponse.split(RegExp(r'(?<!\$)\s*\d+\.\s*(?=\D)'));

  suggestions.removeAt(0);
  return suggestions;
}

Future<List<String>> getHighlights(
    Budget updatedSelectedBudget, String firstName) async {
  // Prepare the prompt for the ChatGPT API
  String prompt =
      "Pretend that you are a Personal Finance Advisor for the Budgeting App, TheNoughtPlan. Provide a numbered list of the most notable things and the high points about $firstName's budget. Speak about things they did right. Separate each highlight into a numbered list item. Please direct your response to the user, $firstName. Here are the budget details: Budget ID: ${updatedSelectedBudget.budgetId}, Budget Name: ${updatedSelectedBudget.budgetName}, Budget Date: ${updatedSelectedBudget.budgetDate}, Budget Type: ${updatedSelectedBudget.budgetType}, Currency: ${updatedSelectedBudget.currency}, Debt Expenses: ${updatedSelectedBudget.debtExpense}, Debt Type: ${updatedSelectedBudget.debtType}, Discretionary Expenses: ${updatedSelectedBudget.discretionaryExpense}, User ID: ${updatedSelectedBudget.userId}, Necessary Expenses: ${updatedSelectedBudget.necessaryExpense}, Salary: ${updatedSelectedBudget.salary}, Saving Type: ${updatedSelectedBudget.savingType}, Spending Type: ${updatedSelectedBudget.spendingType}. The actual expenses for the past month include: ${updatedSelectedBudget.actualExpenses}. Do not include a valediction in your response and do not use words like 'Firstly', 'Secondly', 'Thirdly', 'Finally', 'Lastly', etc. Keep responses under 300 words";
  String response = await callChatGPT(prompt);
  String decodedResponse = utf8.decode(response.codeUnits);
  List<String> highlights =
      decodedResponse.split(RegExp(r'(?<!\$)\s*\d+\.\s*(?=\D)'));

  highlights.removeAt(0); // Remove the first empty item in the list
  return highlights;
}
