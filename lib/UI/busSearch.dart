import 'package:bus_ease/UI/ticketDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../All_Classes.dart';
import '../fireStore.dart';
import 'Buttons.dart';

class BusSearch extends StatefulWidget {
  const BusSearch({super.key});

  @override
  State<BusSearch> createState() => _BusSearchState();
}

class _BusSearchState extends State<BusSearch> {
  final firestore = FirebaseFirestore.instance.collection('user').snapshots();
  final auth = FirebaseAuth.instance;
  FirestoreService fireS = FirestoreService();
  List<String> cityLocate = [];
  List<Bus> tickets = [];
  bool isfetch = false;
  bool isSearch = true;

  @override
  void initState() {
    super.initState();
    fetchLocations(); // Sorting the list of countries
  }

  String? fCity;
  String? tCity;
  DateTime? selectedDate;

  DropdownSearch<String> buildDropdownSearch(String labeltxt,
      String hint, String? selectedItem, void Function(String?) onChanged) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintText: 'Search here...',
            hintStyle: GoogleFonts.play(
              fontStyle: FontStyle.italic,
            ),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color:
                isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  item,
                  style: GoogleFonts.play(
                    color: isSelected
                        ? Colors.blue
                        : Colors.black, // Change text color here
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
          );
        },
      ),
      items: cityLocate,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: labeltxt,
          labelStyle: GoogleFonts.play(
              color: Colors.white, fontStyle: FontStyle.italic),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.orange),
          ),
          prefixIcon: Icon(Icons.location_on, color: Colors.white),
        ),
      ),
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem ?? hint,
          style: GoogleFonts.play(
              color: Colors.white, fontStyle: FontStyle.italic),
        );
      },
      dropdownButtonProps: DropdownButtonProps(
        icon: Icon(
          Icons.arrow_drop_down_circle,
          color: Colors.white,
        ),
        splashRadius: 10,
      ),
      itemAsString: (String? item) => item ?? "",
      onChanged: onChanged,
      selectedItem: selectedItem,
    );
  }

  Future<void> fetchLocations() async {
    List<Locations> getLocate = await fireS.getAllLocations();
    setState(() {
      List<Locations> listLocate = getLocate;
      cityLocate = listLocate.map((locate) => locate.cityLocation).toList();
      cityLocate.sort();
    });
  }

  Future<void> fetchTickets(
      String depCity, String destCity, String date) async {
    List<Bus> getLocate = await fireS.getAllTickets();

    setState(() {
      // tickets = getLocate;
      tickets = getLocate
          .where((ticket) =>
              ticket.depDate == date &&
              ticket.depCity == depCity &&
              ticket.destCity == destCity)
          .toList();
      isfetch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: size.height * 0.36,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height:
                            size.height * 0.02), // Add space between dropdowns
                    buildDropdownSearch("Departure City","City From", fCity, (newValue) {
                      setState(() {
                        fCity = newValue;
                      });
                    }),
                    SizedBox(
                        height:
                            size.height * 0.02), // Add space between dropdowns
                    buildDropdownSearch("Destination City","City To", tCity, (newValue) {
                      setState(() {
                        tCity = newValue;
                      });
                    }),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              labelStyle: GoogleFonts.play(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: selectedDate == null
                                  ? "Select Date"
                                  : "${selectedDate!.toLocal()}".split(' ')[0],
                              hintStyle: GoogleFonts.play(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                // fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.05),
                          ),
                          onPressed: () async {
                            selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1999),
                              lastDate: DateTime(2025),
                            );
                            setState(() {});
                          },
                          child: Text(
                            "Pick Date",
                            style: GoogleFonts.play(
                              color: CupertinoColors.activeBlue,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: size.width / 20,
                  left: size.width / 20,
                  top: size.width / 20,),
              child: RoundButton(
                title: 'Search Bus',
                myColor: CupertinoColors.activeBlue,
                onTap: () {
                  isfetch = true;
                  isSearch = false;
                  setState(() {
                  });
                  print(selectedDate.toString().split(' ')[0]);
                  fetchTickets(fCity.toString(), tCity.toString(),
                      selectedDate.toString().split(' ')[0]);
                  if (tickets.isNotEmpty) {
                    print("Not Empty");
                  } else {
                    print("Empty");
                  }
                },
              ),
            ),
            Expanded(
              child: isSearch?Center(
                child: Padding(
                  padding: EdgeInsets.all(size.width/12),
                  child: Text(
                    "Welcome! Please select your departure and destination cities, then choose a date to search for available buses.",
                    style: GoogleFonts.play(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  :isfetch? Center(child: CupertinoActivityIndicator(color: CupertinoColors.black,radius: size.width/10,),) : tickets.isEmpty? Center(
                child: Padding(
                  padding: EdgeInsets.all(size.width/12),
                  child: Text(
                    "No buses available for the selected route and date. Please try a different search.",
                    style: GoogleFonts.play(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  :ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: size.width / 20.0,
                      left: size.width / 40.0,
                      right: size.width / 40.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        final auth = FirebaseAuth.instance;
                        final user = auth.currentUser;
                        print(user?.email);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ticketdetails(ticketBus: tickets[index]),
                          ),
                        );
                      },

                      child: Material(
                        elevation: 6.0, // Adjust the elevation for more or less shadow
                        borderRadius: BorderRadius.circular(size.width / 14),
                        shadowColor: Colors.black.withOpacity(0.5), // Shadow color
                        child: Container(
                          height: size.height / 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size.width / 14),
                            border: Border.all(
                              color: Colors.black45,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.width / 14),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(size.width / 14),
                                  child: Image.network(
                                    tickets[index].companyProfile,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.white24,
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(size.width / 14),
                                          bottomLeft:
                                          Radius.circular(size.width / 14),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${tickets[index].depCity} ',
                                            style: GoogleFonts.play(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: size.width / 20,
                                            color: CupertinoColors.white,
                                          ),
                                          Text(
                                            ' ${tickets[index].destCity}',
                                            style: GoogleFonts.play(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: size.width / 50),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 50),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Bus Type:  ",
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width / 35,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              tickets[index].busType,
                                              style: GoogleFonts.play(
                                                fontSize: size.width / 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 50),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Departure Time:  ",
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width / 35,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              tickets[index].departureTime,
                                              style: GoogleFonts.play(
                                                fontSize: size.width / 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 50),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Seats Remain:  ",
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width / 35,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${tickets[index].remainingSeats}/${tickets[index].seatingCap}'
                                                  .toString(),
                                              style: GoogleFonts.play(
                                                fontSize: size.width / 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: Text("")),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: size.width / 2.5,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              CupertinoColors.activeBlue,
                                              Color(0xFF00009B)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                            Radius.circular(size.width / 14),
                                            bottomRight:
                                            Radius.circular(size.width / 14),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Rs:  ${tickets[index].ticketPrice}/-',
                                              style: GoogleFonts.play(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
