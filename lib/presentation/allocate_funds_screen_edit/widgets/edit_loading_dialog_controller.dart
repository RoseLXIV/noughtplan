import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class EditLoadingDialogController {
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
    yield 'Kicking off the budget makeover...'; // Initial value
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      yield 'Jazzing up the numbers...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Revamping your budget, like a pro...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Turning those changes into cool visuals...';
      await Future.delayed(Duration(seconds: 2));
      yield "Your budget's under construction...";
      await Future.delayed(Duration(seconds: 2));
      yield 'Almost there, anticipation rising...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Applying the final touches...';
      await Future.delayed(Duration(seconds: 2));
      yield 'Voila! Your refreshed budget is here!'; // Final text
      break; // Break the loop after the final text
    }
  }
}
