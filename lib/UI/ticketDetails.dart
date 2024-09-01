import 'package:bus_ease/All_Classes.dart';
import 'package:bus_ease/UI/Buttons.dart';
import 'package:bus_ease/UI/pdfPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'BusSeats.dart';

class Ticketdetails extends StatefulWidget {
  Bus ticketBus;
  Ticketdetails({required this.ticketBus, super.key});

  @override
  State<Ticketdetails> createState() => _TicketdetailsState();
}

class _TicketdetailsState extends State<Ticketdetails> {
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
                    widget.ticketBus.companyProfile,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width / 20),
                child: RoundButton(
                    title: "Book Now",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BusSeats(bus: widget.ticketBus)));
                    },
                    myColor: CupertinoColors.activeBlue),
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width / 20, left:size.width / 20, bottom: size.width / 20 ),
                child: RoundButton(
                    title: "Remaining Seats:  ${widget.ticketBus.remainingSeats}/${widget.ticketBus.seatingCap}",
                    onTap: () {},
                    myColor: CupertinoColors.destructiveRed),
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width / 20, left:size.width / 20, bottom: size.width / 20 ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
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
                          children: [
                            Text(
                              "Bus Details:",
                              style: GoogleFonts.racingSansOne(
                                  fontSize: size.width / 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 40),
                        Row(
                          children: [
                            Text(
                              "Service:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "${widget.ticketBus.companyName}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Row(
                          children: [
                            Text(
                              "Departure City:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "${widget.ticketBus.depCity}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Row(
                          children: [
                            Text(
                              "Destination City:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "${widget.ticketBus.destCity}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Row(
                          children: [
                            Text(
                              "Departure Date:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "${widget.ticketBus.depDate}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Row(
                          children: [
                            Text(
                              "Departure Time:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "${widget.ticketBus.departureTime}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Row(
                          children: [
                            Text(
                              "Arrival Time:  ",
                              style: GoogleFonts.play(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "(Expected)${widget.ticketBus.arrivalTime}",
                              style: GoogleFonts.play(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width / 200),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bus Stops:  ",
                              style: GoogleFonts.play(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "${widget.ticketBus.stops}",
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
