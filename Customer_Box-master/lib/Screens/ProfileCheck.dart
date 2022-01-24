import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Screens/AddProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class ProfileCheck extends StatefulWidget {
  const ProfileCheck({Key? key}) : super(key: key);

  @override
  _ProfileCheckState createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool data =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfileData();
  }

  Future<void> getUserProfileData() async {
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Customer Profile')
          .where('uid', isEqualTo: user!.uid)
          .limit(1)
          .get();
      // response.docs.forEach((result) {
      //   print(result.data());
      // });
      if (response.docs.length > 0) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Home(user: response,),
            ),(route) => false
          );
      }
      else{
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => AddProfile(),
          ),(route) => false
        );
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
