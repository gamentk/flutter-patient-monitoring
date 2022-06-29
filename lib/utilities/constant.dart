import 'package:flutter/material.dart';

// สร้างตัวแปร Global ไว้ใช้งานในหน้าต่าง ๆ
class HConstant {
  // General
  static String appName = 'Hospital';
  static Image logo = Image.asset("assets/images/logo.png");
  static Image imageInsert = Image.asset("assets/images/image_icon.png");

  // static String apiUrl = "https://api-pms-dev.herokuapp.com";
  static String apiUrl = "http://10.0.2.2:5000";

  static String routeLogin = '/login';

  // Doctor Route
  static String routeHome = '/doctor/home';
  static String routePatientList = '/doctor/patients';
  static String routeAppointment = '/doctor/appointment';

  // Patient Route
  static String routePatientHome = '/patient/home';
  static String routePatientAppointment = '/patient/appointment';
}

int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}
