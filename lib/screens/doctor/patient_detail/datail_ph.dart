import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPhScreen extends StatefulWidget {
  DetailPhScreen({Key? key}) : super(key: key);

  @override
  State<DetailPhScreen> createState() => _DetailDxScreenState();
}

class _DetailDxScreenState extends State<DetailPhScreen> {
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
                        'ประวัติการเจ็บป่วยในอดีต',
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
                          rowContent(
                              label: 'การเจ็บป่วย/โรคประจำตัว', data: 'ไม่มี'),
                          rowContent(
                              label: 'การรักษาตัวในโรงพยาบาล', data: 'ไม่เคย'),
                          rowContent(label: 'การได้รับผ่าตัด', data: 'ไม่เคย'),
                          rowContent(
                              label: 'การแพ้ยา/อาหาร/สารต่าง ๆ', data: 'ไม่มี'),
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

  Row rowContent({required String label, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.mitr(
              fontSize: 16,
              color:const Color.fromARGB(255, 103, 103, 105),
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
