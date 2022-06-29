import 'package:flutter/material.dart';
import 'package:flutter_project/components/CardAppointWidget.dart';
import 'package:flutter_project/components/CardPatientShortWidget.dart';
import 'package:flutter_project/screens/doctor/appointment_detail/appointment_detail_screen.dart';
import 'package:flutter_project/screens/doctor/patient_detail/patient_detail_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePatientScreen extends StatefulWidget {
  HomePatientScreen({Key? key}) : super(key: key);

  @override
  State<HomePatientScreen> createState() => _HomePatientScreen();
}

class _HomePatientScreen extends State<HomePatientScreen> {
  final mockAppointment = [
    {
      "firstName": "รัมภากานต์",
      "lastName": "เพชรทวย",
      "time": "13:00",
      "date": "15/05/2022",
    }
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text('patient'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => {
              if (value == 'Logout')
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HConstant.routeLogin, (route) => false)
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
                          'assets/images/logohospital.png',
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HColors.w1),
                              height: 40,
                              width: size.width * 0.47,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HColors.w1,
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
                              'แพทย์ผู้ดูแล',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.mitr(
                                fontSize: 25,
                                color: HColors.font,
                                fontWeight: FontWeight.w400,
                                //letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'นายแพทย์นะดา เฉมเร๊ะ',
                              style: GoogleFonts.mitr(
                                fontSize: 16,
                                color: HColors.font,
                                fontWeight: FontWeight.w400,
                                //letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('รหัส 161404140022',
                            style: GoogleFonts.mitr(
                                fontSize: 16,
                                color: HColors.font,
                                fontWeight: FontWeight.w400,
                                //letterSpacing: 2,
                              ),),
                            SizedBox(height: 10),
                            Text('ตำแหน่ง ศัลยแพทย์',
                            style: GoogleFonts.mitr(
                                fontSize: 16,
                                color: HColors.font,
                                fontWeight: FontWeight.w400,
                                //letterSpacing: 2,
                              ),),
                          ],
                        ),
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HColors.w1,
                          boxShadow: [
                            BoxShadow(
                              color: HColors.b.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
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
                                  HConstant.routePatientAppointment
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      CardAppointWidget(
                        size: size,
                        firstName: mockAppointment[0]['firstName'],
                        lastName: mockAppointment[0]['lastName'],
                        time: mockAppointment[0]['time'],
                        date: mockAppointment[0]['date'],
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AppointmentDetailScreen(),
                        //     ),
                        //   );
                        // },
                      ),
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
}
