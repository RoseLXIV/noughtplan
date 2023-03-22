import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/presentation/category_discretionary_screen/category_discretionary_screen.dart';
// import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
import 'package:noughtplan/widgets/custom_button.dart';

import '../../../widgets/custom_text_button.dart';

class CategoryButtonDiscretionary extends ConsumerWidget {
  final int index;
  final String text;
  final bool isFromSearchResults;

  CategoryButtonDiscretionary({
    required this.index,
    required this.text,
    this.isFromSearchResults = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonListState = ref.watch(buttonListStateProviderDiscretionary);
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
            ref
                .read(buttonListStateProviderDiscretionary.notifier)
                .addCategory(text);
          }
        } else {
          ref.read(buttonListStateProviderDiscretionary.notifier).toggleButton(
                context,
                index,
                text,
              );
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
