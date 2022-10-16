import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/app_theme.dart';
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final bool show;

  const ErrorDisplay({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: show
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    color: AppTheme.noConnectionBackground,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                      child: Text(
                        L.of(context).noConnectionMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.noConnectionForeground,
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
