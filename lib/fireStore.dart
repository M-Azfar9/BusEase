import 'package:cloud_firestore/cloud_firestore.dart';
import 'All_Classes.dart';
import 'UI/Login/SignUp.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Add a driver
  Future<void> addDriver(Driver driver) {
    return db.collection('Drivers').doc(driver.id).set(driver.toMap());
  }

  Future<void> addServices(Services service) {
    return db.collection('Services').doc(service.id).set(service.toMap());
  }

  Future<void> addLocations(Locations locate){
    return db.collection('Locations').doc(locate.id).set(locate.toMap());
  }

  Future<void> addTickets(Bus busAdd){
    return db.collection('Tickets').doc(busAdd.id).set(busAdd.toMap());
  }

  Future<void> addUser(MyUser newUser){
    return db.collection('Users').doc(newUser.id).set(newUser.toMap());
  }

  // Get a list of all drivers
  Future<List<Driver>> getAllDrivers() async {
    QuerySnapshot querySnapshot = await db.collection('Drivers').get();
    return querySnapshot.docs.map((doc) {
      return Driver.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Services>> getAllServices() async {
    QuerySnapshot querySnapshot = await db.collection('Services').get();
    return querySnapshot.docs.map((doc) {
      return Services.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Locations>> getAllLocations() async {
    QuerySnapshot querySnapshot = await db.collection('Locations').get();
    return querySnapshot.docs.map((doc){
      return Locations.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Bus>> getAllTickets() async {
    QuerySnapshot querySnapshot = await db.collection('Tickets').get();
    return querySnapshot.docs.map((doc){
      return Bus.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<MyUser>> getAllUsers() async {
    QuerySnapshot querySnapshot = await db.collection('Users').get();
    return querySnapshot.docs.map((doc){
      return MyUser.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Update a driver
  Future<void> updateDriver(Driver driver) {
    return db.collection('Drivers').doc(driver.id).update(driver.toMap());
  }

  Future<void> updateServices(Services service) {
    return db.collection('Services').doc(service.id).update(service.toMap());
  }

  Future<void> updateLocation(Locations locate){
    return db.collection('Locations').doc(locate.id).update(locate.toMap());
  }

  Future<void> updateTickets(Bus busTicketes){
    return db.collection('Tickets').doc(busTicketes.id).update(busTicketes.toMap());
  }

  Future<void> addPassengerToBusTicket(String busTicketId, Passenger newPassenger) async {
    try {
      // Step 1: Fetch the BusTicket data from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection('Tickets').doc(busTicketId).get();

      if (snapshot.exists) {
        // Step 2: Convert the snapshot to a BusTicket object
        Bus busTicket = Bus.fromMap(snapshot.data()!);

        // Step 3: Add the new Passenger
        busTicket.addPassenger(newPassenger);

        // Step 4: Update the Firestore document with the modified BusTicket
        await db
            .collection('busTickets')
            .doc(busTicketId)
            .update(busTicket.toMap());

        print('Passenger added to BusTicket and Firestore updated successfully.');
      } else {
        print('BusTicket not found.');
      }
    } catch (e) {
      print('Error adding passenger to BusTicket: $e');
    }
  }

  // Delete a driver
  Future<void> deleteDriver(String id) {
    return db.collection('Drivers').doc(id).delete();
  }

  Future<void> deleteServices(String id) {
    return db.collection('Services').doc(id).delete();
  }

  Future<void> deleteLocations(String id){
    return db.collection('Locations').doc(id).delete();
  }

  Future<void> deleteTicket(String id){
    return db.collection('Tickets').doc(id).delete();
  }
}
