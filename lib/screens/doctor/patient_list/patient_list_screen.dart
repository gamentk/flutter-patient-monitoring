import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/CardPatientLongWidget.dart';
import 'package:flutter_project/screens/doctor/patient_detail/patient_detail_screen.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientListScreen extends StatefulWidget {
  PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final storage = const FlutterSecureStorage();
  var ptName = [];
  var ptList = [];

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
                setState(() {
                  var pt =
                      user.data['first_name'] + ' ' + user.data['last_name'];
                  ptName.add(pt);
                });
              });
              setState(() {
                ptList.add(res2.data);
              });
            });
          }
        }
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient List',
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
      body: ptName.length > 0
          ? ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
              itemCount: ptName.length,
              itemBuilder: (context, index) {
                return CardPatientLongWidget(
                  size: size,
                  name: ptName[index],
                  id: ptList[index]['pt_code'],
                  dis: ptList[index]['pt_disease'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailScreen(ptList[index]['pt_id']!),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
