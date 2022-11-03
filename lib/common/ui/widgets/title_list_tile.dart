import 'package:flutter/material.dart';

class TitleListTile extends StatelessWidget {
  final String title;

  const TitleListTile({super.key, required this.title});

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
