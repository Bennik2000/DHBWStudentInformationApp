import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

///
/// This widget uses a [List<PageDefinition>] instance and displays a bottom
/// bar which displays the individual pages and allows navigating to them.
///
/// If the [PageDefinition] has a viewModel it provides it using a
/// [ChangeNotifierProvider]
///
/// When a [pagesId] is provided, the active page is saved
///
class PagerWidget extends StatefulWidget {
  final List<PageDefinition> pages;
  final String pagesId;

  const PagerWidget({Key key, @required this.pages, this.pagesId})
      : super(key: key);

  @override
  _PagerWidgetState createState() => _PagerWidgetState(pages, pagesId);
}

class _PagerWidgetState extends State<PagerWidget> {
  final PreferencesProvider preferencesProvider = KiwiContainer().resolve();

  final String pagesId;
  final List<PageDefinition> pages;
  int _currentPage = 0;

  _PagerWidgetState(this.pages, this.pagesId);

  @override
  void initState() {
    super.initState();

    loadActivePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Column(
          key: ValueKey(_currentPage),
          children: <Widget>[
            Expanded(
              child: _wrapWithChangeNotifierProvider(
                pages[_currentPage].builder(context),
                pages[_currentPage].viewModel,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int index) async {
          await setActivePage(index);
        },
        items: buildBottomNavigationBarItems(),
      ),
    );
  }

  Widget _wrapWithChangeNotifierProvider(Widget child, BaseViewModel value) {
    if (value == null) return child;

    return ChangeNotifierProvider.value(
      child: child,
      value: value,
    );
  }

  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    var bottomNavigationBarItems = <BottomNavigationBarItem>[];

    for (var page in pages) {
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          icon: page.icon,
          title: page.text,
        ),
      );
    }
    return bottomNavigationBarItems;
  }

  Future<void> setActivePage(int page) async {
    if (page < 0 || page >= pages.length) {
      return;
    }

    setState(() {
      _currentPage = page;
    });

    if (pagesId == null) return;
    await preferencesProvider.set("${pagesId}_active_page", page);
  }

  Future<void> loadActivePage() async {
    if (pagesId == null) return;

    var selectedPage = await preferencesProvider.get<int>(
      "${pagesId}_active_page",
    );

    if (selectedPage == null) return;

    if (selectedPage > 0 && selectedPage < pages.length) {
      setState(() {
        _currentPage = selectedPage;
      });
    }
  }
}

class PageDefinition {
  final Widget icon;
  final Widget text;
  final WidgetBuilder builder;
  final BaseViewModel viewModel;

  PageDefinition({
    @required this.icon,
    @required this.text,
    @required this.builder,
    this.viewModel,
  });
}
