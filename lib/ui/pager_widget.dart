import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// This widget uses a [List<PageDefinition>] instance and displays a bottom
/// bar which displays the individual pages and allows navigating to them.
///
/// If the [PageDefinition] has a viewModel it provides it using a
/// [ChangeNotifierProvider]
///
class PagerWidget extends StatefulWidget {
  final List<PageDefinition> pages;

  const PagerWidget({Key key, @required this.pages}) : super(key: key);

  @override
  _PagerWidgetState createState() => _PagerWidgetState(pages);
}

class _PagerWidgetState extends State<PagerWidget> {
  int _currentPage = 0;
  final List<PageDefinition> pages;

  _PagerWidgetState(this.pages);

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
        onTap: (int index) {
          setState(() {
            _currentPage = index;
          });
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
