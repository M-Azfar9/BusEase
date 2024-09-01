import 'package:bus_ease/UI/Buttons.dart';
import 'package:bus_ease/UI/Login/OtpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../toastmsg.dart';
import 'SignUp.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final _form = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  void Forgot() {
    setState(() {
      isLoading = true;
    });
    auth
        .sendPasswordResetEmail(email: phoneController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
      });
          Utils().toastMsg("We have sent you email to recover password, please check you email", CupertinoColors.activeBlue);
    })
        .onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utils().toastMsg(error.toString(), CupertinoColors.destructiveRed);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF370042)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                // SizedBox(
                //   height: size.height / 12,
                // ),
                Container(
                  height: size.height / 2.7,
                  width: size.width,
                  child: Lottie.asset("assets/animations/forget.json"),
                ),
                // SizedBox(
                //   height: size.height / 100,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:size.width/20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "FORGOT PASSWORD",
                        style: GoogleFonts.orbitron(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: size.width/14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/20),
                  child: Form(
                    key: _form,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.play(
                          fontStyle: FontStyle.italic, color: Colors.white),
                      controller: phoneController,
                      decoration: InputDecoration(
                          hintText: "Enter Email ID",
                          hintStyle: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.white60,
                              fontSize: 18),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white60,
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email ID";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/20),
                  child: RoundButton(
                    title: "Verify Email ID",
                    loading: isLoading,
                    onTap: () {
                      if (_form.currentState!.validate()) {
                        Forgot();
                      }
                    },
                    myColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
