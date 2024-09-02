import 'package:bus_ease/UI/pdfPage.dart';
import 'package:bus_ease/UI/ticketDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../All_Classes.dart';
import '../fireStore.dart';

class BusSeats extends StatefulWidget {
  Bus bus;
  BusSeats({required this.bus, super.key});

  @override
  State<BusSeats> createState() => _BusSeatsState();
}

class _BusSeatsState extends State<BusSeats> {
  final _formKey = GlobalKey<FormState>();
  FirestoreService fs = FirestoreService();
  final nameCont = TextEditingController();
  final numberCont = TextEditingController();
  final cnicCont = TextEditingController();


  List<String> seatGender = [];

  int totalSeats = 0;
  int totalTicketPrice = 0;
  // Passenger newPassenger = Passenger("","", "", "", "", "", "", "", "", false);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameCont.dispose();
    numberCont.dispose();
    cnicCont.dispose();
  }


  void PickGender(double h, double w, String? checkValue, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Gender",
            style: GoogleFonts.play(
              fontSize: w / 18,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(w / 10),
                    ),
                    child: Center(
                        child: Text(
                      "Seat Number: ${value.substring(1)}",
                      style: GoogleFonts.play(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // // Check if adjacent seat is not Female
                          if (checkValue == null || checkValue[0] == "F") {
                            // Allow selection of Male
                            Navigator.pop(context);
                            _showSeatNotAllowedAlert(h, w, "Male");
                            // TODO: Add logic to select the Male seat
                          } else {
                            print("Male selected");
                            setState(() {
                              int index =
                                  widget.bus.busSeats.seatButton.indexOf(value);
                              print(widget.bus.busSeats.seatButton[index]);
                              String newValue = widget
                                  .bus.busSeats.seatButton[index]
                                  .replaceFirst('_', 'M');
                              widget.bus.busSeats.seatButton[index] = newValue;
                              print(widget.bus.busSeats.seatButton[index]);
                              totalSeats += 1;
                              seatGender.add(newValue);
                              print("value Add ${newValue}");
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              checkValue == null
                                  ? Icons.person
                                  : checkValue[0] == "F"
                                      ? Icons.person_off
                                      : Icons.person,
                              color: Colors.lightBlue,
                              size: w / 3,
                            ),
                            Text(
                              "Male",
                              style: GoogleFonts.play(
                                color: Colors.lightBlue,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: w / 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Check if adjacent seat is not Male
                          if (checkValue == null || checkValue[0] == "M") {
                            // Allow selection of Female
                            Navigator.pop(context);
                            // TODO: Add logic to select the Female seat
                            _showSeatNotAllowedAlert(h, w, "Female");
                            print(checkValue.toString());
                          } else {
                            print("Female selected");
                            setState(() {
                              int index =
                                  widget.bus.busSeats.seatButton.indexOf(value);
                              print(widget.bus.busSeats.seatButton[index]);
                              String newValue = widget
                                  .bus.busSeats.seatButton[index]
                                  .replaceFirst('_', 'F');
                              widget.bus.busSeats.seatButton[index] = newValue;
                              print(widget.bus.busSeats.seatButton[index]);
                              totalSeats += 1;
                              seatGender.add(newValue);
                              print("value Add ${newValue}");
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              checkValue == null
                                  ? Icons.person
                                  : checkValue[0] == "M"
                                      ? Icons.person_off
                                      : Icons.person,
                              color: Colors.pink[300],
                              size: w / 3,
                            ),
                            Text(
                              "Female",
                              style: GoogleFonts.play(
                                color: Colors.pink[300],
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: w / 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showSeatNotAllowedAlert(double h, double w, String gender) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Alert!",
            style: GoogleFonts.play(
              color: CupertinoColors.destructiveRed,
              fontSize: w / 20,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            Column(
              children: [
                Text(
                  "Cannot select $gender due to adjacent seat restrictions. Kindly choose another seat.",
                  style: GoogleFonts.play(),
                ),
                Row(
                  children: [
                    Expanded(child: Row()),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CupertinoColors.systemRed),
                      child: Text(
                        "OK",
                        style: GoogleFonts.play(
                          color: CupertinoColors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void AlreadyBook(double h, double w) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Expanded(
            child: Text(
              "Alert!",
              style: GoogleFonts.play(
                color: CupertinoColors.destructiveRed,
                fontSize: w / 20,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                Text(
                  "This seat is already booked by someone.",
                  style: GoogleFonts.play(),
                ),
                Text(
                  "Kindly book another one.",
                  style: GoogleFonts.play(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(child: Row()),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.systemRed),
                        child: Text(
                          "Ok",
                          style: GoogleFonts.play(
                              color: CupertinoColors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void YourSeat(double h, double w) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Expanded(
            child: Text(
              "Your Seat",
              style: GoogleFonts.play(
                color: CupertinoColors.activeGreen,
                fontSize: w / 20,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                Text(
                  "This seat is already booked by you.",
                  style: GoogleFonts.play(),
                ),
                Text(
                  "Kindly book another one.",
                  style: GoogleFonts.play(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(child: Row()),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.activeGreen),
                        child: Text(
                          "Ok",
                          style: GoogleFonts.play(
                              color: CupertinoColors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void CancelSeats(double h, double w, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Expanded(
            child: Text(
              "Seat Cancel",
              style: GoogleFonts.play(
                color: CupertinoColors.destructiveRed,
                fontSize: w / 20,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(w / 10),
                  ),
                  child: Center(
                    child: Text(
                      "Seat Number: ${value.substring(1)}",
                      style: GoogleFonts.play(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  "Are you want to cancel this seat?",
                  style: GoogleFonts.play(),
                ),
                Row(children: [
                  Expanded(child: Row()),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No",style: GoogleFonts.play(
                          color: CupertinoColors.destructiveRed,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),),
                      ),
                      SizedBox(width: w/20,),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            int index =
                            widget.bus.busSeats.seatButton.indexOf(value);
                            print(widget.bus.busSeats.seatButton[index]);
                            String newValue = "";
                            if (value[0] == "M") {
                              newValue = widget.bus.busSeats.seatButton[index]
                                  .replaceFirst('M', '_');
                              seatGender.remove(value);
                              print("value removed ${value}");
                            } else if (value[0] == "F") {
                              newValue = widget.bus.busSeats.seatButton[index]
                                  .replaceFirst('F', '_');
                              seatGender.remove(value);
                              print("value removed ${value}");
                            }
                            widget.bus.busSeats.seatButton[index] = newValue;
                            print(widget.bus.busSeats.seatButton[index]);
                            totalSeats -= 1;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Yes",style: GoogleFonts.play(
                          color: CupertinoColors.destructiveRed,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),),
                      ),
                    ],
                  ),
                ],)
              ],
            )
          ],
        );
      },
    );
  }

  void OnBookingDetails(double h, double w) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Enter Details",
                    style: GoogleFonts.play(
                      color: CupertinoColors.activeBlue,
                      fontSize: w / 20,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: CupertinoColors.destructiveRed,
                    )),
              ],
            ),
          ),
          actions: [
            Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: h / 12,
                          child: TextFormField(
                            controller: nameCont,
                            style: GoogleFonts.play(
                                fontSize: w / 26, fontStyle: FontStyle.italic),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter Name",
                              hintStyle: GoogleFonts.play(
                                  fontSize: w / 26,
                                  fontStyle: FontStyle.italic),
                              labelStyle: GoogleFonts.play(
                                  fontSize: w / 26,
                                  fontStyle: FontStyle.italic),
                              labelText: "Passenger Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w / 10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Kindly Enter Name";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: h / 70,
                        ),
                        Container(
                          height: h / 12,
                          child: TextFormField(
                            controller: numberCont,
                            style: GoogleFonts.play(
                                fontSize: w / 26, fontStyle: FontStyle.italic),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "+92 **********",
                              prefixIcon: Icon(Icons.phone),
                              hintStyle: GoogleFonts.play(
                                  fontSize: w / 26,
                                  fontStyle: FontStyle.italic),
                              labelStyle: GoogleFonts.play(
                                  fontSize: w / 26,
                                  fontStyle: FontStyle.italic),
                              labelText: "Phone Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w / 10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Kindly Enter Phone Number";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: h / 70,
                        ),
                        Container(
                          height: h / 12,
                          child: TextFormField(
                            controller: cnicCont,
                            style: GoogleFonts.play(
                                fontSize: w / 26, fontStyle: FontStyle.italic),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter CNIC",
                              prefixIcon: Icon(Icons.badge),
                              hintStyle: GoogleFonts.play(
                                  fontSize: w / 26,
                                  fontStyle: FontStyle.italic),
                              labelStyle: GoogleFonts.play(
                                  fontSize: w / 26,
                                  fontStyle: FontStyle.italic),
                              labelText: "CNIC Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w / 10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Kindly Enter CNIC";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: h / 70,
                ),
                Row(
                  children: [
                    Expanded(child: Row()),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            List<String> seatList = [];
                            for (int i = totalSeats - 1; i >= 0; i--) {
                              // Create a new instance of Passenger in each iteration
                              final newPassenger = Passenger("","", "", "", "", "", "", "", "", false);
                              final auth = FirebaseAuth.instance;
                              final user = auth.currentUser;
                              final userId = user?.email;

                              final id = DateTime.now().millisecondsSinceEpoch;
                              newPassenger.id = id.toString();
                              newPassenger.name = nameCont.text.toString();
                              newPassenger.CNIC = cnicCont.text.toString();
                              newPassenger.phoneNumber = numberCont.text.toString();
                              newPassenger.email = user == null ? "" : user.email.toString();
                              newPassenger.gender = seatGender[i][0] == "M" ? "Male" : "Female";
                              newPassenger.seatNo = seatGender[i].substring(1);
                              newPassenger.totalSeat = totalSeats.toString();
                              newPassenger.totalTicketPrice = totalTicketPrice.toString();
                              newPassenger.confirmSeat = true;

                              // Add the newly created Passenger to the bus
                              widget.bus.addPassenger(newPassenger);
                              print(newPassenger.seatNo);
                              fs.updateTickets(widget.bus);
                            }

                            seatList = seatGender;
                            print("Seat List: ${seatList}");
                            print("Gender List: ${seatGender}");

                            setState(() {
                              nameCont.clear();
                              numberCont.clear();
                              cnicCont.clear();
                              seatGender = [];
                              totalSeats = 0;
                            });
                            print("Bus Ticket updated successfully");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfPreviewPage(bus: widget.bus, seatList: seatList,)
                              ),
                            );
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.activeBlue),
                        child: Text(
                          "Book",
                          style: GoogleFonts.play(
                              color: CupertinoColors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }


  Future<bool?> showExitConfirmationDialog(BuildContext context, double w) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Lose Your Seat?",style: GoogleFonts.play(
        color: CupertinoColors.activeBlue,
          fontSize: w / 20,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
        ),),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure?", style: GoogleFonts.play(
                fontWeight: FontWeight.bold,
              )),
              Text("Do you want to go back and lose your seat selection?",style: GoogleFonts.play(
                fontStyle: FontStyle.italic
              )
              ),
              Row(children: [
                Expanded(child: Row()),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("No",style: GoogleFonts.play(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),),
                    ),
                    SizedBox(width: w/20,),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Yes",style: GoogleFonts.play(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),),
                    ),
                  ],
                ),
              ],),
            ],
          ),

        ],
      ),
    );
  }

  void _handleSeatGenderLogic() {
    // Loop backwards to avoid issues with removing elements while iterating
    for (int i = seatGender.length - 1; i >= 0; i--) {
      setState(() {
        int index = widget.bus.busSeats.seatButton.indexOf(seatGender[i]);
        String newValue = "";

        if (seatGender[i][0] == "M") {
          newValue = widget.bus.busSeats.seatButton[index].replaceFirst('M', '_');
          print("Male seat value removed: ${seatGender[i]}");
        } else if (seatGender[i][0] == "F") {
          newValue = widget.bus.busSeats.seatButton[index].replaceFirst('F', '_');
          print("Female seat value removed: ${seatGender[i]}");
        }

        widget.bus.busSeats.seatButton[index] = newValue;
        seatGender.removeAt(i); // Remove the element at index i
        totalSeats -= 1;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    int? price;
    try {
      if (widget.bus.ticketPrice != null && widget.bus.ticketPrice.isNotEmpty) {
        String cleanedPrice =
            widget.bus.ticketPrice.replaceAll(RegExp(r'[^\d]'), '');
        price = int.parse(cleanedPrice);
      } else {
        print('Ticket price is null or empty');
      }
    } catch (e) {
      print('Error parsing ticket price: $e');
    }
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (totalSeats != 0) {
          bool? shouldExit = await showExitConfirmationDialog(context, size.width) ?? false;
          if (shouldExit ?? false) {
            _handleSeatGenderLogic();
          }
          return shouldExit ?? false;
        } else {
          // Navigator.push(
          //   context,
          //   PageTransition(
          //       type: PageTransitionType.leftToRight,
          //       child: Ticketdetails(ticketBus: widget.bus),
          //       inheritTheme: true,
          //       ctx: context),
          // );
          return true; // Allow back navigation when no seats are selected
        }


      },
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                height: size.height / 5 / 1.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width / 10),
                    bottomRight: Radius.circular(size.width / 10),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Text(
                        "Choose your Slots",
                        style: GoogleFonts.play(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: size.width / 22),
                      ),
                      Text(
                        "NOTE: Males cannot be seated next to Female",
                        style: GoogleFonts.play(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.red[300],
                            fontSize: size.width / 29),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 45),
                child: Container(
                  height: size.height / 17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width / 10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: CupertinoColors.activeGreen,
                            size: size.width / 30,
                          ),
                          Text(
                            "Your Seats",
                            style: GoogleFonts.play(
                                color: CupertinoColors.activeGreen,
                                fontSize: size.width / 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.lightBlue,
                            size: size.width / 30,
                          ),
                          Text(
                            "Male",
                            style: GoogleFonts.play(
                                color: Colors.lightBlue,
                                fontSize: size.width / 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.pink[300],
                            size: size.width / 30,
                          ),
                          Text(
                            "Female",
                            style: GoogleFonts.play(
                                color: Colors.pink[300],
                                fontSize: size.width / 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: CupertinoColors.black,
                            size: size.width / 30,
                          ),
                          Text(
                            "Available",
                            style: GoogleFonts.play(
                                color: CupertinoColors.black,
                                fontSize: size.width / 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black45,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.width / 50, horizontal: size.width / 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width / 30),
                      border: Border.all(
                        width: 2,
                        color: Colors.black45,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: size.width / 50),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.all(size.width / 50),
                                  child: Container(
                                    height: size.height / 14,
                                    width: size.height / 16,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(size.width / 30),
                                      child: Image.network(
                                        widget.bus.companyProfile,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width / 20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: size.width / 10,
                                      ),
                                      Text(
                                        "Driver",
                                        style: GoogleFonts.play(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Wrap(
                            children: widget.bus.busSeats.seatButton
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              String value = entry.value;
      
                              String? checkValue;
                              if (entry.value.isNotEmpty) {
                                // Parse the seat number
                                int seatNumber =
                                    int.parse(entry.value.substring(1));
      
                                // Adjust the index based on whether the seat number is even or odd
                                if (seatNumber % 2 == 0) {
                                  // Seat number is even, add 1 to the index
                                  int newIndex = index + 1;
                                  if (newIndex <
                                      widget.bus.busSeats.seatButton.length) {
                                    checkValue =
                                        widget.bus.busSeats.seatButton[newIndex];
                                  }
                                } else {
                                  // Seat number is odd, subtract 1 from the index
                                  int newIndex = index - 1;
                                  if (newIndex >= 0) {
                                    checkValue =
                                        widget.bus.busSeats.seatButton[newIndex];
                                  }
                                }
                              }
      
                              return Container(
                                width: size.width / 7,
                                height: size.height / 16,
                                child: BuildSeats(
                                  value,
                                  size.height,
                                  size.width,
                                  checkValue.toString(), // Pass next value
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: size.width / 20,
                    bottom: size.width / 20,
                    left: size.width / 20),
                child: Row(
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 2.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(size.width / 30),
                              topLeft: Radius.circular(size.width / 30)),
                          border: Border.all(
                            width: 3,
                            color: CupertinoColors.activeBlue,
                          )),
                      child: Center(
                        child: Text(
                          price != null
                              ? "Rs. ${price * totalSeats}"
                              : "Invalid price",
                          style: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // await fs.updateTickets(widget.bus);
                        if (totalSeats != 0) {
                          totalTicketPrice =
                              price != null ? price * totalSeats : 0;
                          OnBookingDetails(size.height, size.width);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.error, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Kindly Choose Your Seat",
                                    style: GoogleFonts.play(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: CupertinoColors.systemRed,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: size.height / 17,
                        width: size.width / 2.28,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(size.width / 30),
                              topRight: Radius.circular(size.width / 30)),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm Seats",
                            style: GoogleFonts.play(
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildSeats(String value, double h, double w, String checkValue) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userId = user?.email;
    // newPassenger.email = user == null ? "" : user.email.toString();

    String emailId = '';
    bool cnfrmSeatCheck = false;

    // Fetch emailId and cnfrmSeatCheck outside onTap
    if (value.isNotEmpty && (value[0] == "M" || value[0] == "F")) {
      try {
        emailId = widget.bus.passengerList
            .firstWhere(
                (passenger) => passenger.seatNo == value.substring(1))
            .email;
        cnfrmSeatCheck = widget.bus.passengerList
            .firstWhere(
                (passenger) => passenger.seatNo == value.substring(1))
            .confirmSeat;
      } catch (e) {
        emailId = '';
        cnfrmSeatCheck = false;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w / 50),
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                if ((value[0] == "M" || value[0] == "F") &&
                    seatGender.contains(value)) {
                  CancelSeats(h, w, value);
                  print("object");
                }
                if (value[0] == "_") {
                  PickGender(h, w, checkValue, value);
                } else if ((value[0] == "M" || value[0] == "F") &&
                    emailId != userId &&
                    cnfrmSeatCheck) {
                  AlreadyBook(h, w);
                } else if ((value[0] == "M" || value[0] == "F") &&
                    emailId == userId &&
                    cnfrmSeatCheck) {
                  YourSeat(h, w);
                }
              },
              child: Container(
                height: h / 30,
                decoration: BoxDecoration(
                  color: value.isEmpty
                      ? Colors.transparent
                      : ((value[0] == "M" || value[0] == "F") &&
                      emailId == userId &&
                      cnfrmSeatCheck)
                      ? CupertinoColors.activeGreen
                      : value[0] == "_"
                      ? Colors.transparent
                      : value[0] == "M"
                      ? Colors.lightBlueAccent
                      : Colors.pinkAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(w / 30),
                    topRight: Radius.circular(w / 30),
                  ),
                  border: Border.all(
                    width: 1,
                    color: value.isEmpty
                        ? Colors.transparent
                        : value[0] == "_"
                        ? Colors.black
                        : Colors.transparent,
                  ),
                ),
                child: value.isNotEmpty
                    ? Center(
                    child: Text(
                      value[0],
                      style: GoogleFonts.play(fontWeight: FontWeight.bold),
                    )) // Display the first character
                    : SizedBox.shrink(), // Empty widget if value is empty
              ),
            ),
            value.length > 1
                ? Text(
              value.substring(1),
              style: GoogleFonts.play(fontSize: w / 30),
            )
                : SizedBox.shrink(), // Empty widget if no characters to show
          ],
        ),
      ),
    );
  }
}
