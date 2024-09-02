import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../All_Classes.dart';
import '../fireStore.dart';
import 'dropDown.dart';

class AddDrivers extends StatefulWidget {
  const AddDrivers({super.key});

  @override
  State<AddDrivers> createState() => _AddDriversState();
}

class _AddDriversState extends State<AddDrivers> {
  final nameCont = TextEditingController();
  final licenseCont = TextEditingController();
  final ExpYrCont = TextEditingController();
  final searchFilter = TextEditingController();
  bool isLoad = false;
  bool _isDataLoaded = false;
  final firestore = FirebaseFirestore.instance.collection("Drivers");
  final auth = FirebaseAuth.instance;

  FirestoreService firestoreService = FirestoreService();

  List<Driver> drivers = [];
  List<Driver> filteredDrivers = [];
  String? serviceSelect;
  List<Services> serviceList = [];
  String? selectedDriver;
  List<String> serivceNameList = [];


  @override
  void initState() {
    super.initState();
    _loadDataWithDelay();
    fetchDrivers();
    fetchService();
    searchFilter.addListener(filterDrivers);
  }

  @override
  void dispose() {
    searchFilter.removeListener(filterDrivers);
    searchFilter.dispose();
    super.dispose();
  }

  void _loadDataWithDelay() async {
    // Show the CircularProgressIndicator initially
    setState(() {
      _isDataLoaded = false;
    });

    // Wait for 3 seconds
    await Future.delayed(Duration(seconds: 1));

    // Update the state to show the Expanded widget
    setState(() {
      _isDataLoaded = true;
    });
  }


  Future<void> fetchDrivers() async {
    List<Driver> fetchedDrivers = await firestoreService.getAllDrivers();
    setState(() {
      drivers = fetchedDrivers.reversed.toList();
      filteredDrivers = drivers; // Initialize filteredDrivers with all drivers
    });
  }

  Future<void> fetchService() async {
    List<Services> fetchedServices = await firestoreService.getAllServices();
    setState(() {
      serviceList = fetchedServices;
      serivceNameList = serviceList.map((serve) => serve.serviceName).toList();
    });
  }

  void filterDrivers() {
    String query = searchFilter.text.toLowerCase();
    setState(() {
      filteredDrivers = drivers.where((driver) {
        return
          driver.name.toLowerCase().contains(query) ||
          driver.service.toLowerCase().contains(query) ||
            driver.licenseId.toLowerCase().contains(query) ||
            driver.expYr.toLowerCase().contains(query);
      }).toList();
    });
  }

