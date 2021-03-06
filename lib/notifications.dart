import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';
import 'helper/constants.dart';
import 'helper/requests.dart';
import 'myNotification.dart';

class Notifications extends StatefulWidget {
  Notifications();
  @override
  State<StatefulWidget> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  _NotificationsState();
  List<MyNotification> notificationList = [];
  final ScrollController _scrollController = ScrollController();
  Timer timer;
  void initState() {
    super.initState();
    _getNotifications();
    const oneSec = const Duration(milliseconds: 500);
    timer = Timer.periodic(oneSec, (Timer t) => _checkUpdates());
  }

  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _getNotifications() {
    notificationList.clear();
    setState(() {});

    Requests().getNotifications().then((value) {
      notificationList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: new Text(
          'Notifications',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              messageList(),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  Widget messageList() {
    return Container(
      child: ListView.builder(
        itemCount: notificationList.length,
        reverse: true,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return row(context, index);
        },
      ),
      height: 620,
      color: Colors.white,
    );
  }

  Widget row(context, index) {
    try {
      if (notificationList != null && notificationList.isNotEmpty)
        return Container(
          child: RaisedButton(
            onPressed: () {
              //go to activity can be here
            },
            padding: EdgeInsets.all(10),
            child: Container(
              width: 500,
              child: Flex(direction: Axis.vertical, children: <Widget>[
                Text(
                  notificationList[index].notificationContent.toString(),
                  style: TextStyle(color: Colors.white),
                )
              ]),
            ),
            color: Colors.blue[700],
          ),
          width: 500,
          alignment: Alignment.centerLeft,
        );
    } catch (e) {
      return SizedBox();
    }
  }

  _checkUpdates() {
    Requests().getNotifications().then((value) {
      if (notificationList == null || notificationList.isEmpty) {
        if (notificationList == null) notificationList = [];
        notificationList = List.from(value);
      }
      if (notificationList.last.notificationDate !=
          value.last.notificationDate) {
        int index = -1;
        for (int i = value.length - 1; i >= 0; i--) {
          if (value[i].notificationDate ==
                  notificationList.last.notificationDate &&
              value[i].notificationContent ==
                  notificationList.last.notificationContent &&
              value[i].notificationFrom ==
                  notificationList.last.notificationFrom) {
            index = i;
            break;
          }
        }
        List<MyNotification> toDisplay = [];
        for (int i = index + 1; i < value.length; i++) {
          toDisplay.add(value[i]);
        }
        notificationList = List.from(value);
        toDisplay.forEach((notif) {
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails('your channel id', 'your channel name',
                  'your channel description',
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: true);
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          flutterLocalNotificationsPlugin.show(0, Constants.appName,
              notif.notificationContent, platformChannelSpecifics,
              payload: 'item x');
        });
      }
      setState(() {});
    });
  }
}
