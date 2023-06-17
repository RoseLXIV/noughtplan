import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:noughtplan/presentation/category_necessary_screen_edit/category_necessary_screen_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/custom_text_button.dart';

class CategoryButtonEdit extends ConsumerWidget {
  final int index;
  final String text;
  final bool isFromSearchResults;
  // final Map<String, List<String>> selectedCategories;

  CategoryButtonEdit({
    required this.index,
    required this.text,
    this.isFromSearchResults = false,
    // required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonListState = ref.watch(buttonListStateProviderEdit);
    final selectedButtons = buttonListState.selectedCategories.values
        .expand((element) => element)
        .toList();

    print('selectedButtons: $selectedButtons');
    final isSelected = selectedButtons.contains(text);

    return CustomTextButton(
      height: 40,
      text: text,
      onTap: () async {
        if (isFromSearchResults) {
          if (!isSelected) {
            ref.read(buttonListStateProviderEdit.notifier).addCategory(text);
            final prefs = await SharedPreferences.getInstance();
            List<String>? searchCategories =
                prefs.getStringList('searchCategories');
            if (searchCategories == null) {
              searchCategories = [];
            }
            searchCategories.add(text);
            await prefs.setStringList('searchCategories', searchCategories);
          }
        } else {
          ref.read(buttonListStateProviderEdit.notifier).toggleButton(
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
