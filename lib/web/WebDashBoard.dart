import 'package:bus_ease/web/busPassenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Add_Drivers.dart';
import 'Add_Location.dart';
import 'Add_Service.dart';
import 'Add_bus_tickets.dart';
import 'TicketDetailsAdmin.dart';

class MyList extends StatefulWidget {
  final String txt;
  final VoidCallback tap;
  final bool isSelected;

  MyList(this.txt, this.tap, this.isSelected);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (event) => setState(() {
        _hovering = true;
      }),
      onExit: (event) => setState(() {
        _hovering = false;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected
              ? CupertinoColors.activeBlue
              : _hovering
              ? CupertinoColors.activeBlue.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(size.height / 20),
            bottomRight: Radius.circular(size.height / 20),
          ),
        ),
        child: ListTile(
          title: Text(
            widget.txt,
            style: GoogleFonts.play(fontStyle: FontStyle.italic, fontSize: widget.isSelected? size.height/32: size.height/38, fontWeight: _hovering? FontWeight.w800: FontWeight.w200),
          ),
          onTap: widget.tap,
        ),
      ),
    );
  }
}

class WebDashBoard extends StatefulWidget {
  const WebDashBoard({super.key});

  @override
  State<WebDashBoard> createState() => _WebDashBoardState();
}

class _WebDashBoardState extends State<WebDashBoard> {
  Widget selectedWidget = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Lottie.asset("assets/animations/bus1.json"),
      Text("Welcome to BusE@se", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.w900,fontSize: 30),),
      Text("Admin Dashboard :)", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.w900,fontSize: 30),),
    ],
  );
  int selectedIndex = -1; // To keep track of the selected index
  bool status8 = false;
  bool isSwitchOn = false;

  Widget SideBar(double h, double w) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(size.height / 10),
            ),
            gradient: LinearGradient(
              colors: [Color(0xFF00009B), CupertinoColors.activeBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.person_sharp,
              size: size.height / 6,
            ),
          ), Text("Admin Dashboard", style: GoogleFonts.play(fontStyle: FontStyle.italic),)
            ],
          ),
        ),
        MyList("Create Bus Tickets", () {
          setState(() {
            selectedWidget = AddBusTickets();
            selectedIndex = 0;
          });
        }, selectedIndex == 0),
        MyList("Bus Ticket Details", () {
          setState(() {
            selectedWidget = BusPassenger();
            selectedIndex = 1;
          });
        }, selectedIndex == 1),
        MyList("Bus Terminals", () {
          setState(() {
            selectedWidget = AddLocations();
            selectedIndex = 2;
          });
        }, selectedIndex == 2),
        MyList("Drivers Details", () {
          setState(() {
            selectedIndex = 3;
            selectedWidget = AddDrivers();
          });
        }, selectedIndex == 3),
        MyList("Bus Services", () {
          setState(() {
            selectedWidget = AddService();
            selectedIndex = 5;
          });
        }, selectedIndex == 5),
        MyList("Logout", () {
          setState(() {
            selectedIndex = 6;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginWeb()));
        }, selectedIndex == 6),
        // MyList("Add Bus Services", () {
        //   setState(() {
        //     selectedWidget = AddService();
        //     selectedIndex = 7;
        //   });
        // }, selectedIndex == 7),
        // MyList("Complain Request", () {
        //   setState(() {
        //     selectedIndex = 8;
        //   });
        // }, selectedIndex == 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: size.width / 5,
            color: Colors.black26,
            child: SideBar(size.height, size.width),
          ),
          Expanded(child: Center(child: selectedWidget)),
        ],
      ),
    );
  }
}
