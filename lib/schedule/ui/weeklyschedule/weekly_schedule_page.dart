import 'package:animations/animations.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/widgets/error_display.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_entry.dart';
import 'package:dhbwstudentapp/schedule/ui/viewmodels/weekly_schedule_view_model.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/schedule_entry_detail_bottom_sheet.dart';
import 'package:dhbwstudentapp/schedule/ui/weeklyschedule/widgets/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({Key? key}) : super(key: key);

  @override
  _WeeklySchedulePageState createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  late WeeklyScheduleViewModel viewModel;
  Schedule? schedule;

  _WeeklySchedulePageState();

  @override
  void initState() {
    super.initState();
  }

  void _showQueryFailedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(L.of(context).scheduleQueryFailedMessage),
            TextButton(
              child: Text(
                  L.of(context).scheduleQueryFailedOpenInBrowser.toUpperCase(),),
              onPressed: () {
                launchUrl(Uri.parse(viewModel.scheduleUrl!));
              },
            )
          ],
        ),
        duration: Duration(seconds: 15),
      ),
    );
  }

  void _previousWeek() async {
    await viewModel.previousWeek();
  }

  void _nextWeek() async {
    await viewModel.nextWeek();
  }

  void _goToToday() async {
    await viewModel.goToToday();
  }

  void _onScheduleEntryTap(BuildContext context, ScheduleEntry entry) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (context) => ScheduleEntryDetailBottomSheet(
        scheduleEntry: entry,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<WeeklyScheduleViewModel>(context);
    viewModel.ensureUpdateNowTimerRunning();

    viewModel.setQueryFailedCallback(_showQueryFailedSnackBar);

    return PropertyChangeProvider<WeeklyScheduleViewModel, String>(
      value: viewModel,
      child: GestureDetector(
        onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 10) {
            _previousWeek();
          } else if (details.velocity.pixelsPerSecond.dx < -10) {
            _nextWeek();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildNavigationButtonBar(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PropertyChangeConsumer(
                          properties: const ["weekSchedule", "now"],
                          builder: (BuildContext context,
                              WeeklyScheduleViewModel? model, Set? _,) {
                            return PageTransitionSwitcher(
                              reverse: !model!.didUpdateScheduleIntoFuture,
                              transitionBuilder: (Widget child,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,) =>
                                  SharedAxisTransition(
                                child: child,
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType:
                                    SharedAxisTransitionType.horizontal,
                              ),
                              child: ScheduleWidget(
                                key: ValueKey(
                                  model.currentDateStart!.toIso8601String(),
                                ),
                                schedule: model.weekSchedule,
                                displayStart: model.clippedDateStart ??
                                    model.currentDateStart,
                                displayEnd: model.clippedDateEnd ??
                                    model.currentDateEnd,
                                onScheduleEntryTap: (entry) {
                                  _onScheduleEntryTap(context, entry);
                                },
                                now: model.now,
                                displayEndHour: model.displayEndHour,
                                displayStartHour: model.displayStartHour,
                              ),
                            );
                          },
                        ),
                      ),
                      PropertyChangeConsumer(
                        properties: const ["isUpdating"],
                        builder: (BuildContext context,
                            WeeklyScheduleViewModel? model, Set? _,) {
                          return model!.isUpdating
                              ? const LinearProgressIndicator()
                              : Container();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildErrorDisplay(context)
          ],
        ),
      ),
    );
  }

  Row _buildNavigationButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: _previousWeek,
        ),
        IconButton(
          icon: Icon(Icons.today),
          onPressed: _goToToday,
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _nextWeek,
        ),
      ],
    );
  }

  Widget buildErrorDisplay(BuildContext context) {
    return PropertyChangeConsumer(
      properties: const [
        "updateFailed",
      ],
      builder: (BuildContext context, WeeklyScheduleViewModel? model, Set? _) =>
          ErrorDisplay(
        show: model!.updateFailed,
      ),
    );
  }
}
