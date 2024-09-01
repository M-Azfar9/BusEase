import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../All_Classes.dart';

Future<Uint8List> makePdf(Bus bus, List<String> seatList) async {
  final pdf = pw.Document();

  // Fetch the image data from the URL
  final imageUrl = bus.companyProfile; // Ensure this is a valid image URL
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    final imageData = response.bodyBytes;
    final image = pw.MemoryImage(imageData);

    for (int i =  seatList.length - 1; i >= 0; i--) {
      Passenger? passenger = bus.passengerList.firstWhere(
              (test) => test.seatNo == seatList[i].substring(1),);
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'BusE@se Ticket',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  color: PdfColors.black,
                  child: pw.Row(children: [
                  pw.Expanded(child: pw.Text(
                    "  Passenger Slip",
                    style: pw.TextStyle(
                      color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic),
                  ),),
                  pw.Text(
                    "Seat No: ${passenger.seatNo}  ",
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,),
                  ),
                ]),),
                pw.SizedBox(height: 10),
                pw.Divider(height: 1, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "Bus Details:",
                              style: pw.TextStyle(
                                  fontSize: 20, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text("Service Name: ${bus.companyName}"),
                            pw.Text("Departure City: ${bus.depCity}"),
                            pw.Text("Destination City: ${bus.destCity}"),
                            pw.Text("Bus Type: ${bus.busType}"),
                            pw.Text("Departure Date: ${bus.depDate}"),
                            pw.Text("Departure Time: ${bus.departureTime}"),
                            pw.Text("Arrival Time: ${bus.arrivalTime}"),
                            pw.Text("Single Ticket Price: ${bus.ticketPrice}"),
                            pw.Text("Bus Number plate: ${bus.busNoplate}"),
                            pw.Text("Bus Stops: ${bus.stops}"),
                          ],
                        ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Passenger Details:",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text("Passenger ID: ${passenger.id}"),
                        pw.Text("Name: ${passenger.name}"),
                        pw.Text("CNIC Number: ${passenger.CNIC}"),
                        pw.Text("Phone Number: ${passenger.phoneNumber}"),
                        pw.Text("Email Id: ${passenger.email}"),
                        pw.Text("Gender: ${passenger.gender}"),
                        pw.Text("Seat Number: ${passenger.seatNo}"),
                      ],
                    ),),
                    pw.SizedBox(width: 8),
                    pw.Container(
                        width: 120,
                        child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                      pw.Container(
                        height: 100,
                        width: 100,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.ClipOval(
                          child: pw.Image(image, fit: pw.BoxFit.cover),
                        ),
                      ),
                          pw.Container(height: 20),
                          pw.Text(
                            "Driver Details:",
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text("Name: ${bus.busDriver.name}"),
                          pw.Text("Exp Yr: ${bus.busDriver.expYr}"),
                    ]
                        )
                    ),
                  ],
                ),
                pw.SizedBox(height: 15),
                pw.Divider(height: 1, borderStyle: pw.BorderStyle.dotted),
                pw.SizedBox(height: 15),
                pw.Text(
                  "Terms & Conditions:",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                    "1. Please carry a valid ID proof or CNIC along with this ticket.\n"
                        "2. The bus will depart on time; please arrive at least 15 minutes before the departure.\n"
                        "3. No refunds will be issued for missed buses."),
                pw.SizedBox(height: 15),
                pw.Center(
                  child: pw.Text(
                    "Thank you for choosing our service!",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Container(
                  color: PdfColors.black,
                  child: pw.Row(children: [
                    pw.Expanded(child: pw.Text(
                      "  Company Slip",
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.italic),
                    ),),
                    pw.Text(
                      "Seat No: ${passenger.seatNo}  ",
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,),
                    ),
                  ]),),
                pw.SizedBox(height: 10),
                pw.Divider(height: 1, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Bus Details:",
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text("Service Name: ${bus.companyName}"),
                          pw.Text("Departure City: ${bus.depCity}"),
                          pw.Text("Destination City: ${bus.destCity}"),
                          pw.Text("Bus Type: ${bus.busType}"),
                          pw.Text("Departure Date: ${bus.depDate}"),
                          pw.Text("Departure Time: ${bus.departureTime}"),
                          pw.Text("Arrival Time: ${bus.arrivalTime}"),
                          pw.Text("Single Ticket Price: ${bus.ticketPrice}"),
                          pw.Text("Bus Number plate: ${bus.busNoplate}"),
                          pw.Text("Bus Stops: ${bus.stops}"),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Passenger Details:",
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text("Passenger ID: ${passenger.id}"),
                          pw.Text("Name: ${passenger.name}"),
                          pw.Text("CNIC Number: ${passenger.CNIC}"),
                          pw.Text("Phone Number: ${passenger.phoneNumber}"),
                          pw.Text("Email Id: ${passenger.email}"),
                          pw.Text("Gender: ${passenger.gender}"),
                          pw.Text("Seat Number: ${passenger.seatNo}"),
                        ],
                      ),),
                    pw.SizedBox(width: 8),
                    pw.Container(
                        width: 120,
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                height: 100,
                                width: 100,
                                decoration: pw.BoxDecoration(
                                  shape: pw.BoxShape.circle,
                                ),
                                child: pw.ClipOval(
                                  child: pw.Image(image, fit: pw.BoxFit.cover),
                                ),
                              ),
                              pw.Container(height: 20),
                              pw.Text(
                                "Driver Details:",
                                style: pw.TextStyle(
                                    fontSize: 16, fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(height: 8),
                              pw.Text("Name: ${bus.busDriver.name}"),
                              pw.Text("Exp Yr: ${bus.busDriver.expYr}"),
                            ]
                        )
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
  } else {
    // Handle the error (image could not be fetched)
    print('Failed to load image from URL');
  }

  return pdf.save();
}
