import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailDxScreen extends StatefulWidget {
  DetailDxScreen({Key? key}) : super(key: key);

  @override
  State<DetailDxScreen> createState() => _DetailDxScreenState();
}

class _DetailDxScreenState extends State<DetailDxScreen> {
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
                        'วินิจฉัยโรค',
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
                              label: 'การวินิจฉัยแรกรับ', data: 'tonsillitis'),
                          rowContent(
                              label: 'การวินิจฉัยครั้งสุดท้าย',
                              data: 'tonsillitis'),
                          rowContent(label: 'ผลการตรวจ X-Ray', data: '-'),
                          rowContent(label: 'ผลการตรวจพิเศษ', data: '-'),
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
