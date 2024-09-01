import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../All_Classes.dart';
import '../main.dart';
import 'makepdf.dart';

class PdfPreviewPage extends StatelessWidget {
  final Bus bus;
  List<String> seatList;

  PdfPreviewPage({Key? key, required this.bus, required this.seatList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(seatList);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bus Ticket PDF", style: GoogleFonts.play(fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.bold),),
            Text("Kindly download this bus ticket PDF", style: GoogleFonts.play(fontStyle: FontStyle.italic, color: Colors.white, fontSize: size.height/70),),
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: Home(),
                  inheritTheme: true,
                  ctx: context),
            );
          }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
        ],
      ),
      body: Container(
        child: PdfPreview(
          build: (format) => makePdf(bus, seatList),
          allowPrinting: true,
          allowSharing: true,
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          // enableScrollToPage: true,
          pdfFileName: "${bus.companyName} Bus Ticket.pdf",
          // pdfPreviewPageDecoration: ,
        ),
      ),
    );
  }
}
