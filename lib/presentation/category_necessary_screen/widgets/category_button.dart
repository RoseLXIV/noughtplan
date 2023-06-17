import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
import 'package:noughtplan/widgets/custom_button.dart';

import '../../../widgets/custom_text_button.dart';

class CategoryButton extends ConsumerWidget {
  final int index;
  final String text;
  final bool isFromSearchResults;

  CategoryButton({
    required this.index,
    required this.text,
    this.isFromSearchResults = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonListState = ref.watch(buttonListStateProvider);
    final selectedButtons = buttonListState.selectedCategories.values
        .expand((element) => element)
        .toList();
    final isSelected = selectedButtons.contains(text);

    return CustomTextButton(
      height: 40,
      text: text,
      onTap: () {
        if (isFromSearchResults) {
          if (!isSelected) {
            ref.read(buttonListStateProvider.notifier).addCategory(
                  text,
                  ref,
                );
          }
        } else {
          ref
              .read(buttonListStateProvider.notifier)
              .toggleButton(context, index, text, ref);
        }
        print('index: $index, text: $text, isSelected: $isSelected');
      },
      variant: isSelected
          ? ButtonTextVariant.OutlineBlueA700
          : ButtonTextVariant.FillGray50,
      padding: ButtonTextPadding.PaddingAll9,
      fontStyle: isSelected
          ? ButtonFontStyleText.ManropeBold12Bluegray300
          : ButtonFontStyleText.ManropeSemiBold12Bluegray300,
    );
  }
}
