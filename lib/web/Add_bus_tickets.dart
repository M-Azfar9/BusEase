import 'dart:io';
// import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../All_Classes.dart';
import '../fireStore.dart';
import 'dropDown.dart';
// import 'package:file_picker_example/src/file_picker_demo.dart';

class AddBusTickets extends StatefulWidget {
  const AddBusTickets({super.key});

  @override
  State<AddBusTickets> createState() => _AddBusTicketsState();
}

class _AddBusTicketsState extends State<AddBusTickets> {
  List<String> busStops = [];
  DateTime? selectedDate;
  TimeOfDay? depTime;
  TimeOfDay? arrTime;
  String? selectedOption;
  bool isLoad = false;

  final ticketPrice = TextEditingController();
  final busNoPlat = TextEditingController();
  String? depCity;
  String? destCity;
  final addLocCont = TextEditingController();
  FirestoreService fservices = FirestoreService();

  List<Services> service = [];
  String? serviceSelect;
  List<String> serviceNameList = [];
  String? logo;

  List<Driver> drivers = [];
  String? driverSelect;
  List<String> driverList = [];

  List<String> locateList = [];
  Driver? busDriver;

  List<Passenger> passengerList = [];


  void initState() {
    super.initState();
    fetchServices();
    fetchDriver();
    fetchLocation();
  }

