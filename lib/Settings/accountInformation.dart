import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roommates/User/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../LoginPage.dart';
import '../themeData.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfilePage();
}
//Edit profile page
class _EditProfilePage extends State<EditProfile> {
  final _uID = FirebaseAuth.instance.currentUser?.uid;
  File? _image;
  bool isClicked = false;
 String name = "";
  String password = "";
  final picker = ImagePicker();

  Future<String> getImageURL() async {
    String url = "";
    if(_image?.path!=null) {
      Reference referenceDirImages = FirebaseStorage.instance.ref().child(
          'images');
//Create a unique name
      String uniqueFileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
//Create a reference for the image to be stored
      Reference referenceImageUpload = referenceDirImages.child(uniqueFileName);
//Store the file
      //Handle the error
      try {
        await referenceImageUpload.putFile(File(_image!.path));
        url = await referenceImageUpload.getDownloadURL();
      }
      catch(error){
        print("ALSIJLSKDJLKSJDLNSKFLNKNKLQJWLQJPINASLNX!");
      }
    }
    return url;
  }


  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (file != null) {
        _image = File(file.path);

      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

      }
    });
  }
  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              isClicked = true;
              name = _userNameController.text.trim();
              password = _passWordController.text.trim();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              isClicked = true;
              name = _userNameController.text.trim();
              password = _passWordController.text.trim();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future updateUserData(String email,String balance, String income, String expense, String imageURL, String themeBrightness, String themeColor, GeoPoint? location, String groupID, ) async {
    imageURL = await getImageURL();
    final user = UserData(
      email: email,
      password: _passWordController.text.trim(),
      username: _userNameController.text.trim(),
      balance: balance,
      income: income,
      expense: expense,
      imageURL: imageURL,
      themeBrightness: themeBrightness,
      themeColor: themeColor,
      groupID: groupID,
      //chatRooms: chatRooms,
      location: location,
    );
    await FirebaseFirestore.instance.collection("Users").doc(_uID).update(
        user.toJson());

  }

  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future <bool> updatePassWord(String email, String password, String newPassWord) async {
    bool success= false;
    var user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred).then((value) async{
      user.updatePassword(newPassWord);
      success = true;
    });
    return success;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // If there's no error and the snapshot has data.
        if (snapshot.hasData) {

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(_uID)
                .snapshots(),
            builder: (context, snapshot) {
              // If there's an error.
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.data}');
              }
              // If there's no error and the snapshot has data.
              else if (snapshot.hasData) {
                // Setting the task data.
                final UserData = snapshot.data!;
                if(isClicked){
                  _userNameController.text =  name;
                  _passWordController.text = password;
                }else{
                  _userNameController.text =  UserData['UserName'];
                  _passWordController.text = UserData['Password'];
                }


                //controller
                return MaterialApp(
                    theme: showOption(UserData['themeBrightness']),
                    home: Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(UserData['themeBrightness'])),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                        title: const Text("Edit Profile"),

                      ),
                      body: Container(
                        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: ListView(
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    _image != null?
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 4, color: Colors.white),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                color: Colors.black.withOpacity(0.1))
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:FileImage(
                                                _image!
                                            ),
                                          )),
                                    ):
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 4, color: Colors.white),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                color: Colors.black.withOpacity(0.1))
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(UserData['imageURL']),
                                          )),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 4,
                                                color: Colors.white,
                                              ),
                                              color: Colors.blue),
                                          child: IconButton(
                                            onPressed: showOptions,
                                            icon: const Icon(Icons.edit),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50),
                              Form(child: Column(
                                children: [
                                  TextFormField(
                                    controller: _userNameController,
                                    decoration: InputDecoration(
                                      label:const Text("Full Name"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon: const Icon(Icons.people),

                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                    controller: _passWordController,
                                    decoration: InputDecoration(
                                      label:const Text("Password"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon: const Icon(Icons.password,color: Colors.black),

                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: ()  {
                                        if (_passWordController.text.isEmpty || _userNameController.text.isEmpty) {
                                          Get.snackbar(
                                            "Required",
                                            "All fields are required.",
                                            snackPosition: SnackPosition.TOP,
                                          );
                                        }
                                        else if (_passWordController.text == UserData['Password'] &&
                                            _userNameController.text ==  UserData['UserName']) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const AlertDialog(
                                                  content: Text(
                                                      "Passwords and UserNames are same"),
                                                );
                                              });
                                        }
                                        else{
                                          updatePassWord(UserData['Email'].toString(),UserData['Password'].toString(),_passWordController.text.trim());
                                          updateUserData(UserData['Email'].toString(),UserData['Balance'].toString(),UserData['Income'].toString(),UserData['Expense'].toString(),UserData['imageURL'].toString(),UserData['themeBrightness'].toString(),UserData['themeColor'].toString(),  UserData['location'],UserData['groupID'].toString());
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => const LoginPage()));


                                        }
                                      },
                                      style:ElevatedButton.styleFrom(
                                          backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),side: BorderSide.none, shape: const StadiumBorder()
                                      ) ,
                                      child: const Text(
                                        "Save",style: TextStyle(color:Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                );
              }
              // Loading.
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },

          );
        }
        // If there's an error.
        else if (snapshot.hasError) {
          return Text("Something went wrong! ${snapshot.error}");
        }

        // Loading.
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
