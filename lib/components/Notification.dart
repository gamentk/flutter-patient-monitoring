import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_project/utilities/constant.dart';

Future<void> createAppointmentNotification(
  DateTime notificationSchedule,
  int id,
  String title,
  String time,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'scheduled_channel',
      largeIcon: 'resource://drawable/logo',
      title: '${Emojis.building_hospital} การนัดหมาย : $title',
      body: 'เวลา : $time',
      summary: 'อันนี้คืออะไร?',
      notificationLayout: NotificationLayout.BigText,
      locked: true,
    ),
    actionButtons: [
      NotificationActionButton(key: 'MARK_DONE', label: 'OK'),
    ],
    schedule: NotificationCalendar(
      year: notificationSchedule.year,
      month: notificationSchedule.month,
      weekday: notificationSchedule.weekday,
      hour: notificationSchedule.hour,
      minute: notificationSchedule.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}

Future<void> cancelAllNotification() async {
  await AwesomeNotifications().cancelAllSchedules();
}

Future<void> cancelNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}
