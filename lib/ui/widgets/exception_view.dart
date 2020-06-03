import 'package:flutter/material.dart';

import '../../core/models/models.dart';

class ExceptionView extends StatelessWidget {
  /// The exception which occurred.
  final BaseException exception;

  /// Providing a try again callback will create a [RaisedButton] with
  /// text 'Try Again' and an `onPressed` value of `tryAgainCallback`.
  final VoidCallback tryAgainCallback;

  const ExceptionView(this.exception, {this.tryAgainCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Error',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(exception.message, textAlign: TextAlign.center),
        if (tryAgainCallback != null) ...[
          SizedBox(height: 20),
          RaisedButton(child: Text('Try Again'), onPressed: tryAgainCallback),
        ]
      ],
    );
  }
}
