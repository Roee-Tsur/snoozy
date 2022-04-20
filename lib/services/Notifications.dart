import 'package:awesome_notifications/awesome_notifications.dart';

import 'Analytics.dart';
import 'Database.dart';

class Notifications {
  static scheduleNotification(int id, String title, String body,
      String sharedItemId, DateTime scheduledDate) {
    Analytics.notificationClicked(
        Database.getItemById(Database.sharesList, sharedItemId).typeToText());
    AwesomeNotifications().createNotification(
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
      content: NotificationContent(
        channelKey: 'snoozy_notifications',
        id: id,
        title: title,
        body: body,
        payload: {'sharedItemId': sharedItemId},
      ),
    );
  }

  static void cancelNotification(int notificationId) =>
      AwesomeNotifications().cancel(notificationId);
}
