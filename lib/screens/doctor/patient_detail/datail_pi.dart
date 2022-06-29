import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPiScreen extends StatefulWidget {
  DetailPiScreen({Key? key}) : super(key: key);

  @override
  State<DetailPiScreen> createState() => _DetailDxScreenState();
}

class _DetailDxScreenState extends State<DetailPiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: HColors.b1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Column(
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
                        'ประวัติการเจ็บป่วยปัจจุบัน',
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
                          columnContent(
                              data:
                                  '     ก่อนมาโรงพยาบาลมีไข้และไอ เข้ารับการรักษาที่คลินิค'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
