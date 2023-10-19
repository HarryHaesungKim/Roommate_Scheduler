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
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfilePage();
}
//Edit profile page
class _EditProfilePage extends State<EditProfile> {

  String userName = "";
  String email = "";
  String password = "";
  String balance = "";
  String income ="";
  String expense = "";
  File? _image;
  String imageURL = "";
  String themeBrightness = "";
  String themeColor = "";
  final picker = ImagePicker();

  //Bug still
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
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
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
  void getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          userName = list['UserName'];
          email = list['Email'];
          password = list['Password'];
          balance = list['Balance'];
          income = list['Income'];
          expense = list['Expense'];
          imageURL = list['imageURL'];
          themeBrightness = list['themeBrightness'];
          themeColor = list['themeColor'];
        });
      }
    }
  }
  Future updateUserData() async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
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
      );
      await FirebaseFirestore.instance.collection("Users").doc(userID).update(
          user.toJson());

  }

  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future <bool> updateEmailAndPassWord(String _email, String _newEmail, String _password, String _newPassWord) async {
    bool success= false;
    var user = await FirebaseAuth.instance.currentUser!;
    final cred = await EmailAuthProvider.credential(email: _email, password: _password);
    await user.reauthenticateWithCredential(cred).then((value) async{
      user.updateEmail(_newEmail);
      user.updatePassword(_newPassWord);
      success = true;
      });
    return success;
  }


  @override
  Widget build(BuildContext context) {
    getUserData();
    return MaterialApp(
        theme: showOption(themeBrightness),
        home: Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: setAppBarColor(themeColor, themeBrightness),
      title: const Text("Edit Profile"),

    ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
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
                               imageURL),
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
                            icon: Icon(Icons.edit),
                          ),
                        )),
                  ],
                ),
              ),
                        SizedBox(height: 50),
                        Form(child: Column(
                          children: [
                            TextFormField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                label:Text("Full Name"),
                                hintText: userName,
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.people),

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: email,
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black,
                                ),
                                label:Text("Email"),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.email,color: Colors.black)

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: _passWordController,
                              decoration: InputDecoration(
                                hintText: password,
                                label:Text("Password"),
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.password,color: Colors.black),

                              ),
                            ),
                            SizedBox(height: 20,),
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
                                  else if (_passWordController.text == password &&
                                      _userNameController.text == userName) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Passwords and UserNames are same"),
                                          );
                                        });
                                  }
                                   else{
                                    updateEmailAndPassWord(email,_emailController.text.trim(),password,_passWordController.text.trim());
                                    updateUserData();
                                    if (mounted) {
                                      setState(() {
                                        userName = _userNameController.text.trim();
                                        password = _passWordController.text.trim();
                                        email = _emailController.text.trim();
                                        balance = balance;
                                        imageURL = imageURL;
                                        themeColor = themeColor;
                                        themeBrightness = themeBrightness;
                                        income = income;
                                        expense = expense;
                                      });
                                    }
                                  }
                                },
                                style:ElevatedButton.styleFrom(
                                    backgroundColor: setAppBarColor(themeColor, themeBrightness),side: BorderSide.none, shape: const StadiumBorder()
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

}



