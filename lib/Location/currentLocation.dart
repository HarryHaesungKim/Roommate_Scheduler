import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  Future updateUserData(String email, String password, String username, String balance, String income, String expense, String imageURL, String themeBrightness, String themeColor, List<String> chatRooms, GeoPoint? location, String groupID, ) async {
    final user = UserData(
      email: email,
      password: password,
      username: username,
      balance: balance,
      income: income,
      expense: expense,
      imageURL: imageURL,
      themeBrightness: themeBrightness,
      themeColor: themeColor,
      groupID: groupID,
      chatRooms: chatRooms,
      location: location,
    );
    await FirebaseFirestore.instance.collection("Users").doc(uID).update(
        user.toJson());
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
                  .collection('Users')
                  .doc(uID)
                  .snapshots(),
                builder: (context, snapshot){
                  if (snapshot.hasError){
                    return Text('Something went wrong! ${snapshot.data}');
                  }
                  else if (snapshot.hasData){
                    final UserData = snapshot.data!;
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                        title: const Text("User current location"),
                        centerTitle: true,
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
                            FloatingActionButton(
                              onPressed: () async {
                                Position position = await _determinePosition();

                                googleMapController
                                    .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

                                markers.clear();

                                markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

                                setState(() {});
                              },
                              backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                              child:const Icon(
                                Icons.my_location,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                Position position = await _determinePosition();
                                updateUserData(UserData['Email'], UserData['Password'], UserData['UserName'], UserData['Balance'].toString(),UserData['Income'].toString(),
                                    UserData['Expense'].toString(),UserData['imageURL'].toString(),
                                    UserData['themeBrightness'].toString(),UserData['themeColor'].toString(),
                                    UserData["chatRooms"].cast<String>(), GeoPoint(position.latitude, position.longitude),UserData['groupID'].toString());
                                //_userdataController.getUserData(groupID);
                                _userdataController.getUserLocation(uID!);
                                markers.clear();
                                for(int i = 0; i < _userdataController.userLocationList.length; i++){
                                  String id = "User$i";
                                  print(_userdataController.userLocationList[i].latitude);
                                  markers.add(Marker(markerId: MarkerId(id),position: LatLng(_userdataController.userLocationList[i].latitude, _userdataController.userLocationList[i].longitude)));
                                }
                                print(markers.length);
                                setState(() {});
                              },
                              backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                              child:const Icon(
                                Icons.share_location,
                              ),
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