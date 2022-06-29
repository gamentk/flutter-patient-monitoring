import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/utilities/constant.dart';
import 'package:flutter_project/utilities/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    _passwordCtrl.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HColors.w2, HColors.b3],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Hospital",
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      color: HColors.font,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: size.width * 0.6,
                  child: TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'User :',
                      labelStyle: GoogleFonts.lato(
                        color: HColors.font,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      prefixIcon: const Icon(
                        Icons.account_circle_outlined,
                        color: HColors.font,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: HColors.font),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: HColors.w1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: size.width * 0.6,
                  child: TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password :',
                      labelStyle: GoogleFonts.lato(
                        color: HColors.font,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: HColors.font,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: HColors.font),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: HColors.w1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      String email = _emailCtrl.text;
                      String password = _passwordCtrl.text;
                      checkLogin(email, password);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: HColors.font,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[600]!.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> checkLogin(String email, String password) async {
    String loginUrl = '${HConstant.apiUrl}/v1/users/login';

    Dio().post(loginUrl, data: {'email': email, 'password': password}).then(
        (res) async {
      final user = res.data[0];
      final role = res.data[1];

      print(role);

      await storage.write(key: 'role', value: user['role_nameen']);
      await storage.write(key: 'prefix', value: user['prefix_nameen']);
      await storage.write(key: 'fname', value: user['first_name']);
      await storage.write(key: 'lname', value: user['last_name']);

      if (user['role_nameen'] == 'Doctor') {
        await storage.write(key: 'doctorId', value: role['doctor_id']);
        await storage.write(key: 'doctorCode', value: role['doctor_code']);
        Navigator.pushNamedAndRemoveUntil(
            context, HConstant.routeHome, (route) => false);
      } else if (user['role_nameen'] == 'Patient') {
        await storage.write(key: 'patientId', value: role['pt_id']);
        await storage.write(key: 'patientCode', value: role['pt_code']);
        Navigator.pushNamedAndRemoveUntil(
            context, HConstant.routePatientHome, (route) => false);
      }
    }, onError: (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'เข้าสู่ระบบล้มเหลว',
            textAlign: TextAlign.center,
            style: GoogleFonts.mitr(
              fontSize: 22,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง โปรดลองใหม่อีกครั้ง',
            textAlign: TextAlign.center,
            style: GoogleFonts.mitr(
              fontSize: 20,
            ),
          ),
        ),
      );
    });
  }
}
