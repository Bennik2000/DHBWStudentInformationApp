import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class PageableNavigationEntry extends NavigationEntry {
  List<NavigationEntry> _pages;

  ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);

  List<NavigationEntry> get pages =>
      _pages == null ? (_pages = initPages()) : _pages;

  List<NavigationEntry> initPages();

  void setPageIndex(int index) {
    if (index >= 0 && index < pages.length) {
      pageIndexNotifier.value = index;
    }
  }

  int getPageIndex() {
    return pageIndexNotifier.value;
  }

  NavigationEntry getActivePage() {
    return pages[pageIndexNotifier.value];
  }

  @override
  Key get key => getActivePage().key;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageIndexNotifier,
      builder: (BuildContext context, _, __) {
        var page = getActivePage();

        return Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: Column(
              key: page.key,
              children: <Widget>[
                Expanded(
                  child: _wrapWithChangeNotifier(
                    page.build(context),
                    page.viewModel(),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        );
      },
    );
  }

  Widget _wrapWithChangeNotifier(
    Widget child,
    BaseViewModel changeNotifier,
  ) {
    if (changeNotifier != null) {
      return ChangeNotifierProvider.value(
        value: changeNotifier,
        child: child,
      );
    }

    return child;
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    var items = <BottomNavigationBarItem>[];

    for (NavigationEntry page in pages) {
      items.add(
        new BottomNavigationBarItem(
          icon: page.icon(context),
          title: Text(page.title(context)),
        ),
      );
    }

    return BottomNavigationBar(
      onTap: _onTabTapped,
      currentIndex: getPageIndex(),
      items: items,
    );
  }

  void _onTabTapped(int index) {
    setPageIndex(index);
  }
}
