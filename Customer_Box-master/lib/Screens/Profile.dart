
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool data =false;


  Map userProfileData = {
    'First Name': '',
    'DOB': '',
    'Last Name': '',
    'Member Since': '',
    'Address':'',
    'Pincode': ''
  };

  @override
  void initState()  {
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
        userProfileData['First Name'] = response.docs[0]['First Name'];
        userProfileData['Last Name'] = response.docs[0]['Last Name'];
        userProfileData['DOB'] = response.docs[0]['DOB'];
        userProfileData['Member Since'] = response.docs[0]['Member Since'];
        userProfileData['Address'] = response.docs[0]['Address'];
        userProfileData['Pincode'] = response.docs[0]['Pincode'];
        setState(() {
          data =true;
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: primaryColor,
        title: Text('Profile',style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,fontSize: 29,
            textStyle: TextStyle(color: Colors.white))),
        centerTitle: true,
      ),
      body: data?Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              //foregroundColor: primaryColor,
              backgroundColor: primaryColor,
              child: Icon(CupertinoIcons.person,size: 100,)
            ),
            SizedBox(height: 8,),
            listTile('Name', '${userProfileData['First Name']} ${userProfileData['Last Name']}'),
            listTile('Member Since', userProfileData['Member Since']),
            listTile('Email ID', '${user!.email}'),
            listTile('User ID', cardId(user!.uid)),
            listTile('Date of Birth', userProfileData['DOB']),
            listTile('Address', userProfileData['Address']),
            listTile('Pincode', userProfileData['Pincode']),

          ],
        ),
      ):Center(child: CircularProgressIndicator(),),

    );
  }

  cardId(String id){

    id = id.replaceRange(5, 8, "*" * 4);
    id = id.replaceRange(11, 14, "*" * 4);
    id = id.replaceRange(18, 21, "*" * 4);

    return id;
  }


  Widget listTile(String title,String subTitle){
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          title: Text(title,style:TextStyle(fontSize: 15,color: Colors.black54)),
          subtitle: Text(subTitle, style: TextStyle(fontSize: 18,color: Colors.black87)),
        ),
      ),
    );

  }

}
