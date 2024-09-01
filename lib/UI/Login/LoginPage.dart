import 'package:bus_ease/UI/Buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../toastmsg.dart';
import 'SignUp.dart';
import 'SignWithPhone.dart';
import 'forgot.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;
  bool isPassHidden = false;
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  Future<void> Login() async {
    setState(() {
      isLoading = true;
    });

    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      if (!mounted) return; // Check if the widget is still mounted
      Utils().toastMsg("Login successful", CupertinoColors.activeGreen);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (error) {
      if (!mounted) return; // Check if the widget is still mounted
      Utils().toastMsg(error.toString(), CupertinoColors.destructiveRed);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.black,Color(0xff001811), Color(0xff002019),Color(0xff002920),Color(0xff003328)],
            colors: [Colors.black, Color(0xff130050)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 12,
                  ),
                  Container(
                    height: size.height / 7,
                    width: size.width,
                    child: Lottie.asset("assets/animations/bus1.json"),
                  ),
                  SizedBox(
                    height: size.height / 16,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SIGN IN",
                        style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.play(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Enter Email",
                                hintStyle:
                                GoogleFonts.play(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white60),
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
                          SizedBox(
                            height: size.height / 35,
                          ),
                          TextFormField(
                            style: GoogleFonts.play(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                            controller: passController,
                            obscureText: !isPassHidden,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              hintStyle:
                              GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white60),
                              suffixIcon: IconButton(
                                icon: Icon(color: Colors.white,
                                  isPassHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPassHidden = !isPassHidden;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                color: Colors.white60,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter ID Password";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: size.height / 35,
                  ),
                  RoundButton(
                    loading: isLoading,
                    title: "Sign in",
                    onTap: () async {
                      if (_form.currentState!.validate()) {
                        await Login();
                      }
                    },
                    myColor: CupertinoColors.activeBlue,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Forgot()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Color(0xff96c2ff)),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.play(
                            fontStyle: FontStyle.italic,
                            color: Colors.white70),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>SignUpcreen()),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Color(0xff969fff)),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: size.height / 35,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>SignPhone())
                      );
                    },
                    child: Container(
                      height: size.height/17,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white70)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign up with ",
                              style: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white70),
                            ),
                            Icon(Icons.phone, color: Colors.white70)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
