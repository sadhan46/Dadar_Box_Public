
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/FIrebase/FirebaseService.dart';
import 'package:dadarbox/Screens/Business.dart';
import 'package:dadarbox/Screens/Login.dart';
import 'package:dadarbox/Screens/Search.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  var user;
  Home({Key? key,this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;


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

  var profile;
  var reward;


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
    print('=========user========');
    //print(widget.user.docs[0].id );
    print('=========user ID========');

    if(widget.user == null)getUserProfileData();
    if(widget.user != null)assignProfileData();
    getCashDropsData();
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
          ListTile(
            leading: Icon(Icons.person,color: primaryColor,size: 33,),
            title: Text('Profile',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    textStyle: TextStyle(color: primaryColor))),
          ),

          ListTile(
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
          ListTile(
            leading: Icon(
              Icons.logout_rounded,color: primaryColor,size: 33,
            ),
            title: Text('Logout',style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,fontSize: 22,
                textStyle: TextStyle(color: primaryColor))),
            onTap: () async {
              FirebaseService service = new FirebaseService();
              try {
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
          .where('uid', isEqualTo: user!.uid)
          .get();
      // response.docs.forEach((result) {
      //   print(result.data());
      // });
      if (response.docs.length > 0) {
        userProfileData['First Name'] = response.docs[0]['First Name'];
        userProfileData['Last Name'] = response.docs[0]['Last Name'];
        userProfileData['DOB'] = response.docs[0]['DOB'];
        userProfileData['Member Since'] = response.docs[0]['Member Since'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navBar(),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85,
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
        title:Text("Cash Drop",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,fontSize: 29,
              textStyle: TextStyle(color: Colors.white)),),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.search_rounded,size: 32,),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Search())
                );// do something
              },
            ),
          )
        ],
      ),
      body: data
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, ${userProfileData['First Name']}!",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 29.5,
                            textStyle: TextStyle(color: primaryColor))),
                    Text("Welcome to Cash Drop.",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 23.5,
                            textStyle: TextStyle(color: Color(0xb36077a9)))),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.asset('assets/Creditcard.png'),
                          ),
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Cash Drops",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 29.5,
                            textStyle: TextStyle(color: primaryColor))),
                    Container(
                        color: Colors.transparent,
                        height: 325,
                        child: cashBacks
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
                                          padding: EdgeInsets.only(left: 10.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.0),
                                                  bottomLeft: Radius.circular(10.0),
                                                  topRight: Radius.circular(10.0))),
                                          child: Column(
                                            children: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    leading(),
                                                    Expanded(
                                                      child: Text(
                                                        reward.docs[index]['Business Name'],
                                                        style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 25.5,
                                                            textStyle: TextStyle(color: primaryColor)),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    trailing(reward.docs[index]['Reward']),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Business(
                                            businessName: reward.docs[index]['Business Name'],
                                            reward: reward.docs[index]['Reward'],
                                            locked: reward.docs[index]['Locked'],
                                            firstName: userProfileData['First Name'],
                                            lastName: userProfileData['Last Name'],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                itemCount: reward.docs.length,
                                shrinkWrap: true,
                              )
                            : Center(
                                child: noCashBacks
                                    ? Text('No Rewards Available',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18,
                                            textStyle:
                                                TextStyle(color: primaryColor)))
                                    : CircularProgressIndicator(),
                              )),
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
                        child: Text('+ New Payment',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                textStyle: TextStyle(color: Colors.white))),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
