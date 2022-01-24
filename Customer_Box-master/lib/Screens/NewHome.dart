
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/FIrebase/FirebaseService.dart';
import 'package:dadarbox/Screens/AddProfile.dart';
import 'package:dadarbox/Screens/AppointmentRoom.dart';
import 'package:dadarbox/Screens/ChatRoom.dart';
import 'package:dadarbox/Screens/Login.dart';
import 'package:dadarbox/Screens/Profile.dart';
import 'package:dadarbox/Screens/Search.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class NewHome extends StatefulWidget {
  final user;
  NewHome({Key? key,this.user}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {

  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.reference();
  final storage=FirebaseStorage.instance;




  List<String> names = ["Souffle","Pritee Caterers","Villa Fortune","DaSila's","Cake Farm"];
  List<String> _cashbacks = ["50","500","1500","80","75"];
  String cardIds = "hxi3rWiNfxCviSaBsY0";
  late String username ;

  Map userProfileData = {
    'First Name': '',
    'DOB': '',
    'Last Name': '',
    'Member Since': '',
    'Pincode': ''
  };

  late DocumentSnapshot customer;

  bool data=true;
  bool cashBacks=false;
  bool noCashBacks=false;
  bool qr=false;

  var slot;
  var business;
  var profile;
  var reward;
  var imageURL='';



  Widget leading (){
    return Container (
      height: 62,
      width: 95,
      child: Row(
        children: [
          Container(
            //padding: EdgeInsets.all(10.0),
            height: 52,
            width: 86,
            color: Colors.blue,
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

  Widget trailing (String cashBack){
    return Container(
      height: 62,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),)
      ),
      child: Row(
        children: [
          Text("₹",
              style: TextStyle(color: Colors.white,fontSize: 28.5)),
          Text("$cashBack",style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,fontSize: 25.5,
              textStyle: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget cardId(String id){

    id = id.replaceRange(5, 8, "*" * 4);
    id = id.replaceRange(11, 14, "*" * 4);
    id = id.replaceRange(18, 21, "*" * 4);

    return Text("$id",style: GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.white,fontSize: 10)));
  }


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    if(widget.user != null)assignProfileData();
    if(widget.user == null)getUserProfileData();
    getShowCaseData();

  }

  void assignProfileData(){
    print('data data data data');
    print(widget.user.docs[0]);
    print('data data data data 1');
    userProfileData['First Name'] = widget.user.docs[0]['First Name'];
    userProfileData['Last Name'] = widget.user.docs[0]['Last Name'];
    userProfileData['DOB'] = widget.user.docs[0]['DOB'];
    userProfileData['Member Since'] = widget.user.docs[0]['Member Since'];
    userProfileData['Pincode'] = widget.user.docs[0]['Pincode'];
  }

  Widget _card(){
    return Container(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(
                      0, 3), // changes position of shadow
                ),
              ],

                //image: DecorationImage(image: NetworkImage('${business[0]['image']}'),fit: BoxFit.cover)

            ),
            child: Image.asset('assets/DadarCard.png'),
          ),
          /*
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, top: 38, right: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(qr == false)Text("Total Cashback",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.5,
                        textStyle: TextStyle(
                            color: Color(0xffbcc1cd)))),
                if (qr == false)Row(
                  children: [
                    Text("₹ ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.5)),
                    Text("750",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 30.5,
                            textStyle:
                            TextStyle(color: Colors.white)))
                  ],
                ),
                if (qr == false)SizedBox(
                  height: 40,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardId(user!.uid),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(20, 13),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          side: BorderSide(
                              color: Colors.white, width: 1.5),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(4)),
                          )),
                      onPressed: () {
                        if(qr == true){
                          setState(() {
                            qr=false;
                          });
                        }
                        else{
                          setState(() {
                            qr=true;
                          });
                        }
                      },
                      child: Center(
                        child: Text(qr ? 'Hide QR' : 'Show QR',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget navBar(){
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Hello,${userProfileData['First Name']}',style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,fontSize: 22,
                textStyle: TextStyle(color: Colors.white))),
            accountEmail: Text(user!.email!,style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,fontSize: 18,
                textStyle: TextStyle(color: Colors.white))),
            currentAccountPicture: CircleAvatar(
              foregroundColor: primaryColor,
              child: Image.asset(
                'assets/person.png',
                fit: BoxFit.cover,
                width: 90,
                height: 90,
                color: primaryColor,
              ),
            ),
            decoration: BoxDecoration(
                color: primaryColor),
          ),
//          Container(height: 5,color: backgroundColor,),
          ListTile(
            tileColor: backgroundColor,
            leading: Icon(Icons.person,color: primaryColor,size: 33,),
            title: Text('Profile',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    textStyle: TextStyle(color: primaryColor))),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              );
            },
          ),
          Container(height: 5,color: Colors.white,),
          ListTile(
            tileColor: backgroundColor,
            leading: Icon(Icons.search_rounded,color: primaryColor,size: 33,),
            title: Text('Search',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    textStyle: TextStyle(color: primaryColor))),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Search(),
                ),
              );
            },
          ),
          Container(height: 5,color: Colors.white,),
          ListTile(
            tileColor: backgroundColor,
            leading: Icon(
              Icons.logout_rounded,color: primaryColor,size: 33,
            ),
            title: Text('Logout',style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,fontSize: 22,
                textStyle: TextStyle(color: primaryColor))),
            onTap: () async {
              FirebaseService service = new FirebaseService();
              try {
                await GoogleSignIn().disconnect();
                await service.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              } catch(e){
                if(e is FirebaseAuthException){
                  showMessage(e.message!);
                }
              }
            },
          ),
      //    Expanded(child: Container(color: backgroundColor,)),
        ],
      ),
    );
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> getUserProfileData() async {
    setState(() {
      data = false;
    });
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Customer Profile')
          .where('customerId', isEqualTo: user!.uid)
          .get();

      if (response.docs.length > 0) {
        userProfileData['First Name'] = response.docs[0]['First Name'];
        userProfileData['Last Name'] = response.docs[0]['Last Name'];
        userProfileData['DOB'] = response.docs[0]['DOB'];
        userProfileData['Member Since'] = response.docs[0]['Member Since'];
        userProfileData['Pincode'] = response.docs[0]['Pincode'];
        setState(() {
          data =true;
        });
        return ;
      }

      if(response.docs.length == 0){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddProfile(),
          ),
        );
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> getShowCaseData() async {
    setState(() {
      data = false;
    });
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Customer Home')
          .limit(1)
          .get();

      slot=response.docs[0];
      business=response.docs[0]['Slot 1']['Businesses'];

    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

/*
  Future<void> getCashDropsData() async {
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Cash Drop')
          .where('uid', isEqualTo: user!.uid)
          .get();
      print('pay pay pay pay');
      print(response);
      // response.docs.forEach((result) {
      //   print(result.data());
      // });
      if (response.docs.length > 0) {
        setState(() {
          reward=response;
          cashBacks = true;
        });
      }
      else{
        setState(() {
          noCashBacks=true;
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }
*/

  Widget _chats(){
    print('AAAAAAAAAAAAAAAAAAAAAA       -----------0');
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),

      child: StreamBuilder(
        stream: database.child('Chats/Customers/${user!.uid}')
            .orderByChild('last_Activity')
            .onValue,

        builder: (context, snapshot){
          List<BusinessTile> businessTilesList = <BusinessTile>[];
          print('AAAAAAAAAAAAAAAAAAAAAA       -----------0');

          if(snapshot.hasData && (snapshot.data as Event).snapshot.value != null) {

            final myBusinessContacts = Map<String, dynamic>.from((snapshot.data! as Event).snapshot.value);


            myBusinessContacts.forEach((key, value) {

              final business = Map<String, dynamic>.from(value);

              final contactTile = BusinessTile(
                businessName: business['business_Name'],
                businessCategory: business['business_Category'],
                customerActivity: business['customer_Activity'],
                lastActivity: business['last_Activity'],
              );

              print('ffffff');
              print(contactTile);

              businessTilesList.add(contactTile);
              //businessTilesList.length != 0 ? firstMessage=true : firstMessage=false;
              //print(firstMessage);
            });
          }

          return ListView(
            shrinkWrap: true,
            children: businessTilesList.reversed.toList(),
          );
          /*
          return snapshot.hasData ?  ListView.builder(
              itemCount: snapshot.data!..length,
              itemBuilder: (context, index){
                return MessageTile(
                  message: snapshot.data.documents[index].data["message"],
                  sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
                );
              }) : Container();*/
        },
      ),
    );
  }

  Future<void> image(String businessName) async{
    var url = await storage
        .ref()
        .child('Logo')
        .child('$businessName')
        .getDownloadURL();
    setState(() {
      imageURL = url;
    });
  }

  Widget showCase(var slot){
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${slot['Title']}',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color: primaryColor),overflow: TextOverflow.ellipsis,),
          SizedBox(height: 15,),
          Flexible(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              //padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width*0.5,
                  childAspectRatio: 16/12,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                return
                  InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                                image: DecorationImage(image: NetworkImage('${slot['Businesses'][index]['image']}'),fit: BoxFit.cover)
                            ),
                            //child: Image.network('${slot.docs[0]['Slot 1']['Businesses'][index]['image']}',fit: BoxFit.contain,),
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(' ${slot['Businesses'][index]['name']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),overflow: TextOverflow.ellipsis)
                      ],
                    ),
                    onTap: () { }
                  );
              },
              itemCount: slot['Businesses'].length,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatsUI(){
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.transparent,
        child: ListView(
          children: [
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/send.png'),radius: 28.0,
                ),
                title: Text('Google',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                    textStyle: TextStyle(color: Colors.black87))),
                subtitle: Text('what is the price what is the price what is the price what is the price ',overflow: TextOverflow.ellipsis),
                trailing: Column(
                  children: [
                    Text('06:40 am',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        textStyle: TextStyle(color: Colors.black54))),
                    Text('')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navBar(),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const ImageIcon(AssetImage('assets/Settings_icon.png'),size: 27,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        elevation: 0,
        title:Text("Dadar Box",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,fontSize: 29,
              textStyle: TextStyle(color: Colors.white)),),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.video_library_rounded,size: 33,),
              onPressed: () { },
            ),
          )
        ],
      ),
      body: data
          ?
      ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text("Hello, ${userProfileData['First Name']}!",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 29.5,
                    textStyle: TextStyle(color: primaryColor))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text("Welcome to Dadar Box.",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 23.5,
                    textStyle: TextStyle(color: Color(0xb36077a9)))),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _card(),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text("Dadar Businesses",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    textStyle: TextStyle(color: primaryColor))),
          ),
          _chats(),
          Center(
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(),
                  ),
                );
              },
              child: Text('+ Add Business',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      textStyle: TextStyle(color: Colors.white))),
            ),
          ),
          SizedBox(
            height: 8,
          ),

          showCase(slot['Slot 1']),

          SizedBox(
            height: 16,
          ),

          showCase(slot['Slot 2']),

          SizedBox(
            height: 16,
          ),
          showCase(slot['Slot 3']),
        ],
      )
          :
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}



