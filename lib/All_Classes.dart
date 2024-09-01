class Services {
  String id;
  String serviceName;
  String regNumber;
  String CustomerSerPhoneNo;
  String OfficialEmail;
  String headOffice;
  String logo;

  // Constructor
  Services(
      this.id,
      this.serviceName,
      this.regNumber,
      this.OfficialEmail,
      this.CustomerSerPhoneNo,
      this.headOffice,
      this.logo,
      );

  // Method to convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'regNumber': regNumber,
      'CustomerSerPhoneNo': CustomerSerPhoneNo,
      'OfficialEmail': OfficialEmail,
      'headOffice': headOffice,
      'logo': logo,
    };
  }

  // Factory constructor to create an instance from a map
  factory Services.fromMap(Map<String, dynamic> map) {
    return Services(
      map['id'] ?? '',
      map['serviceName'] ?? '',
      map['regNumber'] ?? '',
      map['CustomerSerPhoneNo'] ?? '',
      map['OfficialEmail'] ?? '',
      map['headOffice'] ?? '',
      map['logo'] ?? '',
    );
  }
}
class Locations{
  String cityLocation;
  String id;
  Locations(this.id, this.cityLocation);

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'cityLocation' : cityLocation,
    };
  }

  factory Locations.fromMap(Map<String, dynamic> map){
    return Locations(
      map['id'] ?? '',
      map['cityLocation'] ?? '',
    );
  }
}


class Passenger {
  String id;
  String name;
  String CNIC;
  String phoneNumber;
  String email;
  String gender;
  String seatNo;
  String totalSeat;
  String totalTicketPrice;
  bool confirmSeat = false;

  Passenger(this.id, this.name, this.CNIC, this.phoneNumber, this.email, this.gender, this.seatNo, this.totalSeat, this.totalTicketPrice, this.confirmSeat);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'CNIC': CNIC,
      'phoneNumber': phoneNumber,
      'email': email,
      'gender': gender,
      'seatNo': seatNo,
      'totalSeat': totalSeat,
      'totalTicketPrice': totalTicketPrice,
      'confirmSeat': confirmSeat,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      map['id'] ?? '',
      map['name'] ?? '',
      map['CNIC'] ?? '',
      map['phoneNumber'] ?? '',
      map['email'] ?? '',
      map['gender'] ?? '',
      map['seatNo'] ?? '',
      map['totalSeat'] ?? '',
      map['totalTicketPrice'] ?? '',
      map['confirmSeat'] ?? true,
    );
  }
}


class Driver {
  String id;
  String name;
  String licenseId;
  String expYr;
  String service;

  Driver(this.id, this.name, this.licenseId, this.expYr, this.service);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dirverName': name,
      'licenseId': licenseId,
      'ExperienceYear': expYr,
      'service': service,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      map['id'] ?? '',
      map['dirverName'] ?? '',
      map['licenseId'] ?? '',
      map['ExperienceYear'] ?? '',
      map['service'] ?? '',
    );
  }
}

class Bus {
  String id;
  String companyName;
  String companyProfile;
  String busNoplate;
  int seatingCap;
  int remainingSeats;
  String busType;
  String departureTime;
  String arrivalTime;
  String depDate;
  String depCity;
  String destCity;
  String ticketPrice;
  List<String> stops;
  Driver busDriver;
  List<Passenger> passengerList;
  Seats busSeats;

  Bus(
      this.id,
      this.busDriver,
      this.companyProfile,
      this.companyName,
      this.busNoplate,
      this.busType,
      this.departureTime,
      this.arrivalTime,
      this.depDate,
      this.depCity,
      this.destCity,
      this.ticketPrice,
      this.stops,
      this.passengerList,
      this.busSeats, {
        this.seatingCap = 40,
      }) : remainingSeats = seatingCap - passengerList.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'companyProfile': companyProfile,
      'busNoplate': busNoplate,
      'seatingCap': seatingCap,
      'remainingSeats': remainingSeats,
      'busType': busType,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'depDate': depDate,
      'depCity': depCity,
      'destCity': destCity,
      'ticketPrice': ticketPrice,
      'stops': stops,
      'busDriver': busDriver.toMap(),
      'passengerList': passengerList.map((passenger) => passenger.toMap()).toList(),
      'busSeats': busSeats.toMap(),
    };
  }

  factory Bus.fromMap(Map<String, dynamic> map) {
    return Bus(
      map['id'] ?? '',
      Driver.fromMap(map['busDriver'] ?? {}),
      map['companyProfile'] ?? '',
      map['companyName'] ?? '',
      map['busNoplate'] ?? '',
      map['busType'] ?? '',
      map['departureTime'] ?? '',
      map['arrivalTime'] ?? '',
      map['depDate'] ?? '',
      map['depCity'] ?? '',
      map['destCity'] ?? '',
      map['ticketPrice'] ?? '',
      List<String>.from(map['stops'] ?? []),
      List<Passenger>.from(
        (map['passengerList'] ?? []).map((item) => Passenger.fromMap(item)),
      ),
      Seats.fromMap(map['busSeats'] ?? {}),
      seatingCap: map['seatingCap'] ?? 40,
    );
  }

  void addPassenger(Passenger passenger) {
    if (remainingSeats > 0) {
      passengerList.add(passenger);
      remainingSeats--; // Decrease the number of remaining seats
      print("Passenger added successfully. Remaining seats: $remainingSeats");
    } else {
      print("No remaining seats available.");
    }
  }
}

class Seats {
  String id;
  String s4 = "_4";
  String s3 = "_3";
  String se1 = "";
  String s2 = "_2";
  String s1 = "_1";
  String s8 = "_8";
  String s7 = "_7";
  String se2 = "";
  String s6 = "_6";
  String s5 = "_5";

