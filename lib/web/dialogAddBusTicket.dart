import 'dart:io';
import 'dart:html' as html;
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

class DialogAddBus extends StatefulWidget {
  const DialogAddBus({super.key});

  @override
  State<DialogAddBus> createState() => _DialogAddBusState();
}

class _DialogAddBusState extends State<DialogAddBus> {
  List<String> busStops = [];
  DateTime? selectedDate;
  TimeOfDay? depTime;
  TimeOfDay? arrTime;
  String? selectedOption;
  bool isLoad = false;
  // FilePickerResult? picked;
  File? pickedImage;
  Uint8List webImage = Uint8List(8);

  final addLocCont = TextEditingController();
  FirestoreService fservices = FirestoreService();

  List<Services> service = [];
  String? serviceSelect;
  List<String> serviceNameList = [];
  String? logo;

  List<Driver> drivers = [];
  String? driverSelect;
  List<String> driverList = [];


  void initState(){
    super.initState();
    fetchServices();
    fetchDriver();
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
                              setState(() {

                              });
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
                                  backgroundColor:
                                  CupertinoColors.activeGreen,
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
                              borderRadius:
                              BorderRadius.circular(h / 50),
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

  Future<void> fetchServices()async{
    List<Services> fetchSer = await fservices.getAllServices();
    setState(() {
      service = fetchSer;
      serviceNameList = service.map((serve) => serve.serviceName).toList();
    });
  }

  Future<void> fetchDriver()async{
    List<Driver> fetch = await fservices.getAllDrivers();
    setState(() {
      drivers = fetch;
      driverList = drivers.map((drive) => drive.name).toList();
    });
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
              // child: Image.asset(
              //   'assets/back1.png', // Make sure you have the bus icon in your assets
              //   fit: BoxFit.cover,
              // ),
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
                            shape: BoxShape.circle, // Ensures the container is circular
                            border: Border.all(
                              color: Colors.white70,
                            ),
                          ),
                          child: ClipOval(
                            child: logo != null
                                ? Image.network(
                              logo!,
                              fit: BoxFit.cover, // Ensures the image covers the circular container
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: size.height/12, color: Colors.white70,),
                                Text("No Service", style: GoogleFonts.play(fontSize: size.height/50, color: Colors.white70),),
                                Text("Logo", style: GoogleFonts.play(fontSize: size.height/50, color: Colors.white70),),
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
                              DropD.buildDropdownSearch(size.height, size.width,size.height/2, serviceNameList, Icon(Icons.grade), Icon(Icons.grade_outlined),"Select Service", "Service", serviceSelect,
                                      (newValue) {
                                    setState(() {
                                      serviceSelect = newValue;
                                      Services selService = service.firstWhere((serve) => serve.serviceName == serviceSelect);
                                      logo = selService.logo;
                                      driverList = drivers.where((drive) => drive.service == serviceSelect).map((drive) => drive.name).toList();
                                    });
                                  } ),
                              SizedBox(
                                height: size.height / 40,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
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
                                          borderRadius: BorderRadius.circular(size.height/50),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.height / 40,
                                  ),
                                  Expanded(
                                    child: DropD.buildDropdownSearch(size.height, size.width,size.height/2.3, driverList, Icon(Icons.person_4_sharp),Icon(Icons.person_4_sharp),"Select Driver", "Driver Name", driverSelect,
                                            (newValue) {
                                          setState(() {
                                            driverSelect = newValue;
                                          });
                                        } ),
                                  ),
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
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city_outlined),
                        labelText: "Departure City",
                        labelStyle: GoogleFonts.play(
                          fontSize: size.height / 32,
                          fontStyle: FontStyle.italic,
                        ),
                        hintText: "Enter City Name",
                        hintStyle: GoogleFonts.play(
                          fontSize: size.height / 32,
                          fontStyle: FontStyle.italic,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(size.height/50),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        labelText: "Destination City",
                        labelStyle: GoogleFonts.play(
                          fontSize: size.height / 32,
                          fontStyle: FontStyle.italic,
                        ),
                        hintText: "Enter City Name",
                        hintStyle: GoogleFonts.play(
                          fontSize: size.height / 32,
                          fontStyle: FontStyle.italic,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(size.height/50),
                        ),
                      ),
                    ),
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
                                borderRadius: BorderRadius.circular(size.height/50),

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
                                borderRadius: BorderRadius.circular(size.height/50),
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
                                      borderRadius: BorderRadius.circular(size.height/50),

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
                                      borderRadius: BorderRadius.circular(size.height/40),
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
                                      initialEntryMode: TimePickerEntryMode.input,
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
                                      borderRadius: BorderRadius.circular(size.height/50),

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
                                      borderRadius: BorderRadius.circular(size.height/40),
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
                                      initialEntryMode: TimePickerEntryMode.input,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  bottom: size.height / 65
                              ),
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
                                    padding: EdgeInsets.only(right: size.height / 20),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(onPressed: (){
                                          AddBox(size.height, size.width);
                                        }, icon: Icon(Icons.add_location_alt_outlined, color: Colors.black,))),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: busStops.length,
                                  itemBuilder: (context, index){
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: (){},
                                          splashColor: CupertinoColors.activeBlue,
                                          child: ListTile(
                                            title: Text(busStops[index], style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                                            leading : Icon(Icons.location_on),
                                            trailing: IconButton(onPressed: (){
                                              setState(() {
                                                busStops.removeAt(index);
                                              });
                                            }, icon: Icon(Icons.cancel_outlined)),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                          ),
                        ],
                      ),
                    ),
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
