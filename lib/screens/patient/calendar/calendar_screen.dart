import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/Notification.dart';
import 'package:flutter_project/screens/doctor/appointment_detail/appointment_detail_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final storage = const FlutterSecureStorage();
  String? patientCode;
  String? prefix;
  String? firstName;
  String? lastName;
  var ptFName = [];
  var ptLName = [];
  var apptList = [];
  var todayAppt = [];

  DateTime now = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  late int dateIndex;
  int selectedTime = 0;

  Future getPatientList() async {
    storage.read(key: 'patientId').then((value) async {
      var getAppointment =
          '${HConstant.apiUrl}/v1/appointments/patients/$value';

      Dio().get(getAppointment).then((res2) {
        for (var appt in res2.data) {
          DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss+SSS")
              .parse(appt['apmt_datettime']);
          String date = parseDate.toString().split(' ')[0];
          String time =
              DateFormat.Hm().format(parseDate.add(Duration(hours: 7)));

          var getPatient = '${HConstant.apiUrl}/v1/patients/${appt['pt_id']}';

          Dio().get(getPatient).then((res3) {
            var getUserId =
                '${HConstant.apiUrl}/v1/users/${res3.data['user_id']}';
            Dio().get(getUserId).then((user) {
              setState(() {
                ptFName.add(user.data['first_name']);
                ptLName.add(user.data['last_name']);
              });
            });
          });
          // print(appt);
          setState(() {
            apptList.add({
              'date': date,
              'pt_id': appt['pt_id'],
              'id': appt['apmt_id'],
              'time': time,
            });
          });
        }

        setState(() {
          todayAppt = apptList
              .where((e) => e['date'] == _selectedDate.toString().split(' ')[0])
              .toList();
        });
      });
    });
  }

  static const List<Map<String, dynamic>> periodList = [
    {"label": "5 นาที", "value": 5},
    {"label": "10 นาที", "value": 10},
    {"label": "15 นาที", "value": 15},
    {"label": "30 นาที", "value": 30},
    {"label": "1 ชั่วโมง", "value": 60},
    {"label": "2 ชั่วโมง", "value": 120},
    {"label": "1 วัน", "value": 1440},
  ];

  void initValue() async {
    storage
        .read(key: 'prefix')
        .then((value) => setState(() => prefix = value ?? ''));

    storage
        .read(key: 'fname')
        .then((value) => setState(() => firstName = value ?? ''));

    storage
        .read(key: 'lname')
        .then((value) => setState(() => lastName = value ?? ''));

    storage
        .read(key: 'patientCode')
        .then((value) => setState(() => patientCode = value ?? ''));
  }

  void initAwesomeNotify() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notification'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HColors.font,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: Text(
                  'Allow',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HColors.b4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      AwesomeNotifications().createdStream.listen((noti) {
        // print(noti.id);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('ตั้งแจ้งเตือน ${noti.title} เรียบร้อย')));
      });

      AwesomeNotifications().actionStream.listen((noti) {
        if (noti.channelKey == 'scheduled_channel' && Platform.isIOS) {
          AwesomeNotifications().getGlobalBadgeCounter().then(
                (value) =>
                    AwesomeNotifications().setGlobalBadgeCounter(value - 1),
              );
        }

        // จำลองหน้าวันนัด
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (_) => AppointmentDetailScreen()),
        //   (route) => route.isFirst,
        // );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    dateIndex = 0;
    initValue();
    getPatientList();
    initAwesomeNotify();
  }

  @override
  void dispose() {
    dateIndex = 0;
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix $firstName $lastName',
                  style: GoogleFonts.mitr(
                    fontSize: 14,
                    color: HColors.font,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'HN: $patientCode',
                  style: GoogleFonts.mitr(
                    fontSize: 14,
                    color: HColors.font,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.account_circle,
                size: 50,
                color: HColors.b,
              ),
              onSelected: (value) {
                if (value == 'Logout') {
                  storage.deleteAll();
                  Navigator.pushNamedAndRemoveUntil(
                      context, HConstant.routeLogin, (route) => false);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    textStyle: GoogleFonts.mitr(
                      fontSize: 18,
                      color: HColors.font,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(choice),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: HColors.b1,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(now),
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: HColors.font,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Today",
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 42, 33, 103),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: HColors.b,
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: HColors.font),
              dayTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HColors.font),
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HColors.font),
              ),
              onDateChange: (dateTime) {
                _selectedDate = dateTime;
                var date = dateTime.toString().split(' ')[0];

                setState(() {
                  todayAppt = apptList.where((e) => e['date'] == date).toList();
                  print(todayAppt);
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          todayAppt.length > 0
              ? Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30.0),
                    itemCount: todayAppt.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HColors.b,
                        ),
                        height: 100,
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.white,
                                size: 45,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todayAppt[index]['title'] ?? 'การนัดหมาย',
                                    style: GoogleFonts.mitr(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'วันที่: ' + todayAppt[index]['date']!,
                                    style: GoogleFonts.mitr(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'เวลา : ' + todayAppt[index]['time']! + ' น.',
                                    style: GoogleFonts.mitr(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    setTimeModal(context, todayAppt[index],
                                        _selectedDate.day + index);
                                  },
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Column(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.calendar_month,
                        size: 150,
                        color: HColors.b,
                      ),
                    ),
                    Text(
                      'ไม่มีการนัดหมาย',
                      style: GoogleFonts.mitr(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future<dynamic> setTimeModal(
    BuildContext context,
    Map<String, dynamic> appointment,
    int index,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(
            'ตั้งเวลาล่วงหน้า :',
            style: GoogleFonts.mitr(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          Column(
            children: [
              ...periodList
                  .map(
                    (list) => RadioListTile<int>(
                      value: list['value'],
                      groupValue: selectedTime,
                      onChanged: (value) {
                        setState(() => selectedTime = value!);

                        int defHour =
                            int.parse(appointment['time']!.split(':')[0]);

                        int defMinute =
                            int.parse(appointment['time']!.split(':')[1]);

                        int setTime = defMinute - value!;

                        DateTime scheduleTime = DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          defHour,
                          setTime,
                        );

                        var displaySchedule =
                            DateFormat('dd-MM-yyyy HH:mm').format(scheduleTime);
                        print('here -> $displaySchedule');

                        createAppointmentNotification(
                          scheduleTime,
                          index,
                          // int.parse(appointment['id']!),
                          '',
                          appointment['time']!,
                        ).then(
                          (_) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'การนัดหมายจะแจ้งเตือนในวันที่ $displaySchedule น.',
                                style: GoogleFonts.mitr(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      title: Text(
                        list['label'],
                        style: GoogleFonts.mitr(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}
