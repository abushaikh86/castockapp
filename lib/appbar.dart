import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_audit/splash_screen.dart';
import 'package:stock_audit/util/constants.dart' as constants;

import 'login.dart';

PreferredSizeWidget appbar(
    BuildContext context, String title, dynamic otherData,
    {Function? onRefresh}) {
  return AppBar(
    leading: BackButton(color: Colors.white),
    title: Text(title, style: TextStyle(color: Colors.white)),
    centerTitle: false,
    actions: <Widget>[
      if (onRefresh != null) // Show only when onRefresh is provided
        PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (String value) async {
            switch (value) {
              case 'Refresh':
                if (onRefresh != null) {
                  onRefresh();
                }
                break;
              case 'Logout':
                await handleLogout(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Refresh', 'Logout'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      if (onRefresh == null) // Always show the Logout option
        PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (String value) async {
            print('Selected option: $value');
            if (value == 'Logout') {
              await handleLogout(context);
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Logout'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
    ],
  );
}

Future<void> handleLogout(BuildContext context) async {
  var sharedPref = await SharedPreferences.getInstance();
  sharedPref.setBool(SplashScreenState.KEYLOGIN, false);
  constants.Notification("Logged Out Successfully");
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Login()),
    (route) => false,
  );
}


// Future<void> handleClick(String value) async {
//   switch (value) {
//     case 'Logout':
//       var sharedPref = await SharedPreferences.getInstance();
//       sharedPref.setBool(SplashScreenState.KEYLOGIN, false);
//       constants.Notification("Logged Out Successfully");
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
//       break;
//   }
// }