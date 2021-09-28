import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/filter/filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ScheduleFilterPage extends StatelessWidget {
  final FilterViewModel _viewModel = FilterViewModel(
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
    KiwiContainer().resolve(),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _viewModel.applyFilter();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          brightness: Theme.of(context).brightness,
          iconTheme: Theme.of(context).iconTheme,
          title: Text("Filter"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child:
                  Text("Wähle die Vorlesungen, die angezeigt werden sollen:"),
            ),
            Expanded(
              child: PropertyChangeProvider(
                value: _viewModel,
                child: PropertyChangeConsumer(
                    builder: (BuildContext _, FilterViewModel viewModel,
                            Set<Object> ___) =>
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.filterStates.length,
                          itemBuilder: (context, index) =>
                              FilterStateRow(viewModel.filterStates[index]),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterStateRow extends StatefulWidget {
  final ScheduleEntryFilterState filterState;

  FilterStateRow(this.filterState)
      : super(key: ValueKey(filterState.entryName));

  @override
  _FilterStateRowState createState() => _FilterStateRowState();
}

class _FilterStateRowState extends State<FilterStateRow> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    isChecked = widget.filterState.isDisplayed;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isChecked,
      onChanged: (checked) {
        setState(() {
          isChecked = checked;
          widget.filterState.isDisplayed = isChecked;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(widget.filterState.entryName),
    );
  }
}
