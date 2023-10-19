import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roommates/User/user_model.dart';
import 'package:get/get.dart';
import '../User/user_controller.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;


  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(40.7642, -111.8228), zoom: 14);
  final _userdataController = Get.put(userController());
  final _db = FirebaseFirestore.instance;
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  Set<Marker> markers = {};
  String username = "";
  String password = "";
  String email = "";
  String balance = "";
  String income = "";
  String expense = "";
  String groupID = "";
  List<String>? chatRooms;
  String imageURL = "";
  GeoPoint? location;
  Future getCurrentLocation() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          username = list['UserName'];
          password = list['Password'];
          email = list['Email'];
          balance = list['Balance'];
          income = list['Income'];
          expense = list['Expense'];
          groupID = list['groupID'];
          chatRooms = list['chatRooms'];
          imageURL = list['imageURL'];
          location = list['location'];
        });
      }
    }
  }
  Future updateUserLocation(GeoPoint newlocation) async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    final user = UserData(
      email:email,
      password:password,
      username:username,
      balance:balance,
      income:income,
      expense:expense,
      groupID:groupID,
      chatRooms:chatRooms,
      imageURL:imageURL,
      location:newlocation,
    );
    await FirebaseFirestore.instance.collection("Users").doc(userID).update(user.toJson());
  }
  Future<String> getGroupID(String uID) async
  {

    final docref = await _db.collection('Users').doc(uID).get();
    String gID = docref.data()?['groupID'];
    return gID;
  }
  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
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
                child:Icon(
                  Icons.my_location,
                ),
                backgroundColor: Colors.orange[700],
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () async {
                  Position position = await _determinePosition();
                  getCurrentLocation();
                  updateUserLocation(GeoPoint(position.latitude as double, position.longitude as double));
                  groupID = await getGroupID(uID!);
                  //_userdataController.getUserData(groupID);
                  _userdataController.getUserLocation(uID!);
                  markers.clear();
                  for(int i = 0; i < _userdataController.userLocationList.length; i++){
                    String id = "User" + i.toString();
                    print(_userdataController.userLocationList[i].latitude);
                    markers.add(Marker(markerId: MarkerId(id),position: LatLng(_userdataController.userLocationList[i].latitude, _userdataController.userLocationList[i].longitude)));
                  }
                  print(markers.length);
                  setState(() {});
                },
                child:Icon(
                  Icons.share_location,
                ),
                backgroundColor: Colors.orange[700],
              ),
            ]
        ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     Position position = await _determinePosition();
      //
      //     googleMapController
      //         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));
      //
      //     markers.clear();
      //
      //     markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));
      //
      //     setState(() {});
      //
      //   },
      //   label: const Text("Current Location"),
      //   icon: const Icon(Icons.my_location),
      //   backgroundColor: Colors.orange[700],
      // ),floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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