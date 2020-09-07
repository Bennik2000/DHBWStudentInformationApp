import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';

class ScheduleDiffCalculator {
  ScheduleDiff calculateDiff(
    Schedule oldSchedule,
    Schedule newSchedule,
  ) {
    var oldEntries = List<ScheduleEntry>.from(oldSchedule.entries);
    var newEntries = List<ScheduleEntry>.from(newSchedule.entries);

    var removedEntries = <ScheduleEntry>[];
    var addedEntries = <ScheduleEntry>[];

    for (var entry in oldEntries) {
      if (!newEntries.any((ScheduleEntry element) =>
          _areScheduleEntriesEqual(element, entry))) {
        removedEntries.add(entry);
      }
    }

    for (var entry in newEntries) {
      if (!oldEntries.any((ScheduleEntry element) =>
          _areScheduleEntriesEqual(element, entry))) {
        addedEntries.add(entry);
      }
    }

    var scheduleDiff =
        _tryConnectNewAndOldEntries(addedEntries, removedEntries);

    return scheduleDiff;
  }

  bool _areScheduleEntriesEqual(
    ScheduleEntry entry1,
    ScheduleEntry entry2,
  ) {
    return entry1.start.isAtSameMomentAs(entry2.start) &&
        entry1.end.isAtSameMomentAs(entry2.end) &&
        entry1.type == entry2.type &&
        (entry1.room ?? "") == (entry2.room ?? "") &&
        (entry1.details ?? "") == (entry2.details ?? "") &&
        (entry1.title ?? "") == (entry2.title ?? "") &&
        (entry1.professor ?? "") == (entry2.professor ?? "");
  }

  ScheduleDiff _tryConnectNewAndOldEntries(
    List<ScheduleEntry> addedEntries,
    List<ScheduleEntry> removedEntries,
  ) {
    var allDistinctTitles = <String>[];

    allDistinctTitles.addAll(addedEntries.map((ScheduleEntry e) => e.title));
    allDistinctTitles.addAll(removedEntries.map((ScheduleEntry e) => e.title));
    allDistinctTitles = allDistinctTitles.toSet().toList();

    var updatedEntries = <UpdatedEntry>[];
    var newEntries = <ScheduleEntry>[];
    var oldEntries = <ScheduleEntry>[];

    for (var intersectingTitle in allDistinctTitles) {
      var oldElementsWithName = removedEntries
          .where((ScheduleEntry e) => e.title == intersectingTitle)
          .toList();

      var newElementsWithName = addedEntries
          .where((ScheduleEntry e) => e.title == intersectingTitle)
          .toList();

      removedEntries.removeWhere(
        (ScheduleEntry e) => e.title == intersectingTitle,
      );
      addedEntries.removeWhere(
        (ScheduleEntry e) => e.title == intersectingTitle,
      );

      if (newElementsWithName.isEmpty && oldElementsWithName.isNotEmpty) {
        oldEntries.addAll(oldElementsWithName);
        continue;
      }

      if (oldElementsWithName.isEmpty && newElementsWithName.isNotEmpty) {
        newEntries.addAll(newElementsWithName);
        continue;
      }

      if (oldElementsWithName.length == 1 && newElementsWithName.length == 1) {
        updatedEntries.add(UpdatedEntry(
          newElementsWithName[0],
          newElementsWithName[0].getDifferentProperties(oldElementsWithName[0]),
        ));
        continue;
      }

      if (oldElementsWithName.length > 1 && newElementsWithName.length > 1) {
        _matchMNChangedElements(
          oldElementsWithName,
          newElementsWithName,
          updatedEntries,
          oldEntries,
          newEntries,
        );
        continue;
      }
    }

    return ScheduleDiff(
      updatedEntries: updatedEntries,
      removedEntries: oldEntries,
      addedEntries: newEntries,
    );
  }

  void _matchMNChangedElements(
      List<ScheduleEntry> oldElementsWithName,
      List<ScheduleEntry> newElementsWithName,
      List<UpdatedEntry> updatedEntries,
      List<ScheduleEntry> oldEntries,
      List<ScheduleEntry> newEntries) {
    if (oldElementsWithName.length == newElementsWithName.length) {
      for (var oldElement in oldElementsWithName) {
        ScheduleEntry nearestElement =
            _findNearestElementByStart(newElementsWithName, oldElement);

        newElementsWithName.remove(nearestElement);

        updatedEntries.add(
          UpdatedEntry(
            nearestElement,
            nearestElement.getDifferentProperties(oldElement),
          ),
        );
      }
    } else {
      for (var oldElement in oldElementsWithName) {
        oldEntries.add(oldElement);
      }

      for (var newElement in newElementsWithName) {
        newEntries.add(newElement);
      }
    }
  }

  ScheduleEntry _findNearestElementByStart(
      List<ScheduleEntry> elements, ScheduleEntry reference) {
    ScheduleEntry nearestElement = elements[0];
    Duration minimalDifference =
        reference.start.difference(nearestElement.start).abs();

    for (var newElement in elements) {
      var difference = reference.start.difference(newElement.start).abs();

      if (difference < minimalDifference) {
        nearestElement = newElement;
        minimalDifference = difference;
      }
    }
    return nearestElement;
  }
}

class ScheduleDiff {
  final List<ScheduleEntry> addedEntries;
  final List<ScheduleEntry> removedEntries;
  final List<UpdatedEntry> updatedEntries;

  ScheduleDiff({this.addedEntries, this.removedEntries, this.updatedEntries});

  bool didSomethingChange() {
    return addedEntries.isNotEmpty ||
        removedEntries.isNotEmpty ||
        updatedEntries.isNotEmpty;
  }
}

class UpdatedEntry {
  final ScheduleEntry entry;
  final List<String> properties;

  UpdatedEntry(this.entry, this.properties);
}
