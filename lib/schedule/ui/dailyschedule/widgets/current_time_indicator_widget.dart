import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentTimeIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.orange,
          ),
        )
      ],
    );
  }
}
