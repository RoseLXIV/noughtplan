import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/call_chat_gpt_highlights.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/selected_budget_id.dart';
import 'package:noughtplan/presentation/chat_bot_screen/widgets/dancing_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message {
  final String text;
  final bool isUser;
  final bool isLoading;

  Message({required this.text, required this.isUser, this.isLoading = false});

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'isLoading': isLoading,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isUser: json['isUser'],
      isLoading: json['isLoading'],
    );
  }
}

final ScrollController _scrollController = ScrollController();

void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  });
}

const String _messagesKey = 'messages';

Future<void> saveMessages(List<Message> messages, String budgetId) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = json.encode(messages.map((msg) => msg.toJson()).toList());
  await prefs.setString('messages_$budgetId', jsonString);
}

Future<List<Message>> loadMessages(String budgetId) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('messages_$budgetId') ?? '[]';
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => Message.fromJson(json)).toList();
}

class ChatBotNotifier extends StateNotifier<List<Message>> {
  ChatBotNotifier({required String? budgetId}) : super([]) {
    _loadMessages(budgetId);
  }

  List<Message> conversationHistory = [];
  bool isLoading = false;

  Future<void> _loadMessages(String? budgetId) async {
    if (budgetId != null) {
      List<Message> messages = await loadMessages(budgetId);
      if (messages.isEmpty) {
        // Add an initial message if the chat is empty
        messages.add(Message(
            text:
                "👋 Hi there! I'm your financial advisor from TheNoughtPlan. I'm here to help you manage your budget and answer any questions you have. Let's achieve your financial goals together! 😊",
            isUser: false));
      }
      state = messages;
      conversationHistory = messages;
    }
  }

  Future<void> clearChat(String budgetId) async {
    state = [];
    conversationHistory = [];
    await saveMessages(conversationHistory, budgetId);
  }

  // Update the sendMessage method accordingly
  Future<void> sendMessage(
      String message, String firstName, Budget selectedBudget,
      {required VoidCallback onBotResponse}) async {
    // Add user message to the list
    state = [...state, Message(text: message, isUser: true)];

    // Add a loading message
    state = [...state, Message(text: '', isUser: false, isLoading: true)];

    onBotResponse();

    // Add user message to the conversation history
    conversationHistory.add(Message(text: message, isUser: true));

    // Save messages
    await saveMessages(conversationHistory, selectedBudget.budgetId);

    // Simulate a delay before getting the response
    await Future.delayed(Duration(seconds: 1));

    // Get chatbot response
    try {
      final chatbotResponse = await callChatGPTBot(
          message, firstName, selectedBudget, conversationHistory);

      // Remove the loading message
      state.removeLast();

      // Add chatbot message to the list
      state = [...state, Message(text: chatbotResponse, isUser: false)];

      // Add chatbot message to the conversation history
      conversationHistory.add(Message(text: chatbotResponse, isUser: false));

      // Save messages
      await saveMessages(conversationHistory, selectedBudget.budgetId);

      // Call the callback function after receiving the bot response
      onBotResponse();

      // Scroll to the bottom
      _scrollToBottom();
    } catch (e) {
      // Handle error in fetching response
      print("Error: $e");
    }
  }
}

final chatBotProvider = StateNotifierProvider<ChatBotNotifier, List<Message>>(
  (ref) {
    final budgetId = ref.watch(selectedBudgetIdProvider);
    return ChatBotNotifier(budgetId: budgetId);
  },
);

