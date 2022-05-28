import 'package:flutter/material.dart';

Future<void> showRedirectDialog(
    BuildContext context, String title, String text, String route) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(route, (route) => false);
              },
              child: Text('OK'),
            )
          ],
        );
      });
}
