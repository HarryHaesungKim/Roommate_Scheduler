import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:roommates/User/user_model.dart';
import 'package:get/get.dart';
import '../Group/groupController.dart';
import '../User/user_controller.dart';
import '../themeData.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;
  late Future<String> futureCurrGroup;
  late bool gotIsGroupAdmin;
  late Future<bool> isGroupAdmin;
  final groupController groupCon = groupController();
  String currGroup = '';


  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(40.7642, -111.8228), zoom: 14);
  final _userdataController = Get.put(userController());
  final _db = FirebaseFirestore.instance;
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  Set<Marker> markers = {};
  Future<String> getGroupID(String uID) async
  {

    final docref = await _db.collection('Users').doc(uID).get();
    String gID = docref.data()?['groupID'];
    return gID;
  }
  @override
  void initState() {
    super.initState();
    futureCurrGroup = groupCon.getGroupIDFromUser(uID!);
    isGroupAdmin = groupCon.isGroupAdminModeByID(uID!);
  }
  // comment List<String> chatRooms
  // Future updateUserData(String email, String password, String username, String balance, String income, String expense, String imageURL, String themeBrightness, String themeColor, GeoPoint? location, String groupID, ) async {
  //   final user = UserData(
  //     email: email,
  //     password: password,
  //     username: username,
  //     balance: balance,
  //     income: income,
  //     expense: expense,
  //     imageURL: imageURL,
  //     themeBrightness: themeBrightness,
  //     themeColor: themeColor,
  //     groupID: groupID,
  //     //chatRooms: chatRooms,
  //     location: location,
  //   );
  //   await FirebaseFirestore.instance.collection("Users").doc(uID).update(
  //       user.toJson());
  // }
  Future updateUserData(GeoPoint? location) async {
    await  FirebaseFirestore.instance
        .collection('Users')
        .doc(uID)
        .update({'location': location});
  }
  Future<void> dispose() async {
    // TODO: implement dispose
    super.dispose();
    await _clearLocation();
  }
   _clearLocation() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uID)
        .update({'location': null});
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([futureCurrGroup, isGroupAdmin]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if (snapshot.hasData){
            currGroup = snapshot.data[0];
            gotIsGroupAdmin = snapshot.data[1];
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users').where("groupID", isEqualTo: currGroup)
                  .snapshots(),
                builder: (context, snapshot1){
                  if (snapshot1.hasError){
                    return Text('Something went wrong! ${snapshot1.data}');
                  }
                  else if (snapshot1.hasData){
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(uID)
                          .snapshots(),
                        builder: (context, snapshot2){
                          if (snapshot2.hasError){
                            return Text('Something went wrong! ${snapshot2.data}');
                          }
                          else if (snapshot2.hasData){
                            final UserData = snapshot2.data!;
                            final AllUserData = snapshot1.data!;
                            return Scaffold(
                              appBar: AppBar(
                                backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                title: const Text("Location"),
                              ),
                              body: GoogleMap(
                                initialCameraPosition: initialCameraPosition,
                                markers: markers,
                                zoomControlsEnabled: true,
                                myLocationEnabled: true,
                                mapType: MapType.normal,
                                compassEnabled: true,
                                onMapCreated: (GoogleMapController controller) {
                                  googleMapController = controller;
                                },
                              ),
                              floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
                              floatingActionButton: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:[
                                    FloatingActionButton.extended(
                                      heroTag: "btn1",
                                      onPressed: () async {
                                        Position position = await _determinePosition();

                                        googleMapController
                                            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

                                        markers.clear();

                                        markers.addLabelMarker(LabelMarker(
                                          markerId: const MarkerId('currentLocation'),
                                          label: "My Current Location",
                                          position: LatLng(position.latitude, position.longitude
                                          ),
                                          infoWindow: InfoWindow(
                                          title: 'My Current Location',
                                        ),));

                                        setState(() {});
                                      },
                                      backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                      label: Text('My Location    '),
                                      icon: Icon(Icons.my_location),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FloatingActionButton.extended(
                                      heroTag: "btn2",
                                      onPressed: () async {
                                        Position position = await _determinePosition();
                                        // updateUserData(UserData['Email'], UserData['Password'], UserData['UserName'], UserData['Balance'].toString(),UserData['Income'].toString(),
                                        //     UserData['Expense'].toString(),UserData['imageURL'].toString(),
                                        //     UserData['themeBrightness'].toString(),UserData['themeColor'].toString(),
                                        //     GeoPoint(position.latitude, position.longitude),UserData['groupID'].toString());
                                        updateUserData(GeoPoint(position.latitude, position.longitude));
                                        //_userdataController.getUserLocation(uID!);
                                        googleMapController
                                            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 10)));
                                        markers.clear();
                                        for(int i = 0; i < AllUserData.docs.length; i++){
                                          String id = "User$i";
                                          if(AllUserData.docs[i]["location"].runtimeType == GeoPoint){
                                            markers.addLabelMarker(LabelMarker(
                                                markerId: MarkerId(id),
                                                position: LatLng(AllUserData.docs[i]["location"].latitude, AllUserData.docs[i]["location"].longitude),
                                                label: AllUserData.docs[i]["UserName"]));
                                          }

                                        }
                                        setState(() {});
                                      },
                                      backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                      label: Text('Share Location'),
                                      icon: Icon(Icons.share_location),
                                    ),
                                  ]
                              ),
                            );
                          }
                          else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    );
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
            );
          }
          else if (snapshot.hasError){
            return Text("Something went wrong! ${snapshot.error}");
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}