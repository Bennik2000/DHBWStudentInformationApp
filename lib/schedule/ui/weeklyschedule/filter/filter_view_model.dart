import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_filter_repository.dart';

class FilterViewModel extends BaseViewModel {
  final ScheduleEntryRepository _scheduleEntryRepository;
  final ScheduleFilterRepository _scheduleFilterRepository;
  final ScheduleSourceProvider _scheduleSource;

  List<ScheduleEntryFilterState> filterStates = [];

  FilterViewModel(this._scheduleEntryRepository, this._scheduleFilterRepository,
      this._scheduleSource,) {
    loadFilterStates();
  }

  Future<void> loadFilterStates() async {
    final allNames =
        await _scheduleEntryRepository.queryAllNamesOfScheduleEntries();

    final filteredNames = await _scheduleFilterRepository.queryAllHiddenNames();

    allNames.sort((s1, s2) => s1!.compareTo(s2!));

    filterStates = allNames.map((e) {
      final isFiltered = filteredNames.contains(e);
      return ScheduleEntryFilterState(!isFiltered, e);
    }).toList();

    notifyListeners();
  }

  Future<void> applyFilter() async {
    final allFilteredNames = filterStates
        .where((element) => !element.isDisplayed!)
        .map((e) => e.entryName)
        .toList();

    await _scheduleFilterRepository.saveAllHiddenNames(allFilteredNames);

    _scheduleSource.fireScheduleSourceChanged();
  }
}

class ScheduleEntryFilterState {
  bool? isDisplayed;
  String? entryName;

  ScheduleEntryFilterState(this.isDisplayed, this.entryName);
}
