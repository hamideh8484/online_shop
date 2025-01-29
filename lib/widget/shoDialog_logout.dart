import 'package:flutter/material.dart';
import 'package:online_shop/screens/login/data/login.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'خروج را تایید کنید',
          textAlign: TextAlign.right,
        ),
        content: Text('آیا مطمئن هستید که می خواهید از سیستم خارج شوید؟',
            textAlign: TextAlign.right),
        actions: <Widget>[
          TextButton(
            child: Text('لغو'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'خروج',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              logout(context);
            },
          ),
        ],
      );
    },
  );
}

void logout(BuildContext context) async {
  await removeToken();
  Navigator.pushReplacementNamed(context, '/login');
}
