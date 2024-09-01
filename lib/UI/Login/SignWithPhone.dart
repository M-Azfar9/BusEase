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

class SignPhone extends StatefulWidget {
  const SignPhone({super.key});

  @override
  State<SignPhone> createState() => _SignPhoneState();
}

class _SignPhoneState extends State<SignPhone> {
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
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
                  height: size.height / 2.3,
                  width: size.width,
                  child: Lottie.asset("assets/animations/bus3.json"),
                ),
                // SizedBox(
                //   height: size.height / 100,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SIGN UP WITH PHONE",
                        style: GoogleFonts.orbitron(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: size.width/15,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.play(
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                    controller: phoneController,
                    decoration: InputDecoration(
                        hintText: "+92 ***********",
                        hintStyle: GoogleFonts.play(
                            fontStyle: FontStyle.italic,
                            color: Colors.white60, fontSize: 18),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.white60,
                        )),
                  ),
                ),
                SizedBox(
                  height: size.height / 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/20),
                  child: RoundButton(
                    title: "Verify Phone Number",
                    loading: isLoading,
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      auth.verifyPhoneNumber(
                          phoneNumber: phoneController.text.toString() ,
                          verificationCompleted: (_){
                            setState(() {
                              isLoading = false;
                            });
                          },
                          verificationFailed: (e){
                            setState(() {
                              isLoading = false;
                            });
                            Utils().toastMsg(e.toString(), CupertinoColors.destructiveRed);
                          },
                          codeSent: (String Verification, int? token){
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context)=>Otpscreen(verificationId: Verification))
                          );
                          },
                          codeAutoRetrievalTimeout: (e){
                            setState(() {
                              isLoading = false;
                            });
                            Utils().toastMsg(e.toString(), CupertinoColors.destructiveRed);
                          }).then((value){}).onError((error, stackTrace){});
                    },
                    myColor: CupertinoColors.activeGreen,
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
