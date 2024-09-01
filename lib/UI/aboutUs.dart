
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../All_Classes.dart';

class AboutUs extends StatefulWidget {
  AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.34,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width / 10),
                    bottomRight: Radius.circular(size.width / 10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/animations/busSp1.json", height: size.height/3),
                  ],
                ),
              ),
              SizedBox(height: size.width / 40),
              Text(
                "BusE@se",
                style: GoogleFonts.play(
                    fontStyle: FontStyle.italic,
                    fontSize: size.width/10,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                  decorationColor: CupertinoColors.activeBlue, // Color of the underline
                  decorationThickness: 1.0,
                ),
              ),
              // SizedBox(height: size.width / 100),
              Padding(
                padding: EdgeInsets.all(size.width/16),
                child: Text("BusEase is a cutting-edge bus ticket reservation system designed to simplify and enhance the travel experience for passengers. With BusEase, users can easily browse, book, and manage their bus tickets through an intuitive and user-friendly interface. The platform ensures seamless bookings, secure payment processing, and real-time updates, making travel planning effortless. Whether you're managing bus services as an admin or booking your next trip as a passenger, BusEase is your go-to solution for efficient and reliable bus travel.",
                  style: GoogleFonts.play(
                      fontSize: size.width / 24,
                      fontStyle: FontStyle.italic,
                  ),),
              ),
              SizedBox(height: size.width / 20),
            ],
          ),
        ),
      ),
    );
  }
}
