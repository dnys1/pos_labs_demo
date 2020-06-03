import 'package:flutter/material.dart';

class PushNotificationsDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const PushNotificationsDialog(this.data);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(data.toString()),
      ),
    );
  }
}
