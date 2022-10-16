import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
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
  final String? pagesId;

  const PagerWidget({super.key, required this.pages, this.pagesId});

  @override
  _PagerWidgetState createState() => _PagerWidgetState();
}

class _PagerWidgetState extends State<PagerWidget> {
  final PreferencesProvider preferencesProvider = KiwiContainer().resolve();

  int _currentPage = 0;

  _PagerWidgetState();

  @override
  void initState() {
    super.initState();

    loadActivePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey(_currentPage),
          children: <Widget>[
            Expanded(
              child: widget.pages[_currentPage].widget(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: setActivePage,
        items: buildBottomNavigationBarItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    final bottomNavigationBarItems = <BottomNavigationBarItem>[];

    for (final page in widget.pages) {
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          icon: page.icon,
          label: page.text,
        ),
      );
    }
    return bottomNavigationBarItems;
  }

  Future<void> setActivePage(int page) async {
    if (page < 0 || page >= widget.pages.length) {
      return;
    }

    setState(() {
      _currentPage = page;
    });

    if (widget.pagesId == null) return;
    await preferencesProvider.set("${widget.pagesId}_active_page", page);
  }

  Future<void> loadActivePage() async {
    if (widget.pagesId == null) return;

    final selectedPage = await preferencesProvider.get<int>(
      "${widget.pagesId}_active_page",
    );

    if (selectedPage == null) return;

    if (selectedPage > 0 && selectedPage < widget.pages.length) {
      setState(() {
        _currentPage = selectedPage;
      });
    }
  }
}

class PageDefinition<T extends BaseViewModel> {
  final Widget icon;
  final String text;
  final WidgetBuilder builder;
  final T? viewModel;

  const PageDefinition({
    required this.icon,
    required this.text,
    required this.builder,
    this.viewModel,
  });

  /// Wraps the Widget with a [ChangeNotifierProvider] if [viewModel] is specified.
  Widget widget(BuildContext context) {
    if (viewModel == null) return builder(context);

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: builder(context),
    );
  }
}
