import 'package:bus_ease/All_Classes.dart';
import 'package:bus_ease/UI/busSearch.dart';
import 'package:bus_ease/web/LoginWeb.dart';
import 'package:bus_ease/web/TicketDetailsAdmin.dart';
import 'package:bus_ease/web/WebDashBoard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'UI/BusSeats.dart';
import 'UI/Buttons.dart';
import 'UI/Login/LoginScreen.dart';
import 'UI/Login/SignUp.dart';
import 'UI/ServiceDetail.dart';
import 'UI/Splash/SplashScreen.dart';
import 'UI/aboutUs.dart';
import 'fireStore.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // This will only run for web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDFhdomD4yf_AD6bDFPToUxbbN1gRPY70U",
        appId: "1:991402422958:web:420ed49b382dfb4416f33f",
        projectId: "bus-ease-cf06b",
        messagingSenderId: "991402422958",
      ),
    );
  } else {
    // This will run for mobile or other platforms
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMob = size.width < size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
        theme: isMob?
      ThemeData(
        primaryColor: CupertinoColors.activeBlue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CupertinoColors.activeBlue,
        ),
      ):ThemeData.dark(),
      // theme: ThemeData.dark(),
      // darkTheme: ThemeData.light(),
      // home: isMob? SplashScreen() : WebDashBoard(),
      home: LoginWeb(),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;

  final List<String> busList = [
    'assets/bus1.jpg',
    'assets/bus2.jpg',
    'assets/bus3.jpg',
    'assets/bus4.jpg',
    'assets/bus5.jpg',
    'assets/bus6.jpg',
    'assets/bus7.jpg',
    'assets/bus8.jpg',
    'assets/bus9.jpg',
    'assets/bus10.jpg',
    'assets/bus11.jpg',
    'assets/bus12.jpg',
  ];

  List<String> serList = [];
  List<Services> serviceList = [];
  FirestoreService fireS = FirestoreService();

  MyUser? currentUser;

  @override
  void initState() {
    fetchService();
    fetchUser();// Sorting the list of countries
    super.initState();
  }

  Future<void> fetchService() async {
    List<Services> getService = await fireS.getAllServices();
    setState(() {
      serviceList = getService;
      serList = getService.map((serve) => serve.logo).toList();
    });
  }

  Future<void> fetchUser() async {
    List<MyUser> getService = await fireS.getAllUsers();
    setState(() {
      final user = auth.currentUser;
      final userId = user?.email;
      currentUser = getService.firstWhere((serve) => serve.email == userId);
    });
  }


  void onImageTap(BuildContext context, int index) {
    String logo = serList.elementAt(index);
    Services serviceSelect = serviceList.firstWhere((test) => test.logo == logo);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServiceDetail(service: serviceSelect)),
        );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginscreen()),
    );
  }

  Future<bool?> exit(BuildContext context, double w) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit:",style: GoogleFonts.play(
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
              Text("Do you want to exit?",style: GoogleFonts.play(
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async{
        return await exit(context, size.width) ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    Opacity(opacity: 0.5,
                    child: Icon(Icons.account_box, size: size.width/3,color: Colors.white,)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentUser?.name}',
                            style: GoogleFonts.play(color: Colors.white, fontSize: size.width/20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Email: ${currentUser?.email}',
                            style: GoogleFonts.play(color: Colors.white, fontSize: size.width/30, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(size.width/10)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('About Us'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
                },
              ),
              ListTile(
                leading: Icon(Icons.output_sharp),
                title: Text('Logout'),
                onTap: () => logout(context),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: size.height / 4.5,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [CupertinoColors.activeBlue, Color(0xFF00009B)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width/10),
                    bottomRight: Radius.circular(size.width/10)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // height: size.height / 7,
                    height: size.height/4,
                    width: size.width/2.1,
                    // width: size.width,
                    child: Lottie.asset("assets/animations/bus8.json",
                        width: size.width/5, height: size.height/8),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("WELCOME TO",
                          style: GoogleFonts.play(
                              color: CupertinoColors.white,
                              fontSize: size.width/18,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic)),
                      Text("BusE@se",
                          style: GoogleFonts.play(
                              color: CupertinoColors.white,
                              fontSize: size.width/15,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width/20),
              child: RoundButton(
                title: 'Ticket Booking',
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: BusSearch(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                myColor: CupertinoColors.activeBlue,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width/20),
                  child: Text("Our Services:",style: GoogleFonts.play(fontStyle: FontStyle.italic, fontSize: size.width/21, fontWeight: FontWeight.bold)),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: size.height/5.7,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: serList.asMap().entries.map((entry) {
                    int index = entry.key;
                    String item = entry.value;
                    return GestureDetector(
                      onTap: () {
                        print(index);
                        onImageTap(context, index);
                        },
                      child: Container(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                size.width/16), // Adjust the radius as needed
                            child: Image.network(item, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: size.width/16,),
                Padding(
                  padding: EdgeInsets.all(size.width/20),
                  child: Text("Instant Bookings:",style: GoogleFonts.play(fontStyle: FontStyle.italic, fontSize: size.width/21, fontWeight: FontWeight.bold)),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: size.height/5.7,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: busList.asMap().entries.map((entry) {
                    int index = entry.key;
                    String item = entry.value;
                    return GestureDetector(
                      onTap: () => onImageTap(context, index),
                      child: Container(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                size.width/16), // Adjust the radius as needed
                            child: Image.asset(item, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Book Tickets
// View bus Tickets
// Bus management
// Add Bus
// View Passenger acc to bus
// View Today Buses
// Add Bus Terminals
// Customer List
// Passenger History
// Drivers
// Add Driver
// Driver Details


// --web-renderer html