  void AddBox(double h, double w) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Add Locations",
            style: GoogleFonts.play(
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            Column(
              children: [
                SizedBox(
                  height: h / 100,
                ),
                TextField(
                  controller: addLocCont,
                  style: GoogleFonts.play(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.add_location),
                    hintText: "Enter Locations",
                    hintStyle: GoogleFonts.play(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade500,
                    ),
                    labelText: "Terminal Locations",
                    labelStyle: GoogleFonts.play(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue.shade900,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(h / 50),
                      borderSide: BorderSide(
                        color: CupertinoColors.activeBlue,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(h / 50),
                    ),
                  ),
                ),
                SizedBox(
                  height: h / 35,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: h / 16,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoad = true;
                            });

                            final id = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            try {
                              busStops.add(addLocCont.text.toString());
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        "Location '${addLocCont.text}' added successfully :)",
                                        style: GoogleFonts.play(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: CupertinoColors.activeGreen,
                                ),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        error.toString(),
                                        style: GoogleFonts.play(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor:
                                      CupertinoColors.destructiveRed,
                                ),
                              );
                            } finally {
                              setState(() {
                                isLoad = false;
                                addLocCont.clear();
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Center(
                            child: isLoad
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Add",
                                    style: GoogleFonts.play(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.activeBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(h / 50),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> fetchServices() async {
    List<Services> fetchSer = await fservices.getAllServices();
    setState(() {
      service = fetchSer;
      serviceNameList = service.map((serve) => serve.serviceName).toList();
    });
  }

  Future<void> fetchDriver() async {
    List<Driver> fetch = await fservices.getAllDrivers();
    setState(() {
      drivers = fetch;
      driverList = drivers.map((drive) => drive.name).toList();
    });
  }

  Future<void> fetchLocation() async {
    List<Locations> fetch = await fservices.getAllLocations();
    setState(() {
      List<Locations> loc = fetch;
      locateList = loc.map((locate) => locate.cityLocation).toList();
    });
  }

  bool areInputsValid() {
    if (busDriver == null) {
      print('Driver is not selected');
      return false;
    }

    if (selectedDate == null) {
      print('Departure date is not selected');
      return false;
    }
    if (depTime == null) {
      print('Departure time is not selected');
      return false;
    }

    if (arrTime == null) {
      print('Arrival time is not selected');
      return false;
    }

    if (selectedOption == null || selectedOption!.isEmpty) {
      print('Bus type is not selected');
      return false;
    }

    if (ticketPrice.text.isEmpty) {
      print('Ticket price is not entered');
      return false;
    }

    if (busNoPlat.text.isEmpty) {
      print('Bus number plate is not entered');
      return false;
    }

    if (depCity == null || depCity!.isEmpty) {
      print('Departure city is not selected');
      return false;
    }

    if (destCity == null || destCity!.isEmpty) {
      print('Destination city is not selected');
      return false;
    }

    if (busStops.isEmpty) {
      print('No bus stops are added');
      return false;
    }

    if (serviceSelect == null || serviceSelect!.isEmpty) {
      print('Service is not selected');
      return false;
    }

    print("All are Filled");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Bus Icon as background
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.1, // Adjust the opacity to make it subtle
              child: Icon(
                Icons.directions_bus,
                size: size.height / 1.2,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(size.height / 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Add Bus Tickets",
                        style: GoogleFonts.play(
                          fontSize: size.height / 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.white24,
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Row(
                      children: [
                        Container(
                          height: size.height / 4,
                          width: size.height / 4,
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .circle, // Ensures the container is circular
                            border: Border.all(
                              color: Colors.white70,
                            ),
                          ),
                          child: ClipOval(
                            child: (logo != null)
                                ? Image.network(
                                    logo!,
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the circular container
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: size.height / 12,
                                        color: Colors.white70,
                                      ),
                                      Text(
                                        "No Service",
                                        style: GoogleFonts.play(
                                            fontSize: size.height / 50,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        "Logo",
                                        style: GoogleFonts.play(
                                            fontSize: size.height / 50,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: size.height / 20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropD.buildDropdownSearch(
                                  size.height,
                                  size.width,
                                  size.height / 2,
                                  serviceNameList,
                                  Icon(Icons.grade),
                                  Icon(Icons.grade_outlined),
                                  "Select Service",
                                  "Service",
                                  serviceSelect, (newValue) {
                                setState(() {
                                  serviceSelect = newValue;
                                  Services selService = service.firstWhere(
                                      (serve) =>
                                          serve.serviceName == serviceSelect);
                                  logo = selService.logo;
                                  driverList = drivers
                                      .where((drive) =>
                                          drive.service == serviceSelect)
                                      .map((drive) => drive.name)
                                      .toList();
                                });
                              }),
                              SizedBox(
                                height: size.height / 40,
                              ),
                              DropD.buildDropdownSearch(
                                  size.height,
                                  size.width,
                                  size.height / 2.3,
                                  driverList,
                                  Icon(Icons.person_4_sharp),
                                  Icon(Icons.person_4_sharp),
                                  "Select Driver",
                                  "Driver Name",
                                  driverSelect, (newValue) {
                                setState(() {
                                  driverSelect = newValue;
                                  busDriver = drivers.firstWhere((driver) => driver.name == driverSelect && driver.service == serviceSelect);
                                });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ticketPrice,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.price_change),
                              labelText: "Ticket Price",
                              labelStyle: GoogleFonts.play(
                                fontSize: size.height / 32,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: "Enter Ticket Price",
                              hintStyle: GoogleFonts.play(
                                fontSize: size.height / 32,
                                fontStyle: FontStyle.italic,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(size.height / 50),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.height / 40,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: busNoPlat,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.numbers),
                              labelText: "Bus # Plate",
                              labelStyle: GoogleFonts.play(
                                fontSize: size.height / 32,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: "Enter Bus Number Plate",
                              hintStyle: GoogleFonts.play(
                                fontSize: size.height / 32,
                                fontStyle: FontStyle.italic,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(size.height / 50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    DropD.buildDropdownSearch(
                        size.height,
                        size.width,
                        size.height / 2,
                        locateList,
                        Icon(Icons.location_city_outlined),
                        Icon(Icons.location_city_outlined),
                        "Enter City Name",
                        "Departure City",
                        depCity, (newValue) {
                      setState(() {
                        depCity = newValue;
                      });
                    }),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    DropD.buildDropdownSearch(
                        size.height,
                        size.width,
                        size.height / 2,
                        locateList,
                        Icon(Icons.location_on),
                        Icon(Icons.location_on),
                        "Enter City Name",
                        "Destination City",
                        destCity, (newValue) {
                      setState(() {
                        destCity = newValue;
                      });
                    }),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_month,
                              ),
                              hintText: selectedDate == null
                                  ? "Select Date"
                                  : "${selectedDate!.toLocal()}".split(' ')[0],
                              hintStyle: GoogleFonts.play(
                                fontSize: size.height / 32,
                                fontStyle: FontStyle.italic,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(size.height / 50),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.01),
                        SizedBox(
                          height: size.height / 11,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CupertinoColors.activeBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(size.height / 50),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.05,
                              ),
                            ),
                            onPressed: () async {
                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025),
                              );
                              setState(() {});
                            },
                            child: Text(
                              "Pick Date",
                              style: GoogleFonts.play(
                                fontSize: size.height / 32,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.access_time,
                                    ),
                                    hintText: depTime == null
                                        ? "Select Departure Time"
                                        : depTime!.format(context),
                                    hintStyle: GoogleFonts.play(
                                      fontSize: size.height / 32,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          size.height / 50),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.01),
                              SizedBox(
                                height: size.height / 11,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CupertinoColors.activeBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          size.height / 40),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.015,
                                      horizontal: size.width * 0.01,
                                    ),
                                  ),
                                  onPressed: () async {
                                    depTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                    );
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Pick Time",
                                    style: GoogleFonts.play(
                                      fontSize: size.height / 32,
                                      // color: CupertinoColors.activeBlue,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: Container(
                                width: size.height / 10, color: Colors.white)),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.access_time_filled,
                                    ),
                                    hintText: arrTime == null
                                        ? "Select Arrival Time"
                                        : arrTime!.format(context),
                                    hintStyle: GoogleFonts.play(
                                      fontSize: size.height / 32,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          size.height / 50),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.01),
                              SizedBox(
                                height: size.height / 11,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CupertinoColors.activeBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          size.height / 40),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.015,
                                      horizontal: size.width * 0.01,
                                    ),
                                  ),
                                  onPressed: () async {
                                    arrTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                    );
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Pick Time",
                                    style: GoogleFonts.play(
                                      fontSize: size.height / 32,
                                      // color: CupertinoColors.activeBlue,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Column(
                      children: [
                        Container(
                          // width: size.width / 3.5,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(size.height / 40),
                              border: Border.all(
                                color: Colors.white30,
                              )),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.only(
                                        topRight:
                                            Radius.circular(size.height / 40),
                                        topLeft:
                                            Radius.circular(size.height / 40)),
                                    border: Border.all(
                                      color: Colors.white30,
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: size.height / 20,
                                      top: size.height / 70,
                                      bottom: size.height / 70),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text("Select Bus Type:",
                                          style: GoogleFonts.play(
                                              fontSize: size.height / 27,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic))),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SelectBus("Executive Class", size.height),
                                  SelectBus("Executive Plus", size.height),
                                  SelectBus("Business Class", size.height),
                                  SelectBus("Sleeper Class", size.height),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Container(
                      height: size.height / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size.height / 40),
                          border: Border.all(
                            color: Colors.white30,
                          )),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(size.height / 40),
                                    topLeft: Radius.circular(size.height / 40)),
                                border: Border.all(
                                  color: Colors.white30,
                                )),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: size.height / 20,
                                  top: size.height / 60,
                                  bottom: size.height / 65),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("Add Bus Stops:",
                                            style: GoogleFonts.play(
                                                fontSize: size.height / 27,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic))),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: size.height / 20),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                            onPressed: () {
                                              AddBox(size.height, size.width);
                                            },
                                            icon: Icon(
                                              Icons.add_location_alt_outlined,
                                              color: Colors.black,
                                            ))),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: busStops.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          splashColor:
                                              CupertinoColors.activeBlue,
                                          child: ListTile(
                                            title: Text(
                                              busStops[index],
                                              style: GoogleFonts.play(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            leading: Icon(Icons.location_on),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    busStops.removeAt(index);
                                                  });
                                                },
                                                icon: Icon(
                                                    Icons.cancel_outlined)),
                                          ),
                                        ),
                                      ],
                                    );
                                  })),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("")),
                        Center(
                          child: Container(
                            width: 2,
                          ),
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                                    height: size.height / 10,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CupertinoColors.activeBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                size.height / 40),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Reset",
                                          style: GoogleFonts.play(
                                              fontSize: size.height / 30,
                                              fontWeight: FontWeight.w900,
                                              fontStyle: FontStyle.italic),
                                        )))),
                            Container(
                              width: size.height / 30,
                            ),
                            Expanded(
                                child: SizedBox(
                                    height: size.height / 10,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CupertinoColors.activeBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                size.height / 40),
                                          ),
                                        ),
                                        onPressed: () {
                                          final id = DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString();
                                          try{
                                            if(areInputsValid()){
                                              Seats busSeats = Seats(id.toString());
                                              Bus busTick = Bus(
                                                  id.toString(),
                                                  busDriver!,
                                                  logo.toString(),
                                                  serviceSelect.toString(),
                                                  busNoPlat.text.toString(),
                                                  selectedOption.toString(),
                                                  depTime!.format(context).toString(),
                                                  arrTime!.format(context).toString(),
                                                  selectedDate.toString().split(' ')[0],
                                                  depCity.toString(),
                                                  destCity.toString(),
                                                  ticketPrice.text.toString(),
                                                  busStops,
                                                  passengerList,
                                                  busSeats);
                                              fservices.addTickets(busTick);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(Icons.check_box,
                                                          color: Colors.white),
                                                      SizedBox(width: 10),
                                                      Text("Ticket Uploaded Successfully :)",
                                                        style: GoogleFonts.play(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor: CupertinoColors.activeGreen,
                                                ),
                                              );
                                              setState(() {
                                                busDriver = null;
                                                selectedDate = null;
                                                driverSelect = null;
                                                depTime = null;
                                                arrTime = null;
                                                selectedOption = null;
                                                ticketPrice.clear();
                                                busNoPlat.clear();
                                                depCity = null ;
                                                destCity = null ;
                                                busStops.clear();
                                                serviceSelect = null;
                                                logo = null;
                                              });
                                              print(logo);
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(Icons.error,
                                                          color: Colors.white),
                                                      SizedBox(width: 10),
                                                      Text("Kindly fill this form, correct and complete :(",
                                                        style: GoogleFonts.play(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor: CupertinoColors.systemRed,
                                                ),
                                              );
                                            }
                                          }catch(e){
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(Icons.error,
                                                        color: Colors.white),
                                                    SizedBox(width: 10),
                                                    Text(e.toString(),
                                                      style: GoogleFonts.play(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: CupertinoColors.systemRed,
                                              ),
                                            );
                                          }


                                        },
                                        child: Text(
                                          "Add Ticket",
                                          style: GoogleFonts.play(
                                              fontSize: size.height / 30,
                                              fontWeight: FontWeight.w900,
                                              fontStyle: FontStyle.italic),
                                        )))),
                          ],
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget SelectBus(String txt, double h) {
    return Expanded(
      child: RadioListTile(
        activeColor: CupertinoColors.activeBlue,
        title: Text(txt, style: GoogleFonts.play()),
        value: txt,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value;
          });
        },
      ),
    );
  }
}
