import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onButtonTap;

  const BannerWidget({Key key, this.message, this.buttonText, this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              message,
            ),
            buttonText != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text(buttonText),
                      onPressed: onButtonTap,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
