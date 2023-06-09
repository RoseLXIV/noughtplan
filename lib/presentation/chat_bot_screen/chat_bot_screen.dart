import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/providers/first_time_provider.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/call_chat_gpt_highlights.dart';
import 'package:noughtplan/presentation/budget_screen/widgets/selected_budget_id.dart';
import 'package:noughtplan/presentation/chat_bot_screen/widgets/dancing_dots.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class Message {
  final String text;
  final bool isUser;
  final bool isLoading;
  final bool isError;

  Message({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.isError = false,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'isLoading': isLoading,
        'isError': isError,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isUser: json['isUser'],
      isLoading: json['isLoading'] ?? false,
      isError: json['isError'] ?? false,
    );
  }
}

final ScrollController _scrollController = ScrollController();

void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  });
}

void _scrollToBottomMessage() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  });
}

void _initialScrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.positions.forEach((position) {
        position.jumpTo(position.maxScrollExtent);
      });
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

  Future<void> simulateTyping(
      String chatbotResponse, Budget selectedBudget) async {
    final delayDuration = Duration(milliseconds: 10); // Adjust typing speed
    String currentMessage = '';

    CancelableOperation? debounceScroll;

    for (int i = 0; i < chatbotResponse.length; i++) {
      // If the message was cancelled, stop simulating typing
      if (!(_timer?.isActive ?? false)) {
        break;
      }

      currentMessage = chatbotResponse.substring(0, i + 1);
      state = [
        ...state.sublist(0, state.length - 1),
        Message(text: currentMessage, isUser: false),
      ];
      await Future.delayed(delayDuration);

      // Cancel the previous scroll operation if it hasn't started yet
      debounceScroll?.cancel();

      // Schedule a new scroll operation after a short delay
      debounceScroll = CancelableOperation.fromFuture(
        Future.delayed(Duration(milliseconds: 100), _scrollToBottom),
      );
    }

    // Make sure the last scroll operation is executed
    if (!debounceScroll!.isCompleted) {
      await debounceScroll.value;
    }
  }

  // Update the sendMessage method accordingly
  Future<void> sendMessage(
      String message, String firstName, Budget selectedBudget,
      {required VoidCallback onBotResponse}) async {
    // Start a timer that will cancel the message after 60 seconds
    _timer = Timer(Duration(seconds: 60), () {
      state.removeLast();
      cancelMessage();
      state = [
        ...state,
        Message(
          text: 'Something went wrong. Please check back later or try again.',
          isError: true,
          isUser: false,
        )
      ];
      onBotResponse();
    });

    // Add user message to the list
    state = [...state, Message(text: message, isUser: true)];

    // Add user message to the conversation history
    conversationHistory.add(Message(text: message, isUser: true));

    // Save messages after adding user message
    await saveMessages(conversationHistory, selectedBudget.budgetId);

    // Add a loading message
    state = [...state, Message(text: '', isUser: false, isLoading: true)];

    // // Add loading message to the conversation history
    // conversationHistory.add(Message(text: '', isUser: false, isLoading: true));

    // // Save messages after adding loading message
    // await saveMessages(conversationHistory, selectedBudget.budgetId);

    onBotResponse();

    // Get chatbot response
    try {
      final chatbotResponse = await callChatGPTBot(
          message, firstName, selectedBudget, conversationHistory);

      // If the message wasn't cancelled, simulate typing and add chatbot response
      if (_timer?.isActive ?? false) {
        await simulateTyping(chatbotResponse, selectedBudget);
      }

      // Cancel the timer if it's still active
      _timer?.cancel();

      // Remove the loading message
      state.removeLast();

      // Remove the loading message from the conversation history
      // conversationHistory.removeLast();

      // Add chatbot message to the list
      state = [...state, Message(text: chatbotResponse, isUser: false)];

      // Add chatbot message to the conversation history
      conversationHistory.add(Message(text: chatbotResponse, isUser: false));

      // Save messages after receiving the bot response
      await saveMessages(conversationHistory, selectedBudget.budgetId);

      // Call the callback function after receiving the bot response
      onBotResponse();
    } catch (e) {
      // Handle error in fetching response
      print("Chat Message Failed: $e");
    }
  }

  Timer? _timer;

  void cancelMessage() {
    // Cancel the timer if it is active
    _cancelTimer();

    // Remove the last message from state and conversation history
    // if (state.isNotEmpty) {
    //   state = state.sublist(0, state.length - 1);
    //   conversationHistory =
    //       conversationHistory.sublist(0, conversationHistory.length - 1);
    // }
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }
}