  void AddBox(double h, double w, {int index = -1}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: h / 1.2,
          width: w / 1.8,
          child: AlertDialog(
            title: Row(
              children: [
                Expanded(
                  child: Text(index == -1
                      ? "Add Drivers"
                      : "Update Drivers",
                    style: GoogleFonts.play(
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel_rounded, color: CupertinoColors.systemRed),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Icon(Icons.person, size: h / 3),
                    ),
                  ),
                  Center(child: Container(width: h / 100)),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: h / 100),
                        TextField(
                          controller: nameCont,
                          style: GoogleFonts.play(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outlined),
                            hintText: "Enter Driver Name",
                            hintStyle: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade500,
                            ),
                            labelText: "Driver Name",
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
                        SizedBox(height: h / 35),
                        TextField(
                          controller: licenseCont,
                          style: GoogleFonts.play(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.gpp_good),
                            hintText: "Enter Driving license #",
                            hintStyle: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade500,
                            ),
                            labelText: "Driving License",
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
                        SizedBox(height: h / 35),
                        TextField(
                          controller: ExpYrCont,
                          style: GoogleFonts.play(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.drive_eta),
                            hintText: "Enter Driving Experience",
                            hintStyle: GoogleFonts.play(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade500,
                            ),
                            labelText: "Driving Experience",
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
                        SizedBox(height: h / 35),
                        DropD.buildDropdownSearch(h, w, h/3.8, serivceNameList, Icon(Icons.grade), Icon(Icons.grade_outlined),"Select Service", "Service", serviceSelect,
                                (newValue) {
                              setState(() {
                                serviceSelect = newValue;
                                });
                            } ),
                        SizedBox(height: h / 35),

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
                                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                                    try {
                                      if (index == -1) {
                                        Driver newDriver = Driver(
                                          id,
                                          nameCont.text.toString(),
                                          licenseCont.text.toString(),
                                          ExpYrCont.text.toString(),
                                          // selectedDriver.toString(),
                                          serviceSelect.toString(),
                                        );
                                        firestoreService.addDriver(newDriver);
                                      } else {
                                        Driver updatedDriver = Driver(
                                          drivers[index].id,
                                          nameCont.text.toString(),
                                          licenseCont.text.toString(),
                                          ExpYrCont.text.toString(),
                                          serviceSelect.toString(),
                                        );
                                        firestoreService.updateDriver(updatedDriver);
                                        // fetchDrivers(); // Refresh the list after updating
                                      }
                                      setState(() {
                                        fetchDrivers();
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle_outline, color: Colors.white),
                                              SizedBox(width: 10),
                                              Text(index == -1
                                                  ? "Driver '${nameCont.text}' added successfully :)"
                                                  : "Driver '${nameCont.text}' updated successfully :)",
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
                                              Icon(Icons.error_outline, color: Colors.white),
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
                                          backgroundColor: CupertinoColors.destructiveRed,
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        isLoad = false;
                                        nameCont.clear();
                                        ExpYrCont.clear();
                                        licenseCont.clear();
                                        selectedDriver = null;
                                        serviceSelect = null;
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Center(
                                    child: isLoad
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Text(index == -1
                                        ? "Add"
                                        : "Update",
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
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.1, // Adjust the opacity to make it subtle
              child: Icon(
                Icons.person_add,
                size: size.height / 1.2,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(size.height / 15),
          child: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Bus Driver Details",
                            style: GoogleFonts.play(
                              fontSize: size.height / 18,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(width: size.height / 10), // Add some space between title and search bar
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: size.height / 50),
                            child: TextFormField(
                              controller: searchFilter,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.search),
                                ),
                                hintText: "Search Driver",
                                hintStyle: GoogleFonts.play(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.height / 2),
                                ),
                              ),
                              onChanged: (String value) {
                                filterDrivers();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.white24,
                    ),
                    SizedBox(height: size.height / 50),
                    Container(
                      color: Colors.white30,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height/100),
                        child: Row(
                          children: [
                            Expanded(child: Text("Index", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Name", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("License No.", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Service", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Experience Year", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            IconButton(
                              onPressed: () {
                                // Add your desired functionality here
                              },
                              icon: Icon(Icons.cancel),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Divider(thickness: 2, color: Colors.white30),
                    !_isDataLoaded?Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: CupertinoActivityIndicator(radius: size.height/20,),
                          ),
                          Text("Fetching data from database . . .", style: GoogleFonts.play(fontStyle: FontStyle.italic, color: Colors.white70),)
                        ],
                      ),
                    ):filteredDrivers.isEmpty
                        ? Center(
                      child: Text(
                        'No drivers found',
                        style: GoogleFonts.play(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                        : Expanded(
                      child: ListView.builder(
                        itemCount: filteredDrivers.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  nameCont.text = filteredDrivers[index].name;
                                  licenseCont.text = filteredDrivers[index].licenseId;
                                  ExpYrCont.text = filteredDrivers[index].expYr;
                                  selectedDriver = filteredDrivers[index].service;
                                  serviceSelect = filteredDrivers[index].service;
                                  AddBox(size.height, size.width, index: drivers.indexOf(filteredDrivers[index]));
                                },
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${index + 1}', style: GoogleFonts.play(fontSize: size.height/40),)),
                                    Expanded(child: Text('${filteredDrivers[index].name}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filteredDrivers[index].licenseId}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filteredDrivers[index].service}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filteredDrivers[index].expYr}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    IconButton(
                                      onPressed: () {
                                        firestoreService.deleteDriver(filteredDrivers[index].id);
                                        fetchDrivers(); // Refresh the list after deletion
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.white30),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: size.width / 150,
                  right: size.width / 350,
                  child: FloatingActionButton(
                    onPressed: () {
                      nameCont.clear();
                      ExpYrCont.clear();
                      licenseCont.clear();
                      selectedDriver = null;
                      serviceSelect = null;
                      AddBox(size.height, size.width);
                    },
                    child: Icon(Icons.add, size: size.height / 12),
                    backgroundColor: CupertinoColors.activeBlue,
                    elevation: 0,
                    tooltip: "Add New Drivers",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
