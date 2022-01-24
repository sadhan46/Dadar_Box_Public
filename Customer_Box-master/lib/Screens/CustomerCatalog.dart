import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerCatalog extends StatefulWidget {
  final String businessName;

  const CustomerCatalog({Key? key,required this.businessName}) : super(key: key);

  @override
  _CustomerCatalogState createState() => _CustomerCatalogState();
}

class _CustomerCatalogState extends State<CustomerCatalog> {


  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  // final storage= FirebaseStorage.instance.ref().child('Catalog');


  List<String> names = ["Souffle","Pritee Caterers","Villa Fortune","DaSila's","Cake Farm"];
  List<String> cashbacks = ["50","500","1500","80","75"];
  Map userProfileData = {
    'First Name': '',
    'DOB': '',
    'Last Name': '',
    'Member Since': '',
    'Pincode': ''
  };

  bool data=false;
  var catalog;

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
          .collection('Catalog')
          .where('Business Name', isEqualTo: widget.businessName)
          .get();
      // response.docs.forEach((result) {
      //   print(result.data());
      // });
      if (response.docs.length > 0) {
        setState(() {
          catalog=response;
          data =true;
        });
      }
      print(userProfileData);
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Catalog',style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,fontSize: 28,
            textStyle: TextStyle(color: Colors.white))),
        centerTitle: true,
      ),
      body: data
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4),
                    itemBuilder: (context, index) {
                      return /*InkWell(
                  child: Column(
                    children: [
                      Divider(height: 4,color: Colors.transparent,),
                      Container(
                        height: 62,
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  leading(),
                                  Expanded(
                                    child: Text("${names[index]}",style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,fontSize: 25.5,
                                        textStyle: TextStyle(color: primaryColor)),
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                  trailing(cashbacks[index]),
                                ]
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Business(name: names[index],cashBack: cashbacks[index],),
                      ),
                    );
                  },);*/
                          Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  //height: 500,
                                  // width: 10,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(catalog.docs[index]['image']),
                                          fit: BoxFit.cover),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  //decoration: BoxDecoration(
                                  //  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  //),
                                  //child: Image.network(catalog.docs[index]['image'],fit: BoxFit.cover,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      catalog.docs[index]['name'],
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.5,
                                          textStyle:
                                              TextStyle(color: Colors.black54)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text("₹ ",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16.5)),
                                            Text(catalog.docs[index]['cost'],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.5,
                                                    textStyle: TextStyle(
                                                        color: Colors.black54)))
                                          ],
                                        ),
                                        Text(catalog.docs[index]['unit'],
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.5,
                                                textStyle: TextStyle(
                                                    color: Colors.black54)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: catalog.docs.length,
                    shrinkWrap: true,
                  ),
                ), /*
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 250,
                  width: (MediaQuery.of(context).size.width*0.5)-12,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 180,
                         // width: 10,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                        child: Container(),
                        ),
                        Text("Total Cashback",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,fontSize: 18.5,
                                textStyle: TextStyle(color: Color(0xffbcc1cd)))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("₹ ",
                                    style: TextStyle(color: Colors.white,fontSize: 16.5)),
                                Text("750",style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,fontSize: 16.5,
                                    textStyle: TextStyle(color: Colors.white)))
                              ],
                            ),
                            Text("0.5 kg",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,fontSize: 16.5,
                                textStyle: TextStyle(color: Colors.white)))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: (MediaQuery.of(context).size.width*0.5)-12,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                ),
              ],
            ),
          )*/
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
/*
  void takePhoto() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile;
    });

  }

*/
}
