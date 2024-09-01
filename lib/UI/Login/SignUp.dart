import 'package:bus_ease/UI/Buttons.dart';
import 'package:bus_ease/UI/toastmsg.dart';
import 'package:bus_ease/fireStore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import '../../main.dart';


class MyUser {
  String id;
  String name;
  String email;

  MyUser(this.id, this.name, this.email);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      map['id'] ?? '',
      map['name'] ?? '',
      map['email'] ?? '',
    );
  }
}


class SignUpcreen extends StatefulWidget {
  const SignUpcreen({super.key});

  @override
  State<SignUpcreen> createState() => _SignUpcreenState();
}

class _SignUpcreenState extends State<SignUpcreen> {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final cnfrmController = TextEditingController();
  bool isPassHide1 = true;
  bool isPassHide2 = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  void SignUp() {
    setState(() {
      isLoading = true;
    });
    auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passController.text.toString())
        .then((value) {
          final id = DateTime.now().millisecondsSinceEpoch;
          MyUser user = MyUser(id.toString(), nameController.text.toString(), emailController.text.toString());
          FirestoreService fs = FirestoreService();
          fs.addUser(user);
          Utils().toastMsg("Sign up as ${emailController.text.toString()}", CupertinoColors.activeGreen);
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: Home(),
                inheritTheme: true,
                ctx: context),
          );
        })
        .onError((error, stackTrace) {
          Utils().toastMsg(error.toString(), CupertinoColors.destructiveRed);
          setState(() {
            isLoading = false;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.black,Color(0xff001811), Color(0xff002019),Color(0xff002920),Color(0xff003328)],
            colors: [Colors.black, Color(0xff31000d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width/20),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 12,
                  ),
                  Container(
                    height: size.height / 4.5,
                    width: size.width,
                    child: Lottie.asset("assets/animations/bus2.json"),
                  ),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SIGN UP",
                        style: GoogleFonts.orbitron(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: size.width/12,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          style: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Enter Full Name",
                              hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white60),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white60,
                              )),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Full Name";
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Enter Email",
                              hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white60),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white60,
                              )),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Email ID";
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height / 35,
                        ),
                        TextFormField(
                          controller: passController,
                          obscureText: isPassHide1,
                          style: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Enter Password",
                              hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white60),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPassHide1 = !isPassHide1;
                                  });
                                },
                                icon: Icon(
                                    isPassHide1
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white),
                              ),
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                color: Colors.white60,
                              )),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter ID Password";
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height / 35,
                        ),
                        TextFormField(
                          controller: cnfrmController,
                          style: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          obscureText: isPassHide2,
                          decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white60),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPassHide2 = !isPassHide2;
                                  });
                                },
                                icon: Icon(
                                  isPassHide2
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.password_sharp,
                                color: Colors.white60,
                              )),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Confirm Password";
                            }else{
                              return null;
                            }

                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: size.height / 35,
                  ),
                  RoundButton(
                    title: "Sign up",
                    loading: isLoading,
                    onTap: () {
                      if (_form.currentState!.validate()) {
                        SignUp();
                      }
                    },
                    myColor: Colors.red.shade600,
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
