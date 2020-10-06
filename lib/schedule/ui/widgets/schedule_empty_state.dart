import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/select_source_dialog.dart';
import 'package:dhbwstudentapp/ui/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ScheduleEmptyState extends StatelessWidget {
  final Map<Brightness, String> image = {
    Brightness.dark: "assets/schedule_empty_state_dark.png",
    Brightness.light: "assets/schedule_empty_state.png",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: BannerWidget(
            message: L.of(context).scheduleEmptyStateBannerMessage,
            onButtonTap: () async {
              await SelectSourceDialog(
                KiwiContainer().resolve(),
                KiwiContainer().resolve(),
              ).show(context);
            },
            buttonText: L.of(context).scheduleEmptyStateSetUrl.toUpperCase(),
          ),
        ),
        Expanded(
          child: ClipRRect(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Image.asset(image[Theme.of(context).brightness]),
            ),
          ),
        )
      ],
    );
  }
}