class BusinessTile extends StatelessWidget {
  final String businessName;
  final String businessCategory;
  final String customerActivity;
  final String lastActivity;

  BusinessTile({required this.businessName,required this.businessCategory, required this.customerActivity,required this.lastActivity});

  @override

  Widget build(BuildContext context) {

    final storage=FirebaseStorage.instance;


    Widget customerTileTrailingFormat(String time,bool messageSeen){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('$time',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              textStyle: TextStyle(color: messageSeen ? Colors.black54 : Colors.blue[500]))),

          messageSeen ? Icon(Icons.brightness_1_rounded,color: Colors.white,) : Icon(Icons.brightness_1_rounded,color: Colors.blue[500],)
        ],
      );
    }

    Widget customerTileTrailing(String businessActivity,lastActivity){

      DateFormat dateFormat = DateFormat("dd/MM/yy");
      DateFormat timeFormat = DateFormat("h:mm a");

      DateTime businessTime=DateTime.parse(businessActivity);
      DateTime lastTime=DateTime.parse(lastActivity);
      DateTime time = DateTime.now();

      String messageTime = timeFormat.format(lastTime);
      String date = dateFormat.format(lastTime);

      DateTime compareLastDateActivity = DateTime(lastTime.year,lastTime.month,lastTime.day);
      DateTime todayDate = DateTime(time.year,time.month,time.day);
      DateTime yesterdayDate = DateTime(time.year,time.month,time.day-1);

      bool isYesterday = compareLastDateActivity.compareTo(yesterdayDate) == 0;
      bool isToday = compareLastDateActivity.compareTo(todayDate) == 0;
      bool messageSeen = businessTime.compareTo(lastTime) == 0;

      print(messageTime);

      if(isToday){
        return customerTileTrailingFormat('$messageTime',messageSeen);
      }
      else if (isYesterday) {
        return customerTileTrailingFormat('yesterday',messageSeen);
      }
      else
        return customerTileTrailingFormat('$date',messageSeen);
    }

    Future<void> image(String businessName) async{
      var url = await storage
          .ref()
          .child('Logo')
          .child('$businessName')
          .getDownloadURL();

    }

    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/blueCard.png'),radius: 28.0,
          child: Icon(Icons.store,size: 35,),
        ),
        title: Text('$businessName',
          overflow: TextOverflow.ellipsis ,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 21,
              textStyle: TextStyle(color: Colors.black87)),
        ),
        subtitle: Text('$businessCategory',overflow: TextOverflow.ellipsis),
        trailing: customerTileTrailing(customerActivity, lastActivity),
        onTap: (){
          if(businessCategory != 'Saloon' && businessCategory != 'Beauty Parlour' ){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatRoom(
                  businessName: businessName,
                  businessCategory: businessCategory,
                ),
              ),
            );
          }

          if(businessCategory == 'Saloon' || businessCategory == 'Beauty Parlour' ){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AppointmentRoom(
                  businessName: businessName,
                  businessCategory: businessCategory,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