class ChatBotScreen extends ConsumerWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Budget selectedBudget = args['budget'];
    final String firstName = args['firstName'];

    final messages = ref.watch(chatBotProvider);
    final TextEditingController _controller = TextEditingController();

    FocusNode _textFieldFocusNode = FocusNode();

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform(
                  transform: Matrix4.identity()..scale(1.0, 1.0, 0.1),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgTopographic7,
                    height: MediaQuery.of(context).size.height *
                        1, // Set the height to 50% of the screen height
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to the full screen width
                    // alignment: Alignment.,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgGroup183001,
                          height: getVerticalSize(
                            53,
                          ),
                          width: getHorizontalSize(
                            161,
                          ),
                          alignment: Alignment.topLeft,
                          margin: getMargin(
                            left: 17,
                            top: 25,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              Padding(
                                padding: getPadding(
                                  right: 17,
                                  top: 28,
                                ),
                                child: IconButton(
                                  icon: CustomImageView(
                                    svgPath: ImageConstant.imgTrashNew,
                                    color: ColorConstant.redA700,
                                    height: getSize(
                                      24,
                                    ),
                                    width: getSize(
                                      24,
                                    ),
                                  ), // Replace with your desired icon
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Clear chat',
                                            style: AppStyle
                                                .txtHelveticaNowTextBold18
                                                .copyWith(letterSpacing: 0.2),
                                          ),
                                          content: Text(
                                            'Are you sure you want to clear the chat?',
                                            style: AppStyle.txtManropeRegular14
                                                .copyWith(letterSpacing: 0.2),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel',
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold14
                                                      .copyWith(
                                                          letterSpacing: 0.2)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Clear',
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold14
                                                      .copyWith(
                                                          letterSpacing: 0.2,
                                                          color: ColorConstant
                                                              .redA700)),
                                              onPressed: () async {
                                                await ref
                                                    .read(chatBotProvider
                                                        .notifier)
                                                    .clearChat(selectedBudget
                                                        .budgetId);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  right: 17,
                                  top: 34,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Please read the instructions below',
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16,
                                          ),
                                          content: Text(
                                            "In this step, you'll be able to add discretionary categories to your budget. Follow the instructions below:\n\n"
                                            "1. Browse through the available categories or use the search bar to find specific ones that match your interests and lifestyle.\n"
                                            "2. Tap on a category to add it to your chosen categories list. You can always tap again to remove it if needed.\n"
                                            "3. Once you've added all the discretionary categories you want, press the 'Next' button to move on to reviewing your budget.\n\n"
                                            "Remember, these discretionary categories represent your non-essential expenses, such as entertainment, hobbies, and dining out. Adding them thoughtfully will help you create a balanced budget, allowing for personal enjoyment while still managing your finances effectively.",
                                            textAlign: TextAlign.center,
                                            style: AppStyle.txtManropeRegular14,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 7),
                                    child: SvgPicture.asset(
                                      ImageConstant.imgQuestion,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: messages.length,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom +
                              16, // Add 16 as extra padding
                        ),
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          if (message.isLoading) {
                            _scrollToBottom();
                            return Padding(
                              padding: getPadding(top: 8),
                              child: Center(
                                  child: DancingDots(
                                      color: ColorConstant.blueA700)),
                            );
                          } else {
                            bool isUser = message.isUser;
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: getMargin(
                                        left: 16,
                                        right: 16,
                                        top: 16,
                                        bottom: 4),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? ColorConstant.blueA700
                                          : ColorConstant.gray50,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomLeft: isUser
                                            ? Radius.circular(16)
                                            : Radius.circular(0),
                                        bottomRight: isUser
                                            ? Radius.circular(0)
                                            : Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      message.text,
                                      style: isUser
                                          ? AppStyle.txtManropeSemiBold14
                                              .copyWith(
                                              color: ColorConstant.whiteA700,
                                            )
                                          : AppStyle.txtManropeRegular14
                                              .copyWith(
                                                  color: ColorConstant.gray900),
                                    ),
                                  ),
                                  Align(
                                    alignment: isUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: isUser
                                          ? EdgeInsets.only(right: 24.0)
                                          : EdgeInsets.only(left: 24.0),
                                      // child: Text(
                                      //   isUser
                                      //       ? 'You'
                                      //       : 'A.I. Financial Advisor',
                                      //   style: isUser
                                      //       ? AppStyle.txtHelveticaNowTextBold12
                                      //           .copyWith(
                                      //               color:
                                      //                   ColorConstant.blueA700,
                                      //               letterSpacing: 0.3)
                                      //       : AppStyle.txtHelveticaNowTextBold12
                                      //           .copyWith(
                                      //               color:
                                      //                   ColorConstant.gray900,
                                      //               letterSpacing: 0.3),
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            depth: 10,
            intensity: 0.5,
            surfaceIntensity: 0.1,
            lightSource: LightSource.bottom,
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),
          child: Container(
            padding: getPadding(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _textFieldFocusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppStyle.txtManropeRegular16.copyWith(
                        color: ColorConstant.blueGray300,
                      ),
                      suffixIcon: IconButton(
                        icon: Container(
                          padding: getPadding(top: 2, bottom: 2),
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/images/send.svg', // Replace with your SVG asset path
                            color: ColorConstant.blueA70099,
                          ),
                        ),
                        onPressed: () {
                          // Handle send button press here
                          String message = _controller.text;
                          if (message.isNotEmpty) {
                            ref.read(chatBotProvider.notifier).sendMessage(
                                message, firstName, selectedBudget,
                                onBotResponse: _scrollToBottom);
                            _controller.clear();
                            // Clear the text field without closing the keyboard
                            _scrollToBottom();
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    // Handle the message submission here
                    onSubmitted: (String text) {
                      if (text.trim().isNotEmpty) {
                        _controller.clear();
                        ref.read(chatBotProvider.notifier).sendMessage(
                            text, firstName, selectedBudget,
                            onBotResponse: _scrollToBottom);
                        _scrollToBottom();

                        _textFieldFocusNode.requestFocus();
                      }
                    },

                    style: AppStyle.txtManropeRegular16.copyWith(
                      color: ColorConstant.gray900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
