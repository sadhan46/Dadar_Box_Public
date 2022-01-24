import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Screens/BookAppointment.dart';
import 'package:dadarbox/Screens/SendImage.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

User? user = FirebaseAuth.instance.currentUser;


class AppointmentRoom extends StatefulWidget {

  final String businessName;
  final String businessCategory;
  const AppointmentRoom({Key? key,required this.businessName,required this.businessCategory}) : super(key: key);
  @override
  _AppointmentRoomState createState() => _AppointmentRoomState();
}

class _AppointmentRoomState extends State<AppointmentRoom> {

  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance.reference();

  TextEditingController messageEditingController = new TextEditingController();


  bool loading=true;
  bool data = false;


  var appointments;
  String? message ;

  bool firstMessage = false;
  late StreamSubscription activity;

  ScrollController listScrollController = ScrollController();

/*
  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }*/

  addMessage() async{

    if (messageEditingController.text.isNotEmpty) {
      String time = DateTime.now().toString();
      String _minusTime = DateTime.now().subtract(Duration(days: 1)).toString();
      Map<String, dynamic> chatMessageMap = {
        "sendBy": user!.uid,
        "message": messageEditingController.text,
        "image": '',
        'time': time,
      };
      if(firstMessage == true) {
        print('firstmessage true hai ');
        await database.child('Chats').update(
            {
              'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/last_Activity': time,

              'Businesses/${widget.businessName}/${widget.businessName}_${user!.uid}/last_Activity': time,
            });
      }
      if(firstMessage == false ) {
        print('firstmessage false hai ');
        await database.child('Chats').update(
            {
              'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/business_Name': widget.businessName,
              'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/business_Category': widget.businessCategory,
              'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/customer_Activity': time,
              'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/last_Activity': time,

              'Businesses/${widget.businessName}/${widget.businessName}_${user!.uid}/customer_Name': user!.displayName,
              'Businesses/${widget.businessName}/${widget.businessName}_${user!.uid}/customer_Id': user!.uid,
              'Businesses/${widget.businessName}/${widget.businessName}_${user!.uid}/business_Activity': _minusTime,
              'Businesses/${widget.businessName}/${widget.businessName}_${user!.uid}/last_Activity': time,
            });
      }
      await database.child('Chatrooms/${widget.businessName}_${user!.uid}').push().set(chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  Widget chatMessages(){
    return StreamBuilder(
      stream: database.child('Chatrooms/${widget.businessName}_${user!.uid}')
          .orderByChild('time')
          .onValue,
      builder: (context, snapshot){
        List<MessageTile> tilesList = <MessageTile>[];
        tilesList.length != 0 ? firstMessage=true : firstMessage=false;

        if(snapshot.hasData && (snapshot.data as Event).snapshot.value != null) {

          final myOrders = Map<String, dynamic>.from((snapshot.data! as Event).snapshot.value);

          myOrders.forEach((key, value) {

            final nextOrder = Map<String, dynamic>.from(value);

            final orderTile = MessageTile(
              sendByMe: nextOrder['sentBy'] != user!.uid,
              image: nextOrder['image'],
              message: nextOrder['message'],
              time: nextOrder['message'],
            );

            tilesList.add(orderTile);
            tilesList.length != 0 ? firstMessage=true : firstMessage=false;
            print(firstMessage);
          });
        }

        return ListView(
          shrinkWrap: true,
          reverse: true,
          children: tilesList.reversed.toList(),
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
    );
  }

  Widget chatMessages1(){
    return StreamBuilder(
      stream: database.child('Chatrooms/${widget.businessName}_${user!.uid}')
          .orderByChild('time')
          .limitToLast(10).onValue,
      builder: (context, snap){
        if (snap.hasData &&
            !snap.hasError &&
            (snap.data! as Event).snapshot.value != null) {
//taking the data snapshot.
          DataSnapshot snapshot = (snap.data! as Event).snapshot;
          List item = [];
          List _list = [];
//it gives all the documents in this list.
          _list = snapshot.value;
//Now we're just checking if document is not null then add it to another list called "item".
//I faced this problem it works fine without null check until you remove a document and then your stream reads data including the removed one with a null value(if you have some better approach let me know).
          _list.forEach((f) {
            if (f != null) {
              item.add(f);
            }
          });
          return (snap.data! as Event).snapshot.value == null
//return sizedbox if there's nothing in database.
              ? SizedBox()
//otherwise return a list of widgets.
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: item[index]['message'],
                image: item[index]['image'],
                sendByMe: item[index]['sentBy']==user!.uid,
                time: item[index]['time'],
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
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
    );
  }

  void _activity(){

    activity=database.child('Chats/Customers/${user!.uid}/${widget.businessName}_${user!.uid}').onValue.listen((event) async {

      String _customerActivity=  (event.snapshot.value['customer_Activity']);
      String _lastActivity=  (event.snapshot.value['last_Activity']);

      if(_customerActivity !=_lastActivity){
        await database.child('Chats/Customers/${user!.uid}/${widget.businessName}_${user!.uid}').update(
            {
              'customer_Activity':_lastActivity,
            });
      }
    });

  }

  void fetchTimings() async {
    setState(() {
      loading=true;
    });
    //var response1 = await networkHandler.get(
    //  "/appointment/try1/getappointments/${DateFormat('y-M-d').format(date.add(Duration(days: d))).toString()}");

    var response = await db
        .collection('Appointments')
        .where('customerId', isEqualTo: user!.uid)
        .where('businessName', isEqualTo:'${widget.businessName}' )
        .get();
    print('appointmentssssssssss');
    print(response.docs.length);
    setState(() {
      if(response.docs.length==0){
        data = false ;
        message ="No Appointments";
      }
      else {
        appointments = response;
        data=true;
      }
    });
    /*
    var profile = await networkHandler.get("/profile/getData");
    profileModel = ProfileModel.fromJson(profile["data"]);
    if(profileModel.date != DateFormat('y-M-d').format(DateTime.now()).toString() && data == true) {
      //for number of services
      services= int.parse(profileModel.services);
      //add.hour == int.parse(profileModel.service_time.split(":")[0]);
      //add.minute == int.parse(profileModel.service_time.split(":")[1]);
      add = add.add(Duration(hours: int.parse(profileModel.service_time.split(":")[0]),minutes: int.parse(profileModel.service_time.split(":")[1])));
      total=total+double.parse(profileModel.total);
      for(int i = 0;i < customer.data.length ;i++){
        services=services+customer.data[i].cart.length;
        print(services);
      }
      //for total service hours
      print("hour2");
      for(int i = 0;i < customer.data.length ;i++){
        String total_time = customer.data[i].total_time;
        add = add.add(Duration(hours: int.parse(total_time.split(":")[0]),minutes: int.parse(total_time.split(":")[1])));
        print(add);
      }
      //for total earnings
      print("hour3");
      for(int i = 0;i < customer.data.length ;i++){
        total=total+double.parse(customer.data[i].Total);
        print(total);
      }
      print("hour3.5");
      Map<String, String> data = {
        "services": services.toString(),
        "service_time": "${add.hour}:${add.minute}",
        "total": total.toString(),
        "address":profileModel.address,
        "date": DateFormat('y-M-d').format(date).toString(),
      };
      print("hour4");
      await networkHandler.patch("/profile/update", data);
    }*/
    setState(() {
      loading=false;
    });
  }


  customerInfoDialog(BuildContext context,final String customerName,
      final String customerContactNumber,
      final String startTime,
      final String endTime,
      final String total,
      List<dynamic> cartProduct ) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        title: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Color(0xff1C396D),
              blurRadius: 5.0,
            ),],
            shape: BoxShape.rectangle,
            color: Color(0xff1C396D),
            borderRadius:
            new BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
          ),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*Text("$customerName",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none)),*/
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Divider(height: 14,),
                    Text(' $customerName',
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none)),
                    SelectableText(" $customerContactNumber • $startTime",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none)),
                  ],
                ),
                /* Text("$total",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none)),*/
                RichText(text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text:"₹",
                          style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none)),
                      TextSpan(text: total,
                          style: TextStyle(
                              fontSize: 26.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none)),
                    ]
                ),)
              ],
            ),
          ),
        ),

        content: Container(
          //height: 400,
          width: 200,
          child: ListView.builder(
            itemBuilder: (context, index) {
              //int price = int.parse(cartProduct[index].serviceCost);
              //int counter = cartProduct[index].counter;
              //int tileCost = price*counter;
              return Column(
                children: [
                  /*              Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: ListTile(
                      title: Text(
                        "${cartProduct[index].serviceName}",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cartProduct[index].hr}Hr ${cartProduct[index].min}min",
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 3.0),
                                    child: Text("₹ ",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none)),
                                  ),
                                  Text("${cartProduct[index].serviceCost} x ${cartProduct[index].counter}",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none)),
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 3.0),
                                      child: Text("${cartProduct[index].currency} ",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.none)),
                                    ),
                                    Text("$tileCost",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none))
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
*/
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cartProduct[index]['name']}",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,),
                          ),
                          /*
                          cartProduct[index].hr=="0"
                              ?
                          Text(
                            "${cartProduct[index].hr}Hr ${cartProduct[index].min}min",
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          )
                              :
                          Text(
                            "${cartProduct[index].min}min",
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          )*/
                        ],
                      ),
                      RichText(text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text:"₹",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none)),
                            TextSpan(text:cartProduct[index]['cost'],
                                style: TextStyle(
                                    fontSize: 26.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none)),
                          ]
                      ))
                    ],
                  ),
                  Container(
                    height: 2,
                    color: Color(0xff1C396D).withOpacity(0.05),
                  ),
                ],
              );
            },
            itemCount: cartProduct.length,
            shrinkWrap: true,
          ),
        ),
        actions: [
          TextButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ));

  @override
  void initState() {
    super.initState();
    fetchTimings();
  }

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double _height1 = _height * 0.5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('${widget.businessName}',style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,fontSize: 25,
            textStyle: TextStyle(color: Colors.white,)),),
        //centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            height: _height - (_height1 * 0.18),
            child: loading
                ?
            Center(child: CircularProgressIndicator())
                :
            data
                ?
            ListView.builder(itemBuilder: (context,index){

              return
                Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${appointments.docs[index]['startTime'].toString().split(' ').first}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 27,
                                      color: Colors.white)),
                              TextSpan(
                                  text: '${appointments.docs[index]['startTime'].toString().split(' ').last}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      title: Text(appointments.docs[index]['customerName'],style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: primaryColor)),
                      subtitle: Text(
                                    'Date :- ${appointments.docs[index]['date']}',style: TextStyle(color: primaryColor,fontSize: 15)),
                      trailing: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: '₹',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20,color: primaryColor)),
                            TextSpan(text: ' ',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10,color: primaryColor)),
                            TextSpan(text: appointments.docs[index]['total'],style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28,color: primaryColor)),
                          ],
                        ),
                      ),
                      onTap:  (){
                        customerInfoDialog(context,appointments.docs[index]['customerName'],
                            appointments.docs[index]['customerContact'],
                            appointments.docs[index]['startTime'],
                            'endtime',
                            appointments.docs[index]['total'],
                            appointments.docs[index]['cart']
                        );
                      },
                    ),
                    SizedBox(height: 10,)
                  ],
                );
            },
              itemCount: appointments.docs.length,
              shrinkWrap: true,
            )
                :
            Center(
              child: Column(
                children: [
                  Icon(Icons.timer_off_rounded),
                  Text(message!),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            //left: 13,
            height: _height1 * 0.18,
            width: _width,
            child: Container(
              //margin: const EdgeInsets.only(top: 6.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 5.0,
                  ),
                ],
              ),
              //color: Colors.green,
              padding: EdgeInsets.fromLTRB(13,8,13,8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BookAppointment(
                      businessName: widget.businessName,
                      businessCategory: widget.businessCategory,
                    ),
                  ),
                  );
                },
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(
                        Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(
                        Color(0xff1C396D)),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(5)))),

                // height:_height1*0.13,
                //width: _width-100,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Book Appointment",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                            decoration:
                            TextDecoration.none)),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    activity.cancel();
    super.dispose();
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final String image;
  final bool sendByMe;
  final String time;

  MessageTile({required this.message,required this.image, required this.sendByMe,required this.time});

  @override

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: image == '' ? _messagePadding : _imagePadding,
          decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
                ]
                : [
                const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF)
            ],
          )
      ),
      child: image == '' ? _message() : _image() ,
    ),
    );
  }

  EdgeInsetsGeometry _messagePadding= EdgeInsets.only(
      top: 17,bottom: 17, left: 20, right: 20
  );

  EdgeInsetsGeometry _imagePadding= EdgeInsets.only(
      top: 4,bottom: 4, left: 5, right: 5
  );

  Widget _image(){
    return Column(
      children: [
        Container(
            height: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black87,
                image: DecorationImage(image: NetworkImage(image),
                  fit: BoxFit.contain,
                ))
        ),
        Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _message(){
    return Text(message,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300));
  }
}

