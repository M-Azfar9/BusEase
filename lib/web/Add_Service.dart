import 'dart:io';
import 'dart:typed_data';

import 'package:bus_ease/All_Classes.dart';
import 'package:bus_ease/fireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final ServiceCont = TextEditingController();
  final RegNoCont = TextEditingController();
  final CustSerPhNoCont = TextEditingController();
  final emailCont = TextEditingController();
  final headOfCont = TextEditingController();
  var logo;
  bool isLoad = false;
  bool _isDataLoaded = false;
  final searchFilter = TextEditingController();

  FirestoreService fservices = FirestoreService();
  List<Services> allServe = [];
  List<Services> filterServe = [];

  File? pickedImage;
  Uint8List? webImage = Uint8List(8);
  // Uint8List webImage = Uint8List(8);

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: "gs://bus-ease-cf06b.appspot.com");

  @override
  void initState() {
    super.initState();
    fetchServices();
    _loadDataWithDelay();
    searchFilter.addListener(filterServices);
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


  @override
  void dispose() {
    searchFilter.removeListener(filterServices);
    searchFilter.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    if (!kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          pickedImage = selected;
        });
      } else {
        print("No Image has been picked");
      }
    } else {
      XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          pickedImage = File('a'); // Set pickedImage to null since webImage will be used
        });
        print("Image has been picked");
      } else {
        print("No Image has been picked");
      }
    }
  }

  Future<void> uploadImage() async {
    if (pickedImage == null && webImage!.isEmpty) return;
    try {
      Reference ref = storage.ref().child('${ServiceCont.text.toString()}');
      if (kIsWeb) {
        // Upload web image
        await ref.putData(webImage!);
        // final uploadImg =  ref.putData(await pickedImage!.readAsBytes());
        // logo = await (await uploadImg).ref.getDownloadURL();
      } else if (pickedImage != null) {
        // Upload mobile image
        await ref.putFile(pickedImage!);
      }
      logo = await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString(), style: GoogleFonts.play(fontWeight: FontWeight.bold)),
        ),
      );
      print(e.toString());
    }
  }


  Future<void> fetchServices() async {
    List<Services> fetchedSer = await fservices.getAllServices();
    setState(() {
      allServe = fetchedSer.reversed.toList();
      filterServe = allServe; // Initialize filteredDrivers with all drivers
    });
  }

  void filterServices() {
    String query = searchFilter.text.toLowerCase();
    setState(() {
      filterServe = allServe.where((service) {
        return
          service.serviceName.toLowerCase().contains(query) ||
              service.regNumber.toLowerCase().contains(query) ||
              service.CustomerSerPhoneNo.toLowerCase().contains(query) ||
              service.headOffice.toLowerCase().contains(query) ||
              service.OfficialEmail.toLowerCase().contains(query);
      }).toList();
    });
  }

  void AddBox(double h, double w, {int index = -1}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState){
            return Container(
              child: AlertDialog(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(index == -1?
                        "Add Bus Service Company":"Update Bus Service Company",
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
                      InkWell(
                        onTap: () async {
                          await pickImage();
                          setState(() {});  // Trigger a rebuild within the dialog
                        },
                        child: Container(
                          width: h / 3,
                          height: h / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(h),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: ClipOval(
                            child: pickedImage != null
                                ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover, // Ensures the image covers the circular container
                            )
                                : logo != ""? Image.network(logo, fit: BoxFit.cover):Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Icon(Icons.image, size: h / 12, color: Colors.white70),
                                Text(
                                  "Select Service",
                                  style: GoogleFonts.play(fontSize: h / 50, color: Colors.white70),
                                ),
                                Text(
                                  "Logo",
                                  style: GoogleFonts.play(fontSize: h / 50, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(child: Container(width: h/20,),),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: h / 100,
                            ),
                            TextField(
                              controller: ServiceCont,
                              style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle_sharp),
                                hintText: "Enter Service Name",
                                hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade500,
                                ),
                                labelText: "Service Name",
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
                            TextField(
                              controller: RegNoCont,
                              style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.numbers),
                                hintText: "Enter Service Registration Number",
                                hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade500,
                                ),
                                labelText: "Registration Number",
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
                            TextField(
                              controller: headOfCont,
                              style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: "Enter Service Head Office City",
                                hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade500,
                                ),
                                labelText: "Head Office City",
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
                            TextField(
                              controller: CustSerPhNoCont,
                              style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: "Enter Phone Number For Customer Service",
                                hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade500,
                                ),
                                labelText: "Customer Service Phone #",
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
                            TextField(
                              controller: emailCont,
                              style: GoogleFonts.play(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_sharp),
                                hintText: "Enter Service Official Email Id",
                                hintStyle: GoogleFonts.play(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade500,
                                ),
                                labelText: "Official Email",
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
                                          await uploadImage();
                                          if (index == -1) {
                                            // Adding a new service
                                            Services newService = Services(
                                              id,
                                              ServiceCont.text.trim(),
                                              RegNoCont.text.trim(),
                                              emailCont.text.trim(),
                                              headOfCont.text.trim(),
                                              CustSerPhNoCont.text.trim(),
                                              logo.toString(), // Use the uploaded logo URL or empty string if not available
                                            );
                                            await fservices.addServices(newService);
                                          } else {
                                            // Updating an existing service
                                            Services updateSer = Services(
                                              allServe[index].id,
                                              ServiceCont.text.trim(),
                                              RegNoCont.text.trim(),
                                              emailCont.text.trim(),
                                              headOfCont.text.trim(),
                                              CustSerPhNoCont.text.trim(),
                                              logo == ""? filterServe[index].logo : logo , // Retain the existing logo if no new one is uploaded
                                            );
                                            await fservices.updateServices(updateSer);
                                          }

                                          setState(() {
                                            fetchServices();
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check_circle_outline,
                                                      color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text(index == -1?
                                                    "'${ServiceCont.text}' added successfully :)":"'${ServiceCont.text}' updated successfully :)",
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
                                            ServiceCont.clear();
                                            CustSerPhNoCont.clear();
                                            RegNoCont.clear();
                                            emailCont.clear();
                                            headOfCont.clear();
                                            logo = "";
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Center(
                                        child: isLoad
                                            ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                            : Text(index == -1?
                                          "Add":"Update",
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
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
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
                // Icons.send_rounded,
                Icons.add_chart_outlined,
                size: size.height / 1.2,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(size.height / 16),
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
                            "Bus Serivces Details",
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
                                hintText: "Search Service",
                                hintStyle: GoogleFonts.play(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.height / 2),
                                ),
                              ),
                              onChanged: (String value) {
                                setState((){
                                  filterServices();
                                });
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
                    Container(
                      color: Colors.white30,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height/100),
                        child: Row(
                          children: [
                            Expanded(child: Text("Logo", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Service", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Reg No.", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Help Line Number", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Official Email", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
                            Expanded(child: Text("Head Office", style: GoogleFonts.play(fontSize: size.height/32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)),
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
                    ):filterServe.isEmpty
                        ? Center(
                      child: Text(
                        'No Services found',
                        style: GoogleFonts.play(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                        : Expanded(
                      child: ListView.builder(
                        itemCount: filterServe.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  ServiceCont.text = filterServe[index].serviceName;
                                  RegNoCont.text = filterServe[index].regNumber;
                                  CustSerPhNoCont.text = filterServe[index].CustomerSerPhoneNo;
                                  emailCont.text = filterServe[index].OfficialEmail;
                                  headOfCont.text = filterServe[index].headOffice;
                                  logo = filterServe[index].logo;
                                  AddBox(size.height, size.width, index: allServe.indexOf(filterServe[index]));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: size.height/30),
                                          child: Container(
                                            height: size.height/8,
                                            width: size.height/8,
                                            child: ClipOval(
                                              child: filterServe[index].logo.isNotEmpty
                                                  ? Image.network(filterServe[index].logo, fit: BoxFit.cover,)
                                                  : Icon(Icons.account_circle_sharp, size: size.height / 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Text('${filterServe[index].serviceName}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filterServe[index].regNumber}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filterServe[index].headOffice}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filterServe[index].CustomerSerPhoneNo}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    Expanded(child: Text('${filterServe[index].OfficialEmail}', style: GoogleFonts.play(fontSize: size.height/40))),
                                    IconButton(
                                      onPressed: () {
                                        print(filterServe[index].logo);
                                        fservices.deleteServices(filterServe[index].id);
                                        fetchServices();// Refresh the list after deletion
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.delete),
                                                  SizedBox(width: size.height/30,),
                                                  Text("Service deleted successfully", style: GoogleFonts.play(color: Colors.white, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),),
                                                ],
                                              ),
                                            backgroundColor:
                                            CupertinoColors.destructiveRed,
                                          )
                                        );
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
                      setState(() {
                        isLoad = false;
                        ServiceCont.clear();
                        CustSerPhNoCont.clear();
                        RegNoCont.clear();
                        emailCont.clear();
                        headOfCont.clear();
                        logo = "";
                        webImage = Uint8List(0);
                        pickedImage = null;
                      });
                      AddBox(size.height, size.width);
                    },
                    child: Icon(Icons.add, size: size.height/12,),
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
