import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/CardAppointWidget.dart';
import 'package:flutter_project/components/CardPatientShortWidget.dart';
import 'package:flutter_project/components/Notification.dart';
import 'package:flutter_project/screens/doctor/appointment_detail/appointment_detail_screen.dart';
import 'package:flutter_project/screens/doctor/patient_detail/patient_detail_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  String? doctorCode;
  String? doctorId;
  String? prefix;
  String? firstName;
  String? lastName;
  var ptFName = [];
  var ptLName = [];
  var ptList = [];
  var appointment = [];

  DateTime now = DateTime.now();
  late int dateIndex;
  int selectedTime = 0;

  final mockAppointment = [
    {
      "firstName": "รัมภากานต์",
      "lastName": "เพชรทวย",
      "time": "13:00",
      "date": "23/04/2022",
      "id": "1",
    }
  ];

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
        .read(key: 'doctorCode')
        .then((value) => setState(() => doctorCode = value ?? ''));
  }

  Future getPatientList() async {
    storage.read(key: 'doctorId').then((value) async {
      var getPatientList = '${HConstant.apiUrl}/v1/patients-list';
      Dio().get(getPatientList).then((res) {
        if (res.statusCode == 200) {
          for (var data in res.data) {
            var getPatientDetail =
                '${HConstant.apiUrl}/v1/patients/${data['pt_id']}';

            Dio().get(getPatientDetail).then((res2) {
              var getUser =
                  '${HConstant.apiUrl}/v1/users/${res2.data['user_id']}';
              Dio().get(getUser).then((user) {
                // print(user.data);
                setState(() {
                  ptFName.add(user.data['first_name']);
                  ptLName.add(user.data['last_name']);
                });
              });
              setState(() {
                ptList.add(res2.data);
              });
            });
          }

          var getAppointment = '${HConstant.apiUrl}/v1/appointments';

          Dio().get(getAppointment).then((res2) {
            DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss+SSS")
                .parse(res2.data[0]['apmt_datettime']);
            String date = parseDate.toString().split(' ')[0];
            String time =
                DateFormat.Hm().format(parseDate.add(Duration(hours: 7)));

            var getPatient =
                '${HConstant.apiUrl}/v1/patients/${res2.data[0]['pt_id']}';

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

            setState(() {
              appointment = [
                {
                  'pt_id': res2.data[0]['pt_id'],
                  'id': res2.data[0]['apmt_id'],
                  'date': date,
                  'time': time,
                }
              ];
            });
          });
        }
      });
    });
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
        //   MaterialPageRoute(builder: (_) => AppointmentDetailScreen('s')),
        //   (route) => route.isFirst,
        // );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initValue();
    initAwesomeNotify();
    getPatientList();
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
        backgroundColor: HColors.b4,
        elevation: 0,
        // title: Text('Doctor'),
        actions: [
          PopupMenuButton<String>(
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
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: HColors.background,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: HColors.b4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo.jpg',
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$prefix $firstName $lastName',
                                style: GoogleFonts.mitr(
                                  fontSize: 16,
                                  color: HColors.font,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HColors.w2),
                              height: 40,
                              width: size.width * 0.47,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$doctorCode',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: HColors.font,
                                  fontWeight: FontWeight.w600,
                                  //letterSpacing: 2,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HColors.w2,
                              ),
                              height: 40,
                              width: size.width * 0.47,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Patient',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.lato(
                                fontSize: 25,
                                color: HColors.font,
                                fontWeight: FontWeight.w600,
                                //letterSpacing: 2,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                'see all',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: HColors.font,
                                  fontWeight: FontWeight.w600,
                                  //letterSpacing: 2,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  HConstant.routePatientList,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ptList.length > 0 && ptFName.length > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardPatientShortWidget(
                                  size: size,
                                  firstName: ptFName[0],
                                  lastName: ptLName[0],
                                  id: ptList[0]?['pt_code'],
                                  dis: ptList[0]?['pt_disease'],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PatientDetailScreen(
                                                ptList[0]?['pt_id']),
                                      ),
                                    );
                                  },
                                ),
                                ptList.length > 1 && ptFName.length > 1
                                    ? CardPatientShortWidget(
                                        size: size,
                                        firstName: ptFName[0],
                                        lastName: ptLName[0],
                                        id: ptList[1]?['pt_code'],
                                        dis: ptList[1]?['pt_disease'],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PatientDetailScreen(
                                                      ptList[0]?['pt_id']),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(),
                              ],
                            )
                          : CircularProgressIndicator(),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Appointment',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.lato(
                                fontSize: 25,
                                color: HColors.font,
                                fontWeight: FontWeight.w600,
                                //letterSpacing: 2,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                'see all',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: HColors.font,
                                  fontWeight: FontWeight.w600,
                                  //letterSpacing: 2,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  HConstant.routeAppointment,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      appointment.length > 0 && ptFName.length > 0
                          ? CardAppointWidget(
                              size: size,
                              firstName: ptFName[0],
                              lastName: ptLName[0],
                              time: appointment[0]['time'],
                              date: appointment[0]['date'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentDetailScreen(
                                      appointment[0]['pt_id'],
                                      date: appointment[0]['date']!,
                                      time: appointment[0]['time']!,
                                    ),
                                  ),
                                );
                              },
                              onPressed: () async {
                                setTimeModal(context, mockAppointment[0]);
                              },
                            )
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> setTimeModal(
      BuildContext context, Map<String, String> appointment) {
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
                          int.parse(appointment['id']!),
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
