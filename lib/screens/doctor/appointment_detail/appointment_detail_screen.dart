import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/screens/doctor/edit_appointment/edit_appointment_screen.dart';
import 'package:flutter_project/screens/doctor/patient_detail/patient_detail_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AppointmentDetailScreen extends StatefulWidget {
  AppointmentDetailScreen(this.patientId, {Key? key, this.date, this.time})
      : super(key: key);
  final String patientId;
  final String? date;
  final String? time;

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  String? patientCode;
  String? firstName;
  String? lastName;
  String? birthDate;
  double? weight;
  double? height;
  String? bloodType;
  String? disease;
  double? pressure;

  Future getPatientList() async {
    var getPatientDetail =
        '${HConstant.apiUrl}/v1/patients/${widget.patientId}';
    Dio().get(getPatientDetail).then((res) {
      setState(() {
        patientCode = res.data['pt_code'];
        birthDate = res.data['pt_birth_date'];
        weight = res.data['pt_weight'];
        height = res.data['pt_height'];
        bloodType = res.data['pt_blood_type'];
        disease = res.data['pt_disease'];
        pressure = res.data['pt_pressure'];
      });

      var getUser = '${HConstant.apiUrl}/v1/users/${res.data['user_id']}';
      Dio().get(getUser).then((res2) {
        setState(() {
          firstName = res2.data['first_name'];
          lastName = res2.data['last_name'];
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPatientList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'การนัดหมาย',
          style: GoogleFonts.mitr(
            fontSize: 20,
            color: const Color.fromARGB(255, 42, 33, 103),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: HColors.b1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: HColors.b4,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowContent(label: 'วันที่', data: '${widget.date}'),
                  rowContent(label: 'เวลา', data: '${widget.time} น.'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: HColors.b4,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  columnContent(
                      label: 'หมายเลขผู้ป่วย (HN)', data: '$patientCode'),
                  const Divider(),
                  columnContent(
                      label: 'ชื่อ-สกุล', data: '$firstName  $lastName'),
                  const Divider(),
                  columnContent(label: 'โรค', data: '$disease'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailScreen(widget.patientId),
                  ),
                );
              },
              icon: const Icon(
                Icons.personal_injury,
              ),
              label: Text(
                "ข้อมูลผู้ป่วยเพิ่มเติม",
                textAlign: TextAlign.center,
                style: GoogleFonts.mitr(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  primary: HColors.b1,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
            ),
          ],
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   backgroundColor: HColors.b4,
      //   animatedIcon: AnimatedIcons.menu_close,
      //   children: [
      //     SpeedDialChild(
      //       child: const Icon(
      //         Icons.edit,
      //         color: Colors.white,
      //       ),
      //       backgroundColor: HColors.b1,
      //       label: 'แก้ไขวันนัดหมาย',
      //       labelStyle: GoogleFonts.mitr(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w500,
      //         letterSpacing: 1,
      //       ),
      //       labelBackgroundColor: HColors.b4,
      //       onTap: () {
      //         print('edit');
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => EditAppointmentScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget columnContent({required String label, required String data}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.mitr(
              fontSize: 18,
              color: const Color.fromARGB(255, 42, 33, 103),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data,
            style: GoogleFonts.mitr(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Row rowContent({required String label, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.mitr(
              fontSize: 16,
              color: const Color.fromARGB(255, 103, 103, 105),
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            textAlign: TextAlign.right,
            style: GoogleFonts.mitr(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
