import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roommates/User/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

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
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future updateUserData(String balance, String income, String expense, String imageURL, String themeBrightness, String themeColor, List<String> chatRooms, GeoPoint? location, String groupID, ) async {
    imageURL = await getImageURL();
    final user = UserData(
      email: _emailController.text.trim(),
      password: _passWordController.text.trim(),
      username: _userNameController.text.trim(),
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
    await FirebaseFirestore.instance.collection("Users").doc(_uID).update(
        user.toJson());

  }

  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future <bool> updateEmailAndPassWord(String email, String newEmail, String password, String newPassWord) async {
    bool success= false;
    var user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred).then((value) async{
      user.updateEmail(newEmail);
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
                                            image: NetworkImage(
                                                UserData['imageURL']),
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
                                      hintText: UserData['UserName'],
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon: const Icon(Icons.people),

                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        hintText: UserData['Email'],
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          color: Colors.black,
                                        ),
                                        label:const Text("Email"),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        prefixIcon: const Icon(Icons.email,color: Colors.black)

                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                    controller: _passWordController,
                                    decoration: InputDecoration(
                                      hintText: UserData['Password'],
                                      label:const Text("Password"),
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon: const Icon(Icons.password,color: Colors.black),

                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: ()  {
                                        if (_passWordController.text.isEmpty || _image==null||
                                            _userNameController.text.isEmpty) {
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
                                          updateEmailAndPassWord(UserData['Email'].toString(),_emailController.text.trim(),UserData['Password'].toString(),_passWordController.text.trim());
                                          updateUserData(UserData['Balance'].toString(),UserData['Income'].toString(),UserData['Expense'].toString(),UserData['imageURL'].toString(),UserData['themeBrightness'].toString(),UserData['themeColor'].toString(), UserData["chatRooms"].cast<String>(), UserData['location'],UserData['groupID'].toString());
                                        }
                                      },
                                      style:ElevatedButton.styleFrom(
                                          backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),side: BorderSide.none, shape: const StadiumBorder()
                                      ) ,
                                      child: const Text(
                                        "Edit Profile",style: TextStyle(color:Colors.white),
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