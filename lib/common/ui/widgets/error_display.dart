import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final bool show;

  const ErrorDisplay({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: show
              ? Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: double.infinity,
                    color: colorNoConnectionBackground(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                      child: Text(
                        L.of(context).noConnectionMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: colorNoConnectionForeground(),
                            ),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                ),
        ),
      ],
    );
  }
}
