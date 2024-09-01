import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import '../All_Classes.dart';
import '../fireStore.dart';
import 'TicketDetailsAdmin.dart';
import 'dropDown.dart';

class BusPassenger extends StatefulWidget {
  const BusPassenger({super.key});

  @override
  State<BusPassenger> createState() => _BusPassengerState();
}

class _BusPassengerState extends State<BusPassenger> {
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

  // Ticket List
  List<Bus> tickets = [];
  List<Bus> filteredTickets = [];
  Future<void> fetchTickets() async {
    List<Bus> getLocate = await firestoreService.getAllTickets();
    setState(() {
      tickets = getLocate.reversed.toList();
      filteredTickets = tickets;
    });
  }


  List<Passenger> passengerList = [];


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
  void initState() {
    super.initState();
    fetchDrivers();
    fetchService();
    fetchTickets();
    _loadDataWithDelay();
    searchFilter.addListener(filterTickets); // Fix the listener to call filterTickets
  }

  @override
  void dispose() {
    searchFilter.removeListener(filterTickets); // Remove the correct listener
    searchFilter.dispose();
    super.dispose();
  }

  Future<void> fetchDrivers() async {
    List<Driver> fetchedDrivers = await firestoreService.getAllDrivers();
    setState(() {
      drivers = fetchedDrivers;
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

  void filterTickets() {
    String query = searchFilter.text.toLowerCase();
    setState(() {
      filteredTickets = tickets.where((tick) {
        return tick.depCity.toLowerCase().contains(query) ||
            tick.destCity.toLowerCase().contains(query) ||
            tick.companyName.toLowerCase().contains(query) ||
            tick.busDriver.name.toLowerCase().contains(query) ||
            tick.departureTime.toLowerCase().contains(query) ||
            tick.depDate.toLowerCase().contains(query) ||
            tick.busNoplate.toLowerCase().contains(query) ||
            tick.busType.toLowerCase().contains(query) ||
            tick.busNoplate.toLowerCase().contains(query);
      }).toList();
    });
    print(filteredTickets[0].destCity);
  }

  void AddBox(double h, double w, Bus bus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: h/1.1,
          child: AlertDialog(
            title: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: h/12,
                            width: h/12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(w),
                              child: Image.network(bus.companyProfile, fit: BoxFit.cover,),
                            ),
                          ),
                          SizedBox(width: w/70,),
                          Text("${bus.companyName}",
                            style: GoogleFonts.play(
                              fontSize: h/20,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
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
                Divider(color: Colors.white24,thickness: 1,)
              ],
            ),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: h,
                  minHeight: h,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Departure City:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.depCity}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Destination City:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.destCity}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bus Type:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.busType}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                      ],
                    ),
                    SizedBox(height: h/50,),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Departure Date:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.depDate}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Destination Time:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.departureTime}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Arrival Time:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.arrivalTime}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                      ],
                    ),
                    SizedBox(height: h/50,),
                    Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ticket Price:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                            Text("${bus.ticketPrice}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                          ],
                        )),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Seats Remain:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                            Text("${bus.remainingSeats}/${bus.seatingCap}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                          ],
                        )),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bus Stops:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                            Text("${bus.stops}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: h/50,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Driver Details", style: GoogleFonts.play(fontSize: h/30,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                          color: CupertinoColors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white, // Color of the underline
                          decorationThickness: 1.0,),),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                    Text("${bus.busDriver.name}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                                  ],
                                )),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("License Id:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.busDriver.licenseId}", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Driving Experience:", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                Text("${bus.busDriver.expYr} Years", style: GoogleFonts.play(fontStyle: FontStyle.italic),),
                              ],
                            )),

                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: h/50,),
                    Row(
                      children: [
                        Text(
                          "Passenger List",
                          style: GoogleFonts.play(
                            fontSize: h / 30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: CupertinoColors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 1.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h/50,),
                    Container(
                      color: Colors.white24,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "  Seat No.",
                              style: GoogleFonts.play(
                                fontSize: h / 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Name",
                              style: GoogleFonts.play(
                                fontSize: h / 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "CNIC",
                              style: GoogleFonts.play(
                                fontSize: h / 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Phone No.",
                              style: GoogleFonts.play(
                                fontSize: h / 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Gender",
                              style: GoogleFonts.play(
                                fontSize: h / 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h/50,),
                    Container(
                      width: double.maxFinite,
                      height: h / 2.5, // Adjust the height as per your design needs
                      child: passengerList.isEmpty
                          ? Text("No Data Found!",style: GoogleFonts.play(fontStyle: FontStyle.italic), )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: passengerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "  ${passengerList[index].seatNo}",
                                    style: GoogleFonts.play(
                                      fontSize: h / 36,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${passengerList[index].name}",
                                    style: GoogleFonts.play(
                                      fontSize: h / 36,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${passengerList[index].CNIC}",
                                    style: GoogleFonts.play(
                                      fontSize: h / 36,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${passengerList[index].phoneNumber}",
                                    style: GoogleFonts.play(
                                      fontSize: h / 36,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${passengerList[index].gender}",
                                    style: GoogleFonts.play(
                                      fontSize: h / 36,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
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
                Icons.airplane_ticket_rounded,
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
            child: Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Bus Tickets",
                        style: GoogleFonts.play(
                          fontSize: size.height / 18,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: size.height /
                            10), // Add some space between title and search bar
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height / 50),
                        child: TextFormField(
                          controller: searchFilter,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.search),
                            ),
                            hintText: "Search Bus",
                            hintStyle: GoogleFonts.play(),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.height / 2),
                            ),
                          ),
                          onChanged: (String value) {
                            filterTickets(); // Update tickets on change
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
                _isDataLoaded?
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                      childAspectRatio: 3.1, // Ratio of child width to height
                    ),
                    itemCount: filteredTickets.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white54,
                          ),
                          borderRadius: BorderRadius.circular(size.width/50),
                        ),
                        child: InkWell(
                          onTap: (){
                            passengerList = filteredTickets[index].passengerList;
                            setState(() {
                              if(passengerList.isNotEmpty){
                                passengerList.sort((a, b) {
                                  int seatNoA = int.tryParse(a.seatNo) ?? 0;
                                  int seatNoB = int.tryParse(b.seatNo) ?? 0;
                                  return seatNoA.compareTo(seatNoB);
                                });
                              }
                            });
                            AddBox(size.height, size.width, filteredTickets[index]);
                            // TickDetailsAdmin(bus: filteredTickets[index],)
                            },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(size.width/50), // Optional: apply rounded corners to the image
                                    image: DecorationImage(
                                      image: NetworkImage(filteredTickets[index].companyProfile),
                                      fit: BoxFit.cover, // Ensures the image fills the entire space
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width/100,),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(size.width/50), bottomLeft: Radius.circular(size.width/50)),
                                          color: Colors.white24,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width/100),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("${filteredTickets[index].depCity} ", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontSize: size.width/60, fontWeight: FontWeight.bold),),
                                            Icon(Icons.arrow_forward_outlined, weight: 2,),
                                            Text(" ${filteredTickets[index].destCity}", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontSize: size.width/60, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.width / 200),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 200),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Bus Type:  ",
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width / 80,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              filteredTickets[index].busType,
                                              style: GoogleFonts.play(
                                                fontSize: size.width / 80,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 200),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Departure Time:  ",
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width / 80,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              filteredTickets[index].departureTime,
                                              style: GoogleFonts.play(
                                                fontSize: size.width / 80,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 200),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Seats Remain:  ",
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width / 80,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${filteredTickets[index].remainingSeats}/${tickets[index].seatingCap}'
                                                  .toString(),
                                              style: GoogleFonts.play(
                                                fontSize: size.width /80,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: size.width / 200),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Text("")),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(size.width/50), bottomRight: Radius.circular(size.width/50)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  CupertinoColors.activeBlue,
                                                  Color(0xFF00009B)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: size.width/100),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Rs. ${filteredTickets[index].ticketPrice} ", style: GoogleFonts.play(fontStyle: FontStyle.italic, fontSize: size.width/60, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ):Expanded(
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
