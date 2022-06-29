import 'package:flutter/material.dart';
import 'package:flutter_project/screens/doctor/patient_detail/patient_detail_screen.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAppointmentScreen extends StatefulWidget {
  AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'เพิ่มการนัดหมาย',
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
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
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
                  Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      'หมายเลขผู้ป่วย (HN)',
                      style: GoogleFonts.mitr(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 42, 33, 103),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'หมายเลขผู้ป่วย (HN)',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.w1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.font),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      'ชื่อ-สกุล',
                      style: GoogleFonts.mitr(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 42, 33, 103),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'ชื่อ-สกุล',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.w1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.font),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      'โรค',
                      style: GoogleFonts.mitr(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 42, 33, 103),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'โรค',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.w1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.font),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      'ห้องตรวจ',
                      style: GoogleFonts.mitr(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 42, 33, 103),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'ห้องตรวจ',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.w1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HColors.font),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailScreen('1'),
                  ),
                );
              },
              icon: const Icon(Icons.save_alt),
              label: Text(
                "บันทึก",
                textAlign: TextAlign.center,
                style: GoogleFonts.mitr(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  primary: HColors.g2,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
            ),
          ],
        ),
      ),
    );
  }

  Column columnContent({required String data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data,
          style: GoogleFonts.mitr(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
