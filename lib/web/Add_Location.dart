import 'package:bus_ease/All_Classes.dart';
import 'package:bus_ease/fireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddLocations extends StatefulWidget {
  const AddLocations({super.key});

  @override
  State<AddLocations> createState() => _AddLocationsState();
}

class _AddLocationsState extends State<AddLocations> {
  final addLocCont = TextEditingController();
  bool isLoad = false;
  final editLocCont = TextEditingController();
  bool _isDataLoaded = false;

  FirestoreService fireS = FirestoreService();
  List<Locations> listLocate = [];
  List<Locations> filterLocate = [];
  final searchFilter = TextEditingController();

  void initState() {
    super.initState();
    fetchLocations();
    _loadDataWithDelay();
    searchFilter.addListener(filterlocate);
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
    searchFilter.removeListener(filterlocate);
    searchFilter.dispose();
    super.dispose();
  }

  void filterlocate() {
    String query = searchFilter.text.toLowerCase();
    setState(() {
      filterLocate = listLocate.where((locate) {
        return locate.cityLocation.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> fetchLocations() async {
    List<Locations> getLocate = await fireS.getAllLocations();
    setState(() {
      listLocate = getLocate.reversed.toList();
      filterLocate = listLocate; // Initialize filtered list with all locations
    });
  }

  void AddBox(double h, double w, {int index = -1}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            index == -1 ? "Add Locations" : "Update Locations",
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
                              if (index == -1) {
                                Locations locate =
                                    Locations(id, addLocCont.text.toString());
                                fireS.addLocations(locate);
                              } else {
                                Locations locate = Locations(
                                  listLocate[index].id,
                                  addLocCont.text.toString(),
                                );
                                fireS.updateLocation(locate);
                              }
                              setState(() {
                                fetchLocations();
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        index == -1
                                            ? "Location '${addLocCont.text}' added successfully :)"
                                            : "Location '${addLocCont.text}' updated successfully :)",
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
                                    index == -1 ? "Add" : "Update",
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

  // void EditLocation(String data, int id){}

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
                Icons.location_on,
                size: size.height / 1.2,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(size.height / 13),
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
                            "Bus Terminal Locations",
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
                                hintText: "Search Locations",
                                hintStyle: GoogleFonts.play(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.height / 2),
                                ),
                              ),
                              onChanged: (String value) {
                                filterlocate();
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
                    SizedBox(height: size.height / 20),
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
                    ):
                    filterLocate.isEmpty
                        ? Expanded(
                          child: Center(
                              child: Text('No Data Found!', style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, fontSize: size.height/20),),
                            ),
                        )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filterLocate.length,
                                itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: (){
                                        addLocCont.text = filterLocate[index].cityLocation;
                                        AddBox(size.height, size.width, index: index);
                                      },
                                      leading: Icon(Icons.location_on),
                                      title: Text(filterLocate[index].cityLocation, style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, fontSize: size.height/36),),
                                      trailing: IconButton(onPressed: (){
                                        fireS.deleteLocations(filterLocate[index].id);
                                        fetchLocations();
                                        setState(() {
                                        });

                                      }, icon: Icon(Icons.delete, color: Colors.red,)),
                                    ),
                                    Divider(thickness: 1, color: Colors.white30),
                                  ],
                                );
                                })),
                  ],
                ),
                Positioned(
                  bottom: size.width / 150,
                  right: size.width / 350,
                  child: FloatingActionButton(
                    onPressed: () {
                      addLocCont.clear();
                      AddBox(size.height, size.width);
                    },
                    child: Icon(
                      Icons.add,
                      size: size.height / 12,
                    ),
                    backgroundColor: CupertinoColors.activeBlue,
                    elevation: 0,
                    tooltip: "Add a new location",
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
