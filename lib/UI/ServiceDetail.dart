
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../All_Classes.dart';

class ServiceDetail extends StatefulWidget {
  Services service;
  ServiceDetail({required this.service,super.key});

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * 0.36,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width / 10),
                    bottomRight: Radius.circular(size.width / 10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width / 10),
                    bottomRight: Radius.circular(size.width / 10),
                  ),
                  child: Image.network(
                    widget.service.logo,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: size.width / 40),
              Text("${widget.service.serviceName}",
                style: GoogleFonts.play(
                    fontSize: size.width / 12,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black, // Color of the underline
                    decorationStyle: TextDecorationStyle.double, // Style of the underline
                    decorationThickness: 1.0, // Thickness of the underline
                    fontWeight: FontWeight.w900),),
              SizedBox(height: size.width / 20),
              Padding(
                padding: EdgeInsets.only(right: size.width / 20, left:size.width / 20, bottom: size.width / 20 ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Facilities:",
                                style: GoogleFonts.racingSansOne(
                                    fontSize: size.width / 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: size.width / 40),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.wifi),
                                      Text(
                                        "Wifi",
                                        style: GoogleFonts.play(
                                            fontSize: size.width / 34,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.tv),
                                      Text(
                                        "Screen",
                                        style: GoogleFonts.play(
                                            fontSize: size.width / 34,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.local_dining),
                                      Text(
                                        "Food",
                                        style: GoogleFonts.play(
                                            fontSize: size.width / 34,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.ac_unit),
                                      Text(
                                        "AC",
                                        style: GoogleFonts.play(
                                            fontSize: size.width / 34,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Divider(thickness: 1, color: Colors.black),
                      SizedBox(height: size.width / 30),
                      Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Service Details:",
                              style: GoogleFonts.racingSansOne(
                                  fontSize: size.width / 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 40),
                        Column(
                          children: [
                            Text(
                              "Customer Service Number:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${widget.service.headOffice}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Column(
                          children: [
                            Text(
                              "Official Email:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${widget.service.CustomerSerPhoneNo}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),

                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Column(
                          children: [
                            Text(
                              "Head Office:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${widget.service.OfficialEmail}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),

                          ],
                        ),
                      ],),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
