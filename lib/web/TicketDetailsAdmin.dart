import 'package:bus_ease/UI/Buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'WebDashBoard.dart';

class LoginWeb extends StatefulWidget {
  const LoginWeb({super.key});

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  bool isHide = true;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF0010FF), Color(0xFF00076D),Color(0xFF000556),Color(0xFF000035),Color(0xFF000016), Colors.black],
            center: Alignment.center,
            radius: 1.2,
          ),
        ),
        child: Center(
          child: Container(
            height: size.height / 1.4,
            width: size.width / 1.7,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(size.height / 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Lottie.asset("assets/animations/bus1.json"),
                            Transform.translate(
                              offset: Offset(
                                  0,
                                  size.height /
                                      4), // Shifts the text 10 pixels downwards
                              child: Text(
                                "BusE@se",
                                style: GoogleFonts.play(
                                  fontSize: size.height / 16,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height / 15),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height / 18),
                  child: Container(
                    width: size.width / 300,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(size.height / 12)),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(size.height / 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LOGIN",
                            style: GoogleFonts.montserratSubrayada(
                              fontSize: size.height / 12,
                              color: Colors.white,
                              // fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: size.height / 20,
                          ),
                          TextFormField(
                            controller: emailCont,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: "Enter Email Id",
                                hintStyle:
                                GoogleFonts.play(
                                  // fontStyle: FontStyle.italic
                                )),
                          ),
                          SizedBox(
                            height: size.height / 24,
                          ),
                          TextFormField(
                            controller: passCont,
                            obscureText: isHide,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: (){
                                  setState(() {
                                    isHide = !isHide;
                                  });
                                }, icon: Icon(isHide? Icons.visibility_off : Icons.visibility)),
                                prefixIcon: Icon(Icons.password),
                                hintText: "Enter Id Password",
                                hintStyle:
                                GoogleFonts.play(
                                  // fontStyle: FontStyle.italic
                                )),
                          ),
                          SizedBox(height: size.height/20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                      height: size.height / 14,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            // backgroundColor: CupertinoColors.destructiveRed,
                                            backgroundColor: Color(0xFFC10000),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(size.height/50), // Set the border radius here
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              emailCont.text = "";
                                              passCont.text = "";
                                            });
                                          },
                                          child: Text("Reset",style: GoogleFonts.play(fontSize: size.height/35, fontWeight: FontWeight.bold,),)))),
                              Center(
                                child: Container(
                                  width: size.width / 50,
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                    height: size.height / 14,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // backgroundColor: CupertinoColors.activeBlue,
                                          backgroundColor:Color(0xFF00009B),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(size.height/50), // Set the border radius here
                                          ),
                                        ),
                                        onPressed: () {
                                          if(emailCont.text.toString() == "admin@gmail.com" && passCont.text.toString() == "admin123"){
                                            Navigator.push(context, MaterialPageRoute(builder: (_)=> WebDashBoard()));
                                          }else{
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Please Enter Correct Email and Password", style: GoogleFonts.play(color: Colors.white ,fontWeight: FontWeight.bold),),
                                                backgroundColor: CupertinoColors.destructiveRed,

                                              ),
                                            );
                                          }
                                        }, child: Text("Login",style: GoogleFonts.play(fontSize: size.height/35, fontWeight: FontWeight.bold))),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
