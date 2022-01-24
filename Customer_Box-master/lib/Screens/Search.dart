import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Screens/BusinessProfile.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {

  const Search({Key? key,}) : super(key: key);

  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final _debouncer = DeBouncer(milliseconds: 500);
  Widget appBarTitle = new Text("Links");
  Icon actionIcon = new Icon(Icons.search);
  bool data = false;
  var business;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: backgroundColor,
        appBar: new AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff1C396D),
          automaticallyImplyLeading: false,
          title: TextField(
            autofocus: true,
            onChanged: (text) {
              //print(text);
              _debouncer.run(() async {
                // print("user id ${authController.userId}");
                try {
                  var response = await db
                      .collection('Business Profile')
                      .where('Business Search', arrayContains: text)
                      .limit(10)
                      .get();
                  // response.docs.forEach((result) {
                  //   print(result.data());
                  // });
                  if (response.docs.length > 0) {
                    setState(() {
                      //catalog=response;
                      business = response;
                      data = true;
                    });
                  } else {
                    print('data nill');
                    setState(() {
                      //catalog=response;
                      data = false;
                    });
                  }
                } on FirebaseException catch (e) {
                  print(e);
                } catch (error) {
                  print(error);
                }
              });
            },
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search, color: Colors.white),
                hintText: " Search...",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
        ),
        body: Container(
          child: Container(
              padding: EdgeInsets.all(10.0),

              color: Colors.transparent,
              height: 325,
              child: data
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Column(
                            children: [
                              Divider(
                                height: 4,
                                color: Colors.transparent,
                              ),
                              Container(
                                height: 62,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0))),
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          leading(business.docs[index]['Logo']),
                                          Expanded(
                                            child: Text(
                                              business.docs[index]
                                                  ['Business Name'],
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 25.5,
                                                  textStyle: TextStyle(
                                                      color: primaryColor)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          trailing(),
                                        ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BusinessProfile(businessName: business.docs[index]['Business Name'],)
                              ),
                            );
                          },
                        );
                      },
                      itemCount: business.docs.length,
                      shrinkWrap: true,
                    )
                  : SizedBox()),
        ));
  }
}

Widget leading(String image) {
  return Container(
    height: 62,
    width: 95,
    child: Row(
      children: [
        Container(
          //padding: EdgeInsets.all(10.0),
          height: 52,
          width: 86,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover),
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        Container(
          width: 4,
        ),
        Column(
          children: [
            Container(
              width: 1,
              height: 1,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 2,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 3,
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 2,
              color: Colors.grey,
            ),
            Container(
              width: 1,
              height: 2,
              color: Colors.white,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget trailing() {
  return Container(
    height: 62,
    width: 60,
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
    child: Center(
        child: Icon(
      Icons.add_rounded,
      color: Colors.white,
      size: 35,
    )),
  );
}

_errorMessageDialog(BuildContext context, String label) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: Text('Attention'),
          content: Text('$label '),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ));

class DeBouncer {
  final int milliseconds;

  late VoidCallback action;
  Timer _timer = Timer(Duration(milliseconds: 1), () {});

  DeBouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
