import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/screens/doctor/appointment_list/appointment_list_screen.dart';
import 'package:flutter_project/screens/doctor/home/home_screen.dart';
import 'package:flutter_project/screens/login/login_screen.dart';
import 'package:flutter_project/screens/doctor/patient_list/patient_list_screen.dart';
import 'package:flutter_project/screens/patient/calendar/calendar_screen.dart';
import 'package:flutter_project/screens/patient/home/home_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ส่วน Map path กับหน้าแอปพลิเคชัน
final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => LoginScreen(),
  '/doctor/home': (BuildContext context) => HomeScreen(),
  '/doctor/patients': (BuildContext context) => PatientListScreen(),
  '/doctor/appointment': (BuildContext context) => AppointmentListScreen(),
  '/patient/home': (BuildContext context) => CalendarScreen(),
};

String? initialRoute;

Future<Null> main() async {
  AwesomeNotifications().initialize('resource://drawable/logo', [
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      defaultColor: HColors.b1,
      importance: NotificationImportance.High,
      locked: true,
      channelShowBadge: true,
    )
  ]);

  const storage = FlutterSecureStorage();
  String? role = await storage.read(key: 'role');

  if (role?.isEmpty ?? true) {
    initialRoute = HConstant.routeLogin;
  } else {
    if (role == 'Doctor') {
      initialRoute = HConstant.routeHome;
    } else if (role == 'Patient') {
      initialRoute = HConstant.routePatientHome;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(
        scaffoldBackgroundColor: HColors.background,
        primaryColor: HColors.green,
      ),
    );
  }
}
