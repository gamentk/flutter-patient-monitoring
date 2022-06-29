import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/screens/doctor/patient_detail/datail_ph.dart';
import 'package:flutter_project/screens/doctor/patient_detail/datail_pi.dart';
import 'package:flutter_project/screens/doctor/patient_detail/datail_pmh.dart';
import 'package:flutter_project/screens/doctor/patient_detail/detail_cc.dart';
import 'package:flutter_project/screens/doctor/patient_detail/detail_dx.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PatientDetailScreen extends StatefulWidget {
  PatientDetailScreen(this.patientId, {Key? key}) : super(key: key);
  final String patientId;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  String? patientCode;
  String? firstName;
  String? lastName;
  String? birthDate;
  double? weight;
  double? height;
  String? bloodType;
  String? disease;
  double? pressure;

  var levels = [];

  Future getPatientList() async {
    String getPatientDetail =
        '${HConstant.apiUrl}/v1/patients/${widget.patientId}';
    String getLogs = '${HConstant.apiUrl}/v1/estimate-log';

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
        // print(res2.data);
        setState(() {
          firstName = res2.data['first_name'];
          lastName = res2.data['last_name'];
        });
      });
    });

    Dio().get(getLogs).then((res) {
      setState(() {
        for (var level in res.data) {
          levels.add(level['log_level']);
        }
      });
    });
  }

  @override
  void initState() {
    if (mounted) {
      setState(() => firstName = '');
    }

    super.initState();
    getPatientList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ข้อมูลผู้ป่วย',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: firstName != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: HColors.b.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'ข้อมูลส่วนตัว',
                              style: GoogleFonts.mitr(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 42, 33, 103),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                            child: Column(
                              children: [
                                rowContent(label: 'HN', data: '$patientCode'),
                                rowContent(
                                    label: 'ชื่อ',
                                    data: '$firstName $lastName'),
                                rowContent(
                                    label: 'วันเกิด', data: '$birthDate'),
                                // rowContent(label: 'เพศ', data: 'หญิง'),
                                rowContent(
                                    label: 'น้ำหนัก', data: '$weight kg'),
                                rowContent(
                                    label: 'ส่วนสูง', data: '$height cm'),
                                rowContent(
                                    label: 'กรุ้ปเลือด', data: '$bloodType'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: HColors.b.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'ข้อมูลความเจ็บป่วย',
                              style: GoogleFonts.mitr(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 42, 33, 103),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                            child: Column(
                              children: [
                                rowContent(label: 'โรค', data: '$disease'),
                                rowContent(label: 'ความดัน', data: '$pressure'),
                                // const Padding(
                                //   padding: EdgeInsets.symmetric(vertical: 4),
                                //   child: Divider(),
                                // ),
                                // rowContent(
                                //     label: 'วันที่รับไว้ในโรงพยาบาล',
                                //     data: '02 มี.ค. 2020'),
                                // rowContent(
                                //     label: 'วันที่พ้นความดูแล',
                                //     data: '02 เม.ย. 2020'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: HColors.b.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'ประวัติการรักษา',
                              style: GoogleFonts.mitr(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 42, 33, 103),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                            child: Column(
                              children: [
                                for (var level in levels)
                                  rowContent(label: 'ระดับ', data: '$level')
                                // const Padding(
                                //   padding: EdgeInsets.symmetric(vertical: 4),
                                //   child: Divider(),
                                // ),
                                // rowContent(
                                //     label: 'วันที่รับไว้ในโรงพยาบาล',
                                //     data: '02 มี.ค. 2020'),
                                // rowContent(
                                //     label: 'วันที่พ้นความดูแล',
                                //     data: '02 เม.ย. 2020'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   backgroundColor: HColors.font,
      //   children: [
      //     SpeedDialChild(
      //       child: const Icon(Icons.insert_drive_file_outlined),
      //       backgroundColor: HColors.b4,
      //       label: 'Dx',
      //       labelStyle: GoogleFonts.mitr(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w500,
      //         letterSpacing: 1,
      //       ),
      //       labelBackgroundColor: HColors.b4,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => DetailDxScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: const Icon(Icons.insert_drive_file),
      //       backgroundColor: HColors.b4,
      //       label: 'CC',
      //       labelStyle: GoogleFonts.mitr(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w500,
      //         letterSpacing: 1,
      //       ),
      //       labelBackgroundColor: HColors.b4,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => DetailCcScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: const Icon(Icons.personal_injury_outlined),
      //       backgroundColor: HColors.b4,
      //       label: 'PI',
      //       labelStyle: GoogleFonts.mitr(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w500,
      //         letterSpacing: 1,
      //       ),
      //       labelBackgroundColor: HColors.b4,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => DetailPiScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: const Icon(Icons.history_rounded),
      //       backgroundColor: HColors.b4,
      //       label: 'PH',
      //       labelStyle: GoogleFonts.mitr(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w500,
      //         letterSpacing: 1,
      //       ),
      //       labelBackgroundColor: HColors.b4,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => DetailPhScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: const Icon(Icons.assignment),
      //       backgroundColor: HColors.b4,
      //       label: 'PMH',
      //       labelStyle: GoogleFonts.mitr(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w500,
      //         letterSpacing: 1,
      //       ),
      //       labelBackgroundColor: HColors.b4,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => DetailPmhScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
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
