import 'dart:io';

import 'package:chat/models/user_model.dart';
import 'package:chat/widgets/big_text.dart';
import 'package:chat/widgets/small_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File? image;
  final picker = ImagePicker();
  User? user;
  UserModel? userModel;
  DatabaseReference? userRef;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  TextEditingController UserNameTextController = TextEditingController();

  _getUserDetails() async {
    DataSnapshot snapshot = (await userRef!.once()) as DataSnapshot;

    var snapshots;
    userModel = UserModel.fromMap(Map<String, dynamic>.from(snapshots.value));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef =
          FirebaseDatabase.instance.reference().child('users').child(user!.uid);
    }

    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Positioned(
                  top: 97,
                  left: 158,
                  right: 170,
                  child: BigText(text: "Chat App"),
                ),
              ),
              const SizedBox(height: 137 // Dimensions.height137,
                  ),
              Positioned(
                left: 13, top: 10, right: 10, bottom: 10, //465),
                child: Container(
                  //color: Colors.red,
                  child: image != null
                      ? InkWell(
                          child: Image.file(
                            image!,
                            width: 216,
                            height: 213,
                            fit: BoxFit.cover,
                          ),
                          onTap: pickImage,
                        )
                      : InkWell(
                          child: Container(
                            width: 216,
                            height: 213,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://dpbnri2zg3lc2.cloudfront.net/en/wp-content/uploads/2021/01/user_flows-2.jpg"),
                              ),
                            ),
                          ),
                          onTap: pickImage,
                        ),
                ),
              ),
              const SizedBox(
                height: 16, //Dimensions.height16,
              ),
              SmallText(text: "ID:"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 35,
                  width: 283,
                  child: TextField(
                    controller: UserNameTextController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter user name' //userModel!.fullName
                        ),
                  )),
              const SizedBox(
                height: 38,
              ),
              SizedBox(
                height: 66,
                width: 323,
                child: TextFormField(
                  autocorrect: false,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.solid)),
                    hintStyle: TextStyle(color: Colors.black),
                    suffixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(end: 12.0),
                      child: InkWell(
                        child: ImageIcon(
                          AssetImage('assets/images/go_chat.png'),
                        ),
                        /*onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MessagePage()));
                          }*/
                      ), // myIcon is a 48px-wide widget.
                    ),
                    hintText: "Enter Chat id",
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
