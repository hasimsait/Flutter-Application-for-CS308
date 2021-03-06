import 'package:flutter/material.dart';
import '../feed.dart';
import '../search.dart';
import '../profile.dart';
import '../notifications.dart';
import '../messages.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  static String userName;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "Feed")
      child = Feed();
    else if (tabItem == "Search")
      child = Search();
    else if (tabItem == "Messages")
      child = Messages();
    else if (tabItem == "Notifications")
      child = Notifications();
    else if (tabItem == "Profile") child = Profile("", parentContext: context);
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
