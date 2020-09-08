import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/enter_rapla_url_dialog.dart';
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).dividerColor,
                  offset: const Offset(0.0, 1.0),
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    L.of(context).scheduleEmptyStateBannerMessage,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text(
                          L.of(context).scheduleEmptyStateSetUrl.toUpperCase()),
                      onPressed: () async {
                        await EnterRaplaUrlDialog(
                          KiwiContainer().resolve(),
                          KiwiContainer().resolve(),
                        ).show(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Image.asset(image[Theme.of(context).brightness]),
            ),
          ),
        )
      ],
    );
  }
}
