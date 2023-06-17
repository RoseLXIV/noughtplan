import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/core/constants/budgets.dart';
import 'package:noughtplan/core/utils/color_constant.dart';
import 'package:noughtplan/presentation/allocate_funds_screen_edit/allocate_funds_screen_edit.dart';
import 'package:noughtplan/presentation/category_necessary_screen_edit/category_necessary_screen_edit.dart';
import 'package:noughtplan/presentation/generator_salary_screen_edit/generator_salary_screen_edit.dart';

final pageViewControllerProvider =
    Provider.autoDispose<PageController>((ref) => PageController());

final currentIndexProvider = StateProvider<int>((ref) => 0);

class BudgetCreationPageViewEdit extends HookConsumerWidget {
  final int initialIndex;
  Budget? selectedBudget;

  BudgetCreationPageViewEdit({
    required this.initialIndex,
    required this.selectedBudget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late PageController _pageController;
    final currentIndex = ref.watch(currentIndexProvider.notifier);
    final budgetNotifier = ref.watch(budgetStateProvider.notifier);
    final _budgets = useState<List<Budget?>?>(null);
    Budget? _updatedSelectedBudget;
    int _currentIndex = initialIndex;

    void updateBudgets() async {
      final fetchedBudgets = await budgetNotifier.fetchUserBudgets();
      if (context.mounted) {
        _budgets.value = fetchedBudgets;
        final updatedSelectedBudget = _budgets.value!.firstWhere(
          (budget) => budget?.budgetId == selectedBudget?.budgetId,
          orElse: () => null,
        );
        _updatedSelectedBudget = updatedSelectedBudget;
        selectedBudget = updatedSelectedBudget;
      }
    }

    useEffect(() {
      updateBudgets();
      return () {};
    }, []);

    print('selected budget in creation: ${_updatedSelectedBudget?.currency}');
    print('selected budget in creation: ${selectedBudget?.currency}');

    // void onPageChanged(int index) {
    //   if (index == initialIndex) {
    //     // Navigate to the desired page
    //     pageController.animateToPage(
    //       initialIndex,
    //       duration: Duration(milliseconds: 300),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    //   ref.read(currentIndexProvider.notifier).state = index;
    // }

    _pageController = PageController(initialPage: _currentIndex);

    Widget buildDot(int index) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: currentIndex.state == index ? 24 : 8,
        decoration: BoxDecoration(
          color: currentIndex.state == index
              ? ColorConstant.blueA700
              : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: [
                    GeneratorSalaryScreenEdit(
                      selectedBudget: _updatedSelectedBudget ?? selectedBudget!,
                    ),
                    CategoryNecessaryScreenEdit(
                      selectedBudget: _updatedSelectedBudget ?? selectedBudget!,
                    ),
                    AllocateFundsScreenEdit(
                      selectedBudget: _updatedSelectedBudget ?? selectedBudget!,
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDot(0),
                    buildDot(1),
                    buildDot(2),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
