import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookTickets extends StatefulWidget {
  const BookTickets({super.key});

  @override
  State<BookTickets> createState() => _xyzState();
}

class _xyzState extends State<BookTickets> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Book Bus Tickets", style: GoogleFonts.play(fontSize: size.height/16 ),)),
          SizedBox(height: size.height/20,),
          TextField(
            decoration: InputDecoration(
              labelText: "Enter Bus Driver Name",
              labelStyle: GoogleFonts.play(fontSize: 16),
              hintText: "Enter Name",
              border: OutlineInputBorder(),
            ),
          ),

        ],
      ),
    );
  }
}

