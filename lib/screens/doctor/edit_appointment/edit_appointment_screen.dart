import 'package:flutter/material.dart';
import 'package:flutter_project/screens/doctor/appointment_detail/appointment_detail_screen.dart';
import 'package:flutter_project/screens/doctor/patient_detail/patient_detail_screen.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAppointmentScreen extends StatefulWidget {
  EditAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  DateTime date = DateTime(2022, 06, 09);
  TimeOfDay time = TimeOfDay(hour: 24, minute: 59);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'แก้ไขการนัดหมาย',
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
                  columnContent(
                      label: 'หมายเลขผู้ป่วย (HN)', data: '161404140022'),
                  const Divider(),
                  columnContent(
                      label: 'ชื่อ-สกุล', data: 'นางสาวรัมภากานต์  เพชรทอง'),
                  const Divider(),
                  columnContent(label: 'โรค', data: 'ขาดสารอาหาร'),
                  const Divider(),
                  columnContent(
                      label: 'แพทย์ผู้ดูแล', data: 'นายแพทย์นะดา  เฉมเร๊ะ'),
                ],
              ),
            ),
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
                  rowContent(
                    label: 'ห้องตรวจ   ',
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'ห้องตรวจ',
                          hintStyle: GoogleFonts.mitr(
                            fontSize: 16,
                            color: HColors.font,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: HColors.w1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: HColors.font),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  rowContent(
                    label: 'วันที่นัดหมาย',
                    child: InkWell(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100),
                        );

                        print(newDate);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: GoogleFonts.mitr(
                            fontSize: 16,
                            color: HColors.font,
                          ),
                        ),
                      ),
                    ),
                  ),
                  rowContent(
                    label: 'เวลานัดหมาย',
                    child: InkWell(
                      onTap: () => timePicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${time.hour}:${time.minute} น.',
                          // getTime() == null ? 'ตั้งเวลาปลุก' : getTime()!,
                          style: GoogleFonts.mitr(
                            fontSize: 16,
                            color: HColors.font,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     print("submit change");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => AppointmentDetailScreen(),
            //       ),
            //     );
            //   },
            //   icon: const Icon(Icons.edit),
            //   label: Text(
            //     "บันทึกการแก้ไข",
            //     textAlign: TextAlign.center,
            //     style: GoogleFonts.mitr(
            //       fontSize: 18,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     primary: HColors.g2,
            //     elevation: 5,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30.0)),
            //   ),
            // ),
          ],
        ),
      ),
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

  Widget rowContent({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.mitr(
              fontSize: 18,
              color: const Color.fromARGB(255, 42, 33, 103),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(child: child)
        ],
      ),
    );
  }

  Future timePicker(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 0, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: initialTime,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: childWidget!,
        );
      },
    );

    // if (newTime == null) return;

    // setState(() => timeSelect = newTime);
  }
}
