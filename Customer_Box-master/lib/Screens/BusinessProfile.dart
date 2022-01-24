
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Screens/AppointmentRoom.dart';
import 'package:dadarbox/Screens/BookAppointment.dart';
import 'package:dadarbox/Screens/ChatRoom.dart';
import 'package:dadarbox/Screens/Clip.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessProfile extends StatefulWidget {
  final String businessName;
  const BusinessProfile({Key? key,required this.businessName}) : super(key: key);

  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {

  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool data = false;
  var business;

  var clips;


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getClipsData();
    getBusinessProfileData();
  }

  Future<void> getBusinessProfileData() async {
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Business Profile')
          .where('Business Name', isEqualTo: widget.businessName)
          .limit(1)
          .get();
      // response.docs.forEach((result) {
      //   print(result.data());
      // });
      if (response.docs.length > 0) {
        business = response.docs[0];
        setState(() {
          data = true;
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> getClipsData() async {
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Clips')
          .where('businessName', isEqualTo: widget.businessName)
          .get();
      if (response.docs.length > 0) {
        clips=response.docs;
        setState(() {});
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }



  Widget _businessProfile(){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height*0.25,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(image: NetworkImage('${business['Logo']}'),
                        fit: BoxFit.cover,
                      ))
              ),
              ListTile(
                title: Text('Business Name :',style: TextStyle(color: Colors.black54,letterSpacing: -0.5,)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,),
                  child: Text(
                    '${business['Business Name']}',
                    style:TextStyle(color: Colors.black,letterSpacing: -0.5,fontSize: 27),textAlign: TextAlign.left,maxLines: 6,
                  ),
                ),
              ),
              Container(
                color: backgroundColor,
                height: 10,
              ),
              ListTile(
                title: Text('Category :',style: TextStyle(color: Colors.black54,letterSpacing: -0.5,)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8),
                  child: Text(
                    '${business['Category']}',
                    style:
                    TextStyle(color: Colors.black,letterSpacing: -0.5,fontSize: 18),textAlign: TextAlign.left,maxLines: 6,
                  ),
                ),
              ),
              Container(
                color: backgroundColor,
                height: 10,
              ),
              ListTile(
                title: Text('About :',style: TextStyle(color: Colors.black54,letterSpacing: -0.5,)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8),
                  child: Text(
                    '${business['Business Description']}',
                    style:TextStyle(color: Colors.black,letterSpacing: -0.5,fontSize: 18),textAlign: TextAlign.left,maxLines: 6,
                  ),
                ),
              ),
              Container(
                color: backgroundColor,
                height: 10,
              ),
              SizedBox(
                height: 5,
              ),
              Flexible(
                child:GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width*0.333,
                      childAspectRatio: 9/16,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    return
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: backgroundColor,
                              image: DecorationImage(image: NetworkImage('${clips[index]['thumbnail']}'),
                                fit: BoxFit.cover,
                              )),
                          height: 270,
                        ),
                        onTap: ()  {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: Clip(clip: '${clips[index]['clip']}'),
                              )

                          );
                        },
                      );
                  },
                  itemCount: clips.length,
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          chatOrAppointment()
              ?
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatRoom(
                businessName: business['Business Name'],
                businessCategory: business['Category'],
              ),
            ),
          )
              :
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookAppointment(
              businessName: business['Business Name'],
              businessCategory: business['Category'],
            ),
          ),
          );

        },
        icon: chatOrAppointment() ? Icon(Icons.message_outlined) : Icon(Icons.timer_rounded),
        label: chatOrAppointment() ? Text("Start Chat"): Text("Book Appointment"),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget loading(){
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  bool chatOrAppointment(){
    if(business['Category'] == 'Saloon' || business['Category'] == 'Beauty Parlour') {
      return false;
    }

    else
      return true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: data ? _businessProfile() : loading(),
    );
  }
}
