import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:dhbwstudentapp/ui/navigation/single_navigation_entry.dart';
import 'package:flutter/material.dart';

abstract class PageableNavigationEntry extends NavigationEntry {
  List<SingleNavigationEntry> _pages;
  int _pageIndex = 0;

  List<SingleNavigationEntry> get pages =>
      _pages == null ? (_pages = initPages()) : _pages;

  List<SingleNavigationEntry> initPages();

  void setPageIndex(int index) {
    if (index >= 0 && index < pages.length) {
      _pageIndex = index;
    }
  }

  int getPageIndex() {
    return _pageIndex;
  }

  SingleNavigationEntry getActivePage() {
    return pages[_pageIndex];
  }

  @override
  Key get key => getActivePage().key;
}
