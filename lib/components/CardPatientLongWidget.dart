import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPatientLongWidget extends StatelessWidget {
  const CardPatientLongWidget({
    Key? key,
    required this.size,
    this.name,
    this.id,
    this.dis,
    this.onPressed,
  }) : super(key: key);

  final Size size;
  final String? name;
  final String? id;
  final String? dis;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: HColors.b.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      height: 100,
      width: size.width,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.account_circle,
              color: HColors.font,
              size: 45,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? '',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: HColors.font,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'HN: $id',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: HColors.font,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'โรค: $dis',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: HColors.font,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: onPressed,
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
