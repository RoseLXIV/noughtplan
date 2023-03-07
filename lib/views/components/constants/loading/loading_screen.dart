import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noughtplan/theme/app_style.dart';
import 'package:noughtplan/views/components/constants/loading/loading_screen_controller.dart';
import 'package:noughtplan/views/components/constants/string.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    // required String text,
  }) {
    final state = Overlay.of(context);
    // ignore: unnecessary_null_comparison
    if (state == null) {
      return null;
    }
    final textController = StreamController<String>();
    // textController.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.transparent,
        child: Container(
          height: size.height,
          width: size.width,
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(),
                // SizedBox(height: 10),
                StreamBuilder<String>(
                  stream: textController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data ?? '',
                          style: AppStyle.txtHelveticaNowTextBold16);
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        overlay.remove();
        textController.close();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
