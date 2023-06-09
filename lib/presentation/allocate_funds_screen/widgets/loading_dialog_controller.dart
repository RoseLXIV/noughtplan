import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class LoadingDialogController {
  OverlayEntry? overlayEntry;

  void show(BuildContext context) {
    if (overlayEntry != null) {
      return;
    }

    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Container(
        color: Colors.black.withOpacity(0.7), // Darken the background
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    const SizedBox(height: 16.0),
                    StreamBuilder<String>(
                      stream: _stream(),
                      builder: (context, snapshot) {
                        return Text(snapshot.data ?? '',
                            style: AppStyle.txtHelveticaNowTextBold16
                                .copyWith(color: ColorConstant.blue90001));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    Overlay.of(context).insert(overlayEntry!);
  }

  void hide() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Stream<String> _stream() async* {
    yield 'Warming up the calculators...'; // Initial value
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      yield 'Doing the number crunch dance...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Building your budget like a boss...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Turning your coins into cool charts...';
      await Future.delayed(Duration(seconds: 2));
      yield "Your budget's in the oven, baking...";
      await Future.delayed(Duration(seconds: 2));
      yield 'Almost done, hold your breath...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Applying the final sparkle...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Boom! Your budget masterpiece is here!'; // Final text
      break; // Break the loop after the final text
    }
  }
}
