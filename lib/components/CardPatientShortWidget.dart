import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPatientShortWidget extends StatelessWidget {
  const CardPatientShortWidget({
    Key? key,
    required this.size,
    this.firstName,
    this.lastName,
    this.id,
    this.dis,
    this.onTap,
  }) : super(key: key);

  final Size size;
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? dis;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
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
        height: 150,
        width: size.width * 0.40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HN: $id',
              style: GoogleFonts.kanit(
                fontSize: 13,
                color: HColors.font,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              firstName ?? 'ชื่อ',
              style: GoogleFonts.kanit(
                fontSize: 15,
                color: HColors.font,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              lastName ?? 'นามสกุล',
              style: GoogleFonts.kanit(
                fontSize: 15,
                color: HColors.font,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'โรค: $dis',
              style: GoogleFonts.kanit(
                fontSize: 15,
                color: HColors.font,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