final chatBotProvider = StateNotifierProvider<ChatBotNotifier, List<Message>>(
  (ref) {
    return ChatBotNotifier(budgetId: null);
  },
);

class ChatBotScreen extends HookConsumerWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _animationController =
        useAnimationController(duration: const Duration(seconds: 1));

    final firstTime = ref.watch(firstTimeProvider);
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Budget selectedBudget = args['budget'];
    final String firstName = args['firstName'];

    final messages = ref.watch(chatBotProvider);
    final TextEditingController _controller = TextEditingController();

    FocusNode _textFieldFocusNode = FocusNode();

    useEffect(() {
      Future.microtask(() {
        _animationController.repeat(reverse: true);
        ref
            .read(chatBotProvider.notifier)
            ._loadMessages(selectedBudget.budgetId);
        _initialScrollToBottom();

        return null;
      });
    }, []);

    late Timer _timer;

    Future<int> getRemainingTrialTime() async {
      final prefs = await SharedPreferences.getInstance();
      final trialStartTimeStr = prefs.getString('free_trial_start');
      if (trialStartTimeStr != null) {
        final trialStart = DateTime.parse(trialStartTimeStr);
        // Calculate the end of the trial
        final trialEnd = trialStart.add(Duration(days: 1));
        final currentTime = DateTime.now();
        if (trialEnd.isAfter(currentTime)) {
          final remainingTime = trialEnd.difference(currentTime);
          return remainingTime.inSeconds;
        }
      }
      return 0;
    }

    Stream<String> remainingTrialTime() async* {
      while (true) {
        final remainingTime = await getRemainingTrialTime();
        final totalHours = remainingTime ~/ Duration.secondsPerHour;
        final totalMinutes = (remainingTime % Duration.secondsPerHour) ~/
            Duration.secondsPerMinute;
        final seconds = remainingTime % Duration.secondsPerMinute;

        final days = totalHours ~/ Duration.hoursPerDay;
        final hoursLeft = totalHours % Duration.hoursPerDay;
        final minutes = totalMinutes % Duration.minutesPerHour;

        yield "${days}D ${hoursLeft.toString().padLeft(2, '0')}H:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} left";

        await Future.delayed(Duration(seconds: 1));
      }
    }

    Future<Map<String, dynamic>> getSubscriptionInfo() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> subscriptionInfo = {
        'isSubscribed': false,
        'expiryDate': null
      };

      if (firebaseUser != null) {
        try {
          CustomerInfo customerInfo = await Purchases.getCustomerInfo();
          bool isSubscribed =
              customerInfo.entitlements.all['pro_features']?.isActive ?? false;

          // parse the String into a DateTime
          String? expiryDateString =
              customerInfo.entitlements.all['pro_features']?.expirationDate;

          String? managementUrl = customerInfo.managementURL;
          DateTime? expiryDate;
          if (expiryDateString != null) {
            expiryDate = DateTime.parse(expiryDateString);
          }

          subscriptionInfo['isSubscribed'] = isSubscribed;
          subscriptionInfo['expiryDate'] = expiryDate;
          subscriptionInfo['managementUrl'] = managementUrl;
        } catch (e) {
          print('Failed to get customer info: $e');
        }
      }
      return subscriptionInfo;
    }

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
                    imagePath: ImageConstant.chatTopo,
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
                    Container(
                      height: getVerticalSize(
                        75,
                      ),
                      child: Row(
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
                              margin: getMargin(
                                left: 17,
                                top: 0,
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/home_page_screen',
                                );
                              }),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: getPadding(
                                  right: 0,
                                  top: 6,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  right: 17,
                                  top: 0,
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
                                  top: 0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'A.I. Financial Assistant',
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16,
                                          ),
                                          content: RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              style: AppStyle
                                                  .txtManropeRegular14
                                                  .copyWith(
                                                      color: ColorConstant
                                                          .blueGray800),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "Welcome to your A.I. Financial Advisor! Here's how to interact:\n\n"),
                                                TextSpan(
                                                    text: '1. Ask a Question:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        ' Simply input any finance-related question you may have into the text field. \n\n'),
                                                TextSpan(
                                                    text:
                                                        '2. Continue Using the App:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        ' After submitting your question, feel free to continue using the app. Your response will be generated even while you navigate other parts of the app. \n\n'),
                                                TextSpan(
                                                    text:
                                                        '3. Check the Response:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        ' Return to the A.I. Financial Advisor screen to see the response to your question. Please note, there may be a brief wait for the response. \n\n'),
                                                TextSpan(
                                                    text: '4. Clear the Chat:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        ' If you wish to clear the chat history, simply tap on the trash icon at the top of the screen.\n\n'),
                                                TextSpan(
                                                    text:
                                                        'Please remember that this A.I. Financial Advisor is designed to provide general financial guidance based on the information available. It should not replace advice from a professional financial advisor. If you require more detailed advice, please consider contacting a certified financial advisor.'),
                                              ],
                                            ),
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
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              boxShape:
                                                  NeumorphicBoxShape.circle(),
                                              depth: 0.9,
                                              intensity: 8,
                                              surfaceIntensity: 0.7,
                                              shadowLightColor: Colors.white,
                                              lightSource: LightSource.top,
                                              color: firstTime
                                                  ? ColorConstant.blueA700
                                                  : Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                              ImageConstant.imgQuestion,
                                              height: 24,
                                              width: 24,
                                              color: firstTime
                                                  ? ColorConstant.whiteA700
                                                  : ColorConstant.blueGray500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: AnimatedBuilder(
                                          animation: _animationController,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            if (!firstTime ||
                                                _animationController
                                                    .isCompleted)
                                              return SizedBox
                                                  .shrink(); // This line ensures that the arrow disappears after the animation has completed

                                            return Transform.translate(
                                              offset: Offset(
                                                  0,
                                                  -5 *
                                                      _animationController
                                                          .value),
                                              child: Padding(
                                                padding: getPadding(top: 16),
                                                child: SvgPicture.asset(
                                                  ImageConstant
                                                      .imgArrowUp, // path to your arrow SVG image
                                                  height: 24,
                                                  width: 24,
                                                  color: ColorConstant.blueA700,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: getSubscriptionInfo(),
                      builder: (context, subscriptionSnapshot) {
                        if (subscriptionSnapshot.hasData) {
                          if (subscriptionSnapshot.data!['isSubscribed']
                              as bool) {
                            // If the user is a subscriber, don't show the timer
                            return SizedBox.shrink();
                          } else {
                            // If the user isn't a subscriber, show the timer
                            return StreamBuilder<String>(
                              stream: remainingTrialTime(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: getPadding(bottom: 8),
                                    child: Text(snapshot.data!,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold12
                                            .copyWith(
                                                letterSpacing: 0.2,
                                                color: ColorConstant.gray900)),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            );
                          }
                        } else {
                          // While loading the subscription info, don't show the timer
                          return CircularProgressIndicator();
                        }
                      },
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

                          if (message.isError) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: ColorConstant
                                          .redA700, // Color for the error message
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      message.text,
                                      style: AppStyle.txtManropeRegular14
                                          .copyWith(
                                              color: ColorConstant.whiteA700),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 24.0),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (message.isLoading) {
                            // This is the loading indicator
                            return Padding(
                              padding: getPadding(top: 16, left: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DancingDots(color: ColorConstant.blueA700),
                                ],
                              ),
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
                                onBotResponse: _scrollToBottomMessage);
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
                            onBotResponse: _scrollToBottomMessage);
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