  String s12 = "_12";
  String s11 = "_11";
  String se3 = "";
  String s10 = "_10";
  String s9 = "_9";
  String s16 = "_16";
  String s15 = "_15";
  String se4 = "";
  String s14 = "_14";
  String s13 = "_13";

  String s20 = "_20";
  String s19 = "_19";
  String se5 = "";
  String s18 = "_18";
  String s17 = "_17";
  String s24 = "_24";
  String s23 = "_23";
  String se6 = "";
  String s22 = "_22";
  String s21 = "_21";

  String s28 = "_28";
  String s27 = "_27";
  String se7 = "";
  String s26 = "_26";
  String s25 = "_25";
  String s32 = "_32";
  String s31 = "_31";
  String se8 = "";
  String s30 = "_30";
  String s29 = "_29";
  String s36 = "_36";
  String s35 = "_35";
  String se9 = "";
  String s34 = "_34";
  String s33 = "_33";
  String s40 = "_40";
  String s39 = "_39";
  String se10 = "";
  String s38 = "_38";
  String s37 = "_37";

  List<String> seatButton = [];

  Seats(this.id) {
    _initializeSeats();
  }

  void _initializeSeats() {
    seatButton = [
      s4, s3, se1, s2, s1, s8, s7, se2, s6, s5, // First Row
      s12, s11, se3, s10, s9, s16, s15, se4, s14, s13, // Second Row
      s20, s19, se5, s18, s17, s24, s23, se6, s22, s21, // Third Row
      s28, s27, se7, s26, s25, s32, s31, se8, s30, s29, // Fourth Row
      s36, s35, se9, s34, s33, s40, s39, se10, s38, s37 // Fifth Row
    ];
  }

  // Convert Seats object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      's4': s4,
      's3': s3,
      'se1': se1,
      's2': s2,
      's1': s1,
      's8': s8,
      's7': s7,
      'se2': se2,
      's6': s6,
      's5': s5,
      's12': s12,
      's11': s11,
      'se3': se3,
      's10': s10,
      's9': s9,
      's16': s16,
      's15': s15,
      'se4': se4,
      's14': s14,
      's13': s13,
      's20': s20,
      's19': s19,
      'se5': se5,
      's18': s18,
      's17': s17,
      's24': s24,
      's23': s23,
      'se6': se6,
      's22': s22,
      's21': s21,
      's28': s28,
      's27': s27,
      'se7': se7,
      's26': s26,
      's25': s25,
      's32': s32,
      's31': s31,
      'se8': se8,
      's30': s30,
      's29': s29,
      's36': s36,
      's35': s35,
      'se9': se9,
      's34': s34,
      's33': s33,
      's40': s40,
      's39': s39,
      'se10': se10,
      's38': s38,
      's37': s37,
      'seatButton': seatButton,
    };
  }

  // Create a Seats object from a map
  factory Seats.fromMap(Map<String, dynamic> map) {
    var seats = Seats(map['id'] ?? '');
    seats.s4 = map['s4'] ?? '';
    seats.s3 = map['s3'] ?? '';
    seats.se1 = map['se1'] ?? '';
    seats.s2 = map['s2'] ?? '';
    seats.s1 = map['s1'] ?? '';
    seats.s8 = map['s8'] ?? '';
    seats.s7 = map['s7'] ?? '';
    seats.se2 = map['se2'] ?? '';
    seats.s6 = map['s6'] ?? '';
    seats.s5 = map['s5'] ?? '';
    seats.s12 = map['s12'] ?? '';
    seats.s11 = map['s11'] ?? '';
    seats.se3 = map['se3'] ?? '';
    seats.s10 = map['s10'] ?? '';
    seats.s9 = map['s9'] ?? '';
    seats.s16 = map['s16'] ?? '';
    seats.s15 = map['s15'] ?? '';
    seats.se4 = map['se4'] ?? '';
    seats.s14 = map['s14'] ?? '';
    seats.s13 = map['s13'] ?? '';
    seats.s20 = map['s20'] ?? '';
    seats.s19 = map['s19'] ?? '';
    seats.se5 = map['se5'] ?? '';
    seats.s18 = map['s18'] ?? '';
    seats.s17 = map['s17'] ?? '';
    seats.s24 = map['s24'] ?? '';
    seats.s23 = map['s23'] ?? '';
    seats.se6 = map['se6'] ?? '';
    seats.s22 = map['s22'] ?? '';
    seats.s21 = map['s21'] ?? '';
    seats.s28 = map['s28'] ?? '';
    seats.s27 = map['s27'] ?? '';
    seats.se7 = map['se7'] ?? '';
    seats.s26 = map['s26'] ?? '';
    seats.s25 = map['s25'] ?? '';
    seats.s32 = map['s32'] ?? '';
    seats.s31 = map['s31'] ?? '';
    seats.se8 = map['se8'] ?? '';
    seats.s30 = map['s30'] ?? '';
    seats.s29 = map['s29'] ?? '';
    seats.s36 = map['s36'] ?? '';
    seats.s35 = map['s35'] ?? '';
    seats.se9 = map['se9'] ?? '';
    seats.s34 = map['s34'] ?? '';
    seats.s33 = map['s33'] ?? '';
    seats.s40 = map['s40'] ?? '';
    seats.s39 = map['s39'] ?? '';
    seats.se10 = map['se10'] ?? '';
    seats.s38 = map['s38'] ?? '';
    seats.s37 = map['s37'] ?? '';
    seats.seatButton = List<String>.from(map['seatButton'] ?? []);
    return seats;
  }
}


