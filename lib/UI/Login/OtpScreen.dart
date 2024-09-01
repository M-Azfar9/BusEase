import 'package:bus_ease/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../toastmsg.dart';

class Otpscreen extends StatefulWidget {
  final String verificationId;
  const Otpscreen({super.key, required this.verificationId});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xff033100)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width/20),
            child: Column(
              children: [
                Container(
                  height: size.height / 4.5,
                  width: size.width,
                  child: Lottie.asset("assets/animations/phone.json"),
                ),
                SizedBox(height: size.height / 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "VERIFICATION CODE",
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: size.width/12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "We texted you a code, please enter it below;",
                    style: GoogleFonts.play(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: size.height / 30),
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: Color(0xffff0000),
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {
                    // Handle validation or checks here if necessary
                  },
                  onSubmit: (String verificationCode) async {
                    final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verificationCode.toString(),
                    );
                    try {
                      await auth.signInWithCredential(credential);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    } catch (e) {
                      Utils().toastMsg(e.toString(), CupertinoColors.activeGreen);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
