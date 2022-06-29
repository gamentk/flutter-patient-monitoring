import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/CardAppointWidget.dart';
import 'package:flutter_project/components/Notification.dart';
import 'package:flutter_project/screens/doctor/appointment_detail/appointment_detail_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppointmentListScreen extends StatefulWidget {
  AppointmentListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final storage = const FlutterSecureStorage();

  DateTime now = DateTime.now();
  int selectedTime = 0;
  var ptFName = [];
  var ptLName = [];
  var apptList = [];

  // ข้อมูลจำลอง
  final mockAppointment = [
    {
      "firstName": "รัมภากานต์",
      "lastName": "เพชรทวย",
      "time": "13:00",
      "date": "23/04/2022",
      "id": "1",
    },
    {
      "firstName": "รัมภากานต์",
      "lastName": "เพชรทวย",
      "time": "13:00",
      "date": "24/04/2022",
      "id": "2",
    },
    {
      "firstName": "รัมภากานต์",
      "lastName": "เพชรทวย",
      "time": "13:00",
      "date": "25/04/2022",
      "id": "3",
    },
  ];

  Future getPatientList() async {
    storage.read(key: 'doctorId').then((value) async {
      var getPatientList = '${HConstant.apiUrl}/v1/patients-list';
      Dio().get(getPatientList).then((res) {
        if (res.statusCode == 200) {
          for (var data in res.data) {
            var getAppointment = '${HConstant.apiUrl}/v1/appointments';

            Dio().get(getAppointment).then((res2) {
              for (var appt in res2.data) {
                DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss+SSS")
                    .parse(appt['apmt_datettime']);
                String date = parseDate.toString().split(' ')[0];
                String time =
                    DateFormat.Hm().format(parseDate.add(Duration(hours: 7)));

                var getPatient =
                    '${HConstant.apiUrl}/v1/patients/${appt['pt_id']}';

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
                    'pt_id': appt['pt_id'],
                    'id': appt['apmt_id'],
                    'date': date,
                    'time': time,
                  });

                  // print(apptList);
                });
              }
            });
          }
        }
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

  @override
  void initState() {
    super.initState();
    getPatientList();

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
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment List',
          textAlign: TextAlign.start,
          style: GoogleFonts.lato(
            fontSize: 25,
            color: HColors.font,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: HColors.b1,
      ),
      body: apptList.length > 0
          ? ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
              itemCount: ptFName.length,
              itemBuilder: (context, index) {
                return CardAppointWidget(
                  size: size,
                  firstName: ptFName[index],
                  lastName: ptLName[index],
                  time: apptList[index]['time'],
                  date: apptList[index]['date'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailScreen(
                          apptList[index]['pt_id']!,
                          date: apptList[index]['date']!,
                          time: apptList[index]['time']!,
                        ),
                      ),
                    );
                  },
                  onPressed: () async {
                    setTimeModal(context, apptList[index], index);
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green[600],
      //   child: const Icon(
      //     Icons.add,
      //     size: 50,
      //   ),
      //   onPressed: () {
      //     print('add appointment');
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddAppointmentScreen(),
      //       ),
      //     );
      //   },
      // ),
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

                        // DateTime date = DateFormat('dd-MM-yyyy')
                        //     .parse(appointment['date']!);

                        String day = appointment['date']!.split('/')[0];
                        String month = appointment['date']!.split('/')[1];
                        String year = appointment['date']!.split('/')[2];

                        int defHour =
                            int.parse(appointment['time']!.split(':')[0]);

                        int defMinute =
                            int.parse(appointment['time']!.split(':')[1]);

                        int setTime = defMinute - value!;

                        DateTime scheduleTime = DateTime(
                          int.parse(year),
                          int.parse(month),
                          int.parse(day),
                          defHour,
                          setTime,
                        );

                        var displaySchedule =
                            DateFormat('dd-MM-yyyy HH:mm').format(scheduleTime);

                        createAppointmentNotification(
                          scheduleTime,
                          index,
                          // int.parse(appointment['id']!),
                          "นัดหมายตรวจคนไข้",
                          appointment['time']!,
                        ).then(
                          (_) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'การนัดหมายกับคนไข้ จะแจ้งเตือนในวันที่ $displaySchedule น.',
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
