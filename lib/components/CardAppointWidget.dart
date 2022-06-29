import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CardAppointWidget extends StatelessWidget {
  const CardAppointWidget({
    Key? key,
    required this.size,
    this.firstName,
    this.lastName,
    this.time,
    this.date,
    this.onTap,
    this.onPressed,
  }) : super(key: key);

  final Size size;
  final String? firstName;
  final String? lastName;
  final String? time;
  final String? date;
  final Function()? onTap;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(10),
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
        // height: 100,
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName ?? 'ชื่อ',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    color: HColors.font,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  lastName ?? 'นามสกุล',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    color: HColors.font,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: HColors.b,
                    size: 30,
                  ),
                  onPressed: onPressed,
                ),
                Text(
                  time ?? 'เวลา',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    color: HColors.font,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  date ?? 'วันที่',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    color: HColors.font,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
