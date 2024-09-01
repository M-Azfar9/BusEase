import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final TextEditingController _busStopController = TextEditingController();

  @override
  void dispose() {
    _busStopController.dispose();
    super.dispose();
  }

  void _addBusStop() {
    String newStop = _busStopController.text.trim();
    if (newStop.isNotEmpty && !busStops.contains(newStop)) {
      setState(() {
        busStops.add(newStop);
        _busStopController.clear();
      });
    } else {
      // Show a snackbar if the input is empty or the stop already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Invalid input or bus stop already exists",
            style: GoogleFonts.play(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
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
              opacity: 0.1,
              child: Icon(
                Icons.directions_bus,
                size: size.height / 1.2,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
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
                Divider(thickness: 2, color: Colors.white24),
                SizedBox(height: size.height / 20),
                // Your existing form fields...
                SizedBox(height: size.height / 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.height / 40),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(size.height / 40),
                            topLeft: Radius.circular(size.height / 40),
                          ),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.height / 20,
                            vertical: size.height / 70,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Add Bus Stops:",
                              style: GoogleFonts.play(
                                fontSize: size.height / 27,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.height / 50),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _busStopController,
                                decoration: InputDecoration(
                                  hintText: "Enter Bus Stop Name",
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
                            SizedBox(width: size.width * 0.03),
                            SizedBox(
                              height: size.height / 11,
                              child: ElevatedButton(
                                onPressed: _addBusStop,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CupertinoColors.activeBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        size.height / 40),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.015,
                                    horizontal: size.width * 0.03,
                                  ),
                                ),
                                child: Icon(Icons.add, size: size.height / 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 2, color: Colors.white24),
                      SizedBox(
                        height: size.height / 2.5,
                        child: ListView.builder(
                          itemCount: busStops.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                setState(() {
                                  busStops.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Bus stop removed",
                                      style: GoogleFonts.play(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: size.height / 50),
                                    child: Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(busStops[index]),
                                trailing: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      busStops.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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

  Widget SelectBus(String txt, double h) {
    return Expanded(
      child: RadioListTile(
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
