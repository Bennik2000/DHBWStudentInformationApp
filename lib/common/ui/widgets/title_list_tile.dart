import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleListTile extends StatelessWidget {
  final String title;

  const TitleListTile({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}
