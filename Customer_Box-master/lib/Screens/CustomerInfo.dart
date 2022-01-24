
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Model/ServiceModel.dart';
import 'package:dadarbox/Screens/NewHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomerInfo extends StatefulWidget {
  String businessName;
  String businessCategory;
  List<AddServiceModel> cart =<AddServiceModel>[] ;
  String totalCost;
  int totalHr;
  int totalMin;

  CustomerInfo({ Key? key,required this.businessName,required this.businessCategory, required this.cart,required this.totalCost,required this.totalHr,required this.totalMin}) : super(key: key);

  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {

  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.reference();


  final _globalkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone_number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pinCode = TextEditingController();

  TextStyle headingStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff1C396D));
  TextStyle contentStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'sfpro');


  var _date;
  var _slot;
  bool _time=false;
  bool _closeDay = false;
  bool _loading = false;
  bool _default=true ;
  String? slotNumber;
  String? slotValue;
  String? updatedSlotValue;
  //int y;
  List<String> slot=[];
  List<String> cartId = [];

  List<Map<String, String>> services = [];

  Map serviceModel = {
    'name': '',
    'cost': '',
  };

  // Sawo configuration object
  var config = {};
  var _timing;
  // user payload
  //String user;
  //String abc = '{"identifier":"null"}';

  String? appointmentStartTime;
  String? appointmentEndTime;

  DateTime date = DateTime.now();


  bool verifying = false;


  Map _timing1 = {
    'slot_1_starting_time': '',
    'slot_1_ending_time': '',
    'slot_2_starting_time': '',
    'slot_2_ending_time': '',
    'slot_3_starting_time': '',
    'slot_3_ending_time': '',
    'slot_4_starting_time': '',
    'slot_4_ending_time': '',
    'slot_5_starting_time': '',
    'slot_5_ending_time': '',
    'slot_6_starting_time': '',
    'slot_6_ending_time': '',
  };


  @override
  void initState() {
    super.initState();
    //getSheduleData(1);
  }

/*
  void fetchTimings(int d) async {
    var response = await networkHandler.get(
        "/appointment/getslots/${widget.username}/${DateFormat('y-M-d').format(date.add(Duration(days: d))).toString()}"
    );

    setState(() {
      timing = ServiceAppointment.fromJson(response["data"]);
      if(timing.close_days.contains(DateFormat('EEE').format(date.add(Duration(days: d))).toString())) {
        _time = false;
        _closeDay = true;
      }
      else{
        _time = timing != null ? true : false;
      }
    });
  }
  */

  Future<void> getSheduleData(int d) async {
    // print("user id ${authController.userId}");
    String _date = DateFormat('y-M-d').format(date.add(Duration(days: d))).toString();
    try {
      var response = await db
          .collection('Slots')
          .where('Business Name', isEqualTo: widget.businessName)
          .where('date', isEqualTo: '$_date')
          .get();
      if (response.docs.length > 0) {
        print('dateeeee haiii');
        setState(() {
          _timing1['slot_1_starting_time'] = response.docs[0]['slot_1_starting_time'];
          _timing1['slot_1_ending_time'] = response.docs[0]['slot_1_ending_time'];
          _timing1['slot_2_starting_time'] = response.docs[0]['slot_2_starting_time'];
          _timing1['slot_2_ending_time'] = response.docs[0]['slot_2_ending_time'];
          _timing1['slot_3_starting_time'] = response.docs[0]['slot_3_starting_time'];
          _timing1['slot_3_ending_time'] = response.docs[0]['slot_3_ending_time'];
          _timing1['slot_4_starting_time'] = response.docs[0]['slot_4_starting_time'];
          _timing1['slot_4_ending_time'] = response.docs[0]['slot_4_ending_time'];
          _timing1['slot_5_starting_time'] = response.docs[0]['slot_5_starting_time'];
          _timing1['slot_5_ending_time'] = response.docs[0]['slot_5_ending_time'];
          _timing1['slot_6_starting_time'] = response.docs[0]['slot_6_starting_time'];
          _timing1['slot_6_ending_time'] = response.docs[0]['slot_6_ending_time'];
          _time = true;

        });
      } else {
        var response = await db
            .collection('Working Hours')
            .where('Business Name', isEqualTo: widget.businessName)
            .get();
        if (response.docs.length > 0) {
          await db.collection('Slots').add({
            'Business Name': widget.businessName,
            'date': _date,
            'slot_1_starting_time': response.docs[0]['slot_1_starting_time'],
            'slot_1_ending_time':response.docs[0]['slot_1_ending_time'] ,
            'slot_2_starting_time': response.docs[0]['slot_2_starting_time'],
            'slot_2_ending_time': response.docs[0]['slot_2_ending_time'],
            'slot_3_starting_time': response.docs[0]['slot_3_starting_time'],
            'slot_3_ending_time':response.docs[0]['slot_3_ending_time'] ,
            'slot_4_starting_time': response.docs[0]['slot_4_starting_time'],
            'slot_4_ending_time': response.docs[0]['slot_4_ending_time'],
            'slot_5_starting_time': response.docs[0]['slot_5_starting_time'],
            'slot_5_ending_time': response.docs[0]['slot_5_ending_time'],
            'slot_6_starting_time': response.docs[0]['slot_6_starting_time'],
            'slot_6_ending_time': response.docs[0]['slot_6_ending_time'],
            'close_days': response.docs[0]['close_days'],
          });
          bool closeDays = response.docs[0]['close_days'].contains(DateFormat('EEE').format(date.add(Duration(days: d))).toString());
          if(closeDays){
             setState(() {
               _timing1['slot_1_starting_time'] = response.docs[0]['slot_1_starting_time'];
               _timing1['slot_1_ending_time'] = response.docs[0]['slot_1_ending_time'];
               _timing1['slot_2_starting_time'] = response.docs[0]['slot_2_starting_time'];
               _timing1['slot_2_ending_time'] = response.docs[0]['slot_2_ending_time'];
               _timing1['slot_3_starting_time'] = response.docs[0]['slot_3_starting_time'];
               _timing1['slot_3_ending_time'] = response.docs[0]['slot_3_ending_time'];
               _timing1['slot_4_starting_time'] = response.docs[0]['slot_4_starting_time'];
               _timing1['slot_4_ending_time'] = response.docs[0]['slot_4_ending_time'];
               _timing1['slot_5_starting_time'] = response.docs[0]['slot_5_starting_time'];
               _timing1['slot_5_ending_time'] = response.docs[0]['slot_5_ending_time'];
               _timing1['slot_6_starting_time'] = response.docs[0]['slot_6_starting_time'];
               _timing1['slot_6_ending_time'] = response.docs[0]['slot_6_ending_time'];
               _time = false;
               _closeDay = true;
             });
          }
          else{
            setState(() {
              _timing1['slot_1_starting_time'] = response.docs[0]['slot_1_starting_time'];
              _timing1['slot_1_ending_time'] = response.docs[0]['slot_1_ending_time'];
              _timing1['slot_2_starting_time'] = response.docs[0]['slot_2_starting_time'];
              _timing1['slot_2_ending_time'] = response.docs[0]['slot_2_ending_time'];
              _timing1['slot_3_starting_time'] = response.docs[0]['slot_3_starting_time'];
              _timing1['slot_3_ending_time'] = response.docs[0]['slot_3_ending_time'];
              _timing1['slot_4_starting_time'] = response.docs[0]['slot_4_starting_time'];
              _timing1['slot_4_ending_time'] = response.docs[0]['slot_4_ending_time'];
              _timing1['slot_5_starting_time'] = response.docs[0]['slot_5_starting_time'];
              _timing1['slot_5_ending_time'] = response.docs[0]['slot_5_ending_time'];
              _timing1['slot_6_starting_time'] = response.docs[0]['slot_6_starting_time'];
              _timing1['slot_6_ending_time'] = response.docs[0]['slot_6_ending_time'];
              _time = true;
            });
          }
        }
        else{
          print('@@@@@@@@@@@@@services');
        }
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {

    TimeOfDay totalTime = TimeOfDay(hour: widget.totalHr, minute: widget.totalMin);
    TimeOfDay? slot1StartingTime =  _timing1['slot_1_starting_time'] == "" ? null : stringToTime (_timing1['slot_1_starting_time']);
    TimeOfDay? slot1EndingTime = _timing1['slot_1_ending_time'] == "" ? null : stringToTime(_timing1['slot_1_ending_time']);
    TimeOfDay? slot2StartingTime = _timing1['slot_2_starting_time'] == "" ? null : stringToTime(_timing1['slot_2_starting_time']);
    TimeOfDay? slot2EndingTime = _timing1['slot_2_ending_time'] == "" ? null : stringToTime(_timing1['slot_2_ending_time']);
    TimeOfDay? slot3StartingTime = _timing1['slot_3_starting_time'] == "" ? null : stringToTime(_timing1['slot_3_starting_time']);
    TimeOfDay? slot3EndingTime = _timing1['slot_3_ending_time'] == "" ? null : stringToTime(_timing1['slot_3_ending_time']);
    TimeOfDay? slot4StartingTime = _timing1['slot_4_starting_time'] == "" ? null : stringToTime(_timing1['slot_4_starting_time']);
    TimeOfDay? slot4EndingTime = _timing1['slot_4_ending_time'] == "" ? null : stringToTime(_timing1['slot_4_ending_time']);
    TimeOfDay? slot5StartingTime = _timing1['slot_5_starting_time'] == "" ? null : stringToTime(_timing1['slot_5_starting_time']);
    TimeOfDay? slot5EndingTime = _timing1['slot_5_ending_time'] == "" ? null : stringToTime(_timing1['slot_5_ending_time']);
    TimeOfDay? slot6StartingTime = _timing1['slot_6_starting_time'] == "" ? null : stringToTime(_timing1['slot_6_starting_time']);
    TimeOfDay? slot6EndingTime = _timing1['slot_6_ending_time'] == "" ? null : stringToTime(_timing1['slot_6_ending_time']);

    var total = DateTime(0,0,0,widget.totalHr,widget.totalMin);
    var nullTime = DateTime(0,0,0,0,0);
    DateTime add = nullTime.add(Duration(hours: total.hour,minutes: total.minute));

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double _height1 = _height * 0.5;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff1C396D),
        title: Center(child: Text('Book appointment',style:  TextStyle(fontSize: 25),),),
      ),
      body: verifying
          ?
      Center(child: CircularProgressIndicator())
          :
      Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: Form(
                    key: _globalkey,
                    child: ListView(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      children: <Widget>[
                        Text(
                          "Select Date",
                          style: headingStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(

                              children: [
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 1))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 1))).toString(), 1,_default),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 2))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 2))).toString(), 2,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 3))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 3))).toString(), 3,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 4))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 4))).toString(), 4,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 5))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 5))).toString(), 5,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 6))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 6))).toString(), 6,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 7))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 7))).toString(), 7,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 8))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 8))).toString(), 8,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 9))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 9))).toString(), 9,false),
                                dateWidget(DateFormat('EEE').format(date.add(Duration(days: 10))).toString(), DateFormat('MMM d').format(date.add(Duration(days: 10))).toString(), 10,false),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _time == true?
                        ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Available Times",
                              style: headingStyle,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _time == true ? appointmentPermit(slot1StartingTime, slot1EndingTime, totalTime)
                                        ? appointStartSide(slot1StartingTime, totalTime, 0)
                                        : SizedBox()
                                        : SizedBox(),

                                    _time == true ? appointmentPermit(slot1StartingTime, slot1EndingTime, totalTime)
                                        ? appointEndSide(slot1EndingTime, totalTime, 1)
                                        : SizedBox()
                                        : SizedBox(),
                                    _time == true
                                        ?
                                    appointmentPermit(slot2StartingTime, slot2EndingTime, totalTime)
                                        ? appointStartSide(
                                        slot2StartingTime, totalTime, 2)
                                        : SizedBox()
                                        : SizedBox(),

                                    _time == true
                                        ?
                                    appointmentPermit(slot2StartingTime, slot2EndingTime, totalTime)
                                        ? appointEndSide(
                                        slot2EndingTime, totalTime, 3)
                                        : SizedBox()
                                        : SizedBox(),
                                    _time == true
                                        ?
                                    appointmentPermit(slot3StartingTime, slot3EndingTime, totalTime)
                                        ? appointStartSide(
                                        slot3StartingTime, totalTime, 4)
                                        : SizedBox()
                                        : SizedBox(),

                                    _time == true
                                        ?
                                    appointmentPermit(slot3StartingTime, slot3EndingTime, totalTime)
                                        ? appointEndSide(
                                        slot3EndingTime, totalTime, 5)
                                        : SizedBox()
                                        : SizedBox(),
                                    _time == true
                                        ?
                                    appointmentPermit(slot4StartingTime, slot4EndingTime, totalTime)
                                        ? appointStartSide(
                                        slot4StartingTime, totalTime, 6)
                                        : SizedBox()
                                        : SizedBox(),

                                    _time == true
                                        ?
                                    appointmentPermit(slot4StartingTime, slot4EndingTime, totalTime)
                                        ? appointEndSide(
                                        slot4EndingTime, totalTime, 7)
                                        : SizedBox()
                                        : SizedBox(),
                                    _time == true
                                        ?
                                    appointmentPermit(slot5StartingTime, slot5EndingTime, totalTime)
                                        ? appointStartSide(
                                        slot5StartingTime, totalTime, 8)
                                        : SizedBox()
                                        : SizedBox(),
                                    _time == true
                                        ?
                                    appointmentPermit(slot5StartingTime, slot5EndingTime, totalTime)
                                        ? appointEndSide(
                                        slot5EndingTime, totalTime, 9)
                                        : SizedBox()
                                        : SizedBox(),
                                    _time == true
                                        ?
                                    appointmentPermit(slot6StartingTime, slot6EndingTime, totalTime)
                                        ? appointStartSide(
                                        slot6StartingTime, totalTime, 10)
                                        : SizedBox()
                                        : SizedBox(),

                                    _time == true
                                        ?
                                    appointmentPermit(slot6StartingTime, slot6EndingTime, totalTime)
                                        ? appointEndSide(
                                        slot6EndingTime, totalTime, 11)
                                        : SizedBox()
                                        : SizedBox(),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                            :
                        _closeDay==true ?
                        ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Available Times",
                              style: headingStyle,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                  //_slot == t ? Color(0xff1C396D) :
                                  Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: Text(
                                "Sorry it's an off day.",
                                style: contentStyle.copyWith(
                                  color:// _slot == t ? Colors.white :
                                  Color(0xff1C396D),
                                ),
                              ),
                            ),),
                          ],
                        ) : _loading == true ?
                        ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Center(child: CircularProgressIndicator()),
                          ],
                        ) : SizedBox(),

                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Appointment For...",
                          style: headingStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        nameTextField(),
                        phoneNumberTextField(),
                        //addressTextField(),
                        /*
                        Row(
                          children: [
                            Flexible(child: cityTextField()),
                            Flexible(child: pinCodeTextField()),
                          ],
                        ),
                        */
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            //left: 13,
            height: _height1 * 0.18,
            width: _width,
            child: Container(

              margin: const EdgeInsets.only(top: 6.0),
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
                onPressed: () async{

                  print(widget.cart);

                  var slotCheck =await db
                      .collection('Slots')
                      .where('Business Name', isEqualTo: widget.businessName)
                      .where('date', isEqualTo: DateFormat('y-M-d').format(date.add(Duration(days: _date))).toString())
                      .where('$slotNumber', isEqualTo: slotValue)
                      .get();
                  if(slotCheck.docs.length > 0){
                   await db.collection('Slots').doc(slotCheck.docs[0].id).update({'$slotNumber':'$updatedSlotValue'});
                   print('Uploadedddddddd 00000');

                   print(DateFormat('y-M-d')
                       .format(date.add(Duration(days: _date)))
                       .toString());
                   print('Uploadedddddddd 0.55555555');

                   widget.cart.forEach((element) =>
                  services.add({'name':'${element.name}','cost':'${element.cost}'})
                  );
                   db.collection('Appointments').add({
                     'customerId': user!.uid,
                     'businessName': widget.businessName,
                     'date':DateFormat('y-M-d')
                       .format(date.add(Duration(days: _date)))
                       .toString(),
                     'total':widget.totalCost,
                     'totalTime':"${widget.totalHr}:${widget.totalMin}",
                     'startTime':appointmentStartTime,
                     'cart':services,
                     'customerName':name.text,
                     'customerContact':phone_number.text,

                   });
                     print('Uploadedddddddd');
                     String time = DateTime.now().toString();

                     await database.child('Chats').update(
                         {
                           'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/business_Name': widget.businessName,
                           'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/business_Category': widget.businessCategory,
                           'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/customer_Activity': time,
                           'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/last_Activity': time,

                         });

                     print('Uploadedddddddd 1111');


                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (context) => NewHome(),
                       ),
                     );

                  }
                  else{
                    print('nahiiiiiiiiii hUaaaaaaaaa');
                  }
/*
                  if(y == null || appointmentStartTime == null){
                    if(y==null){
                      _errorMessageDialog(context, "Select Date");
                    }
                    else{
                      _errorMessageDialog(context, "Select Time");
                    }
                  }
                  else if (_globalkey.currentState!.validate()){
                    print(slotNumber);
                    print(slotValue);
                    print(cartId);
                    print(slot);
                    var response = await networkHandler
                        .get("/slot_check/$slotNumber/${widget.username}/${DateFormat('y-M-d').format(date.add(Duration(days: y))).toString()}/$slotValue");
                    if(response['Status']){
                      print("status");
                      slots.username = widget.username;
                      slots.slot_1_starting_time = slot[0];
                      slots.slot_1_ending_time = slot[1];
                      slots.slot_2_starting_time = slot[2];
                      slots.slot_2_ending_time = slot[3];
                      slots.slot_3_starting_time = slot[4];
                      slots.slot_3_ending_time = slot[5];
                      slots.slot_4_starting_time = slot[6];
                      slots.slot_4_ending_time = slot[7];
                      slots.slot_5_starting_time = slot[8];
                      slots.slot_5_ending_time = slot[9];
                      slots.slot_6_starting_time = slot[10];
                      slots.slot_6_ending_time = slot[11];
                      slots.close_days = _timing.docs[0]['close_days'];
                      slots.date =
                      "${DateFormat('y-M-d').format(date.add(Duration(days: y))).toString()}";
                      print("slots update");
                      var response = await networkHandler.patch1(
                          "/appointment/slots/add/${widget.username}/${DateFormat('y-M-d').format(date.add(Duration(days: y))).toString()}",
                          slots.toJson());
                      print("slots updated");
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {

                        order.username = widget.username;
                        order.cart = widget.cart;
                        order.start_time = appointmentStartTime;
                        order.end_time = appointmentEndTime;
                        order.customer_name = name.text;
                        order.customer_contact_number = phone_number.text;
                        order.Total = widget.totalCost;
                        order.total_time = "${add.hour}Hr ${add.minute}min";
                        order.date = DateFormat('y-M-d')
                            .format(date.add(Duration(days: y)))
                            .toString();

                        var response = await networkHandler.post1(
                            "/appointment/add/${widget.username}/${DateFormat('y-M-d').format(date.add(Duration(days: y))).toString()}",
                            order.toJson());
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Admin()),
                                  (route) => false);
                        }
                      }
                      else{
                        print("Not done");
                      }
                    }
                    else {

                      setState(() {
                        verifying = false ;
                        dateWidget(DateFormat('EEE').format(date.add(Duration(days: y))).toString(), DateFormat('MMM d').format(date.add(Duration(days: y))).toString(), y);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Timings updated select again")));
                      });
                    }
                  }*/
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff1C396D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Book",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text("₹",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none)),
                        ),
                        Text(" ${widget.totalCost}",
                            style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)),
                      ],
                    ),
                  ],
                ),

              ),
            ),
          )
        ],
      ),
    );
  }

  Widget nameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: TextFormField(
        controller: name,
        validator: (value) {
          if (value==null || value.isEmpty) {
            return "Enter Name";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Name",
        ),
        maxLines: 1,
      ),
    );
  }

  Widget phoneNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: phone_number,
        validator: (value) {
          if (value==null || value.isEmpty) {
            return "Enter contact number";
          } else if (value.length > 10) {
            return "Enter 10 digit mobile number";
          }
          else if(value.length < 10){
            return "Enter 10 digit mobile number";
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Contact number",
          counterText: '',
        ),
        maxLines: 1,
        maxLength: 10,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: ()  {  },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.blue),
          child: Center(
              child: Text(
                "Confirm Order",
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  appointStartSide(TimeOfDay? startingTime, TimeOfDay? totalTime, int t) {
    if(startingTime !=null && totalTime !=null){
      var xTime = DateTime(0, 0, 0, startingTime.hour, startingTime.minute);
      //var yTime= DateTime(0,0,0,totalTime.hour,totalTime.minute);

      //Duration add = xTime.difference(yTime);
      DateTime add =
          xTime.add(Duration(hours: totalTime.hour, minutes: totalTime.minute));

      //int addMinute = add.inMinutes-(add.inHours*60);

      //int totalMinutes = starting_time.minute+total_time.minute;
      //int add_hour =  starting_time.hour+total_time.hour+ totalMinutes ~/ 60 ;
      //int addMinute= (totalMinutes)-(totalMinutes ~/ 60)*60;

      TimeOfDay endingTime = TimeOfDay(hour: add.hour, minute: add.minute);

      TimeOfDay normalTime =
          startingTime.replacing(hour: startingTime.hourOfPeriod);

      String _startingTime = startingTime.period == DayPeriod.am
          ? "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} AM"
          : "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} PM";

      String _endingTime = endingTime.period == DayPeriod.am
          ? "${endingTime.hour}:${endingTime.minute} AM"
          : "${endingTime.hour}:${endingTime.minute} PM";
      return InkWell(
        onTap: () {
          setState(() {
            _slot = t;
            slot.clear();
            slot.add(_timing1['slot_1_starting_time']);
            slot.add(_timing1['slot_1_ending_time']);
            slot.add(_timing1['slot_2_starting_time']);
            slot.add(_timing1['slot_2_ending_time']);
            slot.add(_timing1['slot_3_starting_time']);
            slot.add(_timing1['slot_3_ending_time']);
            slot.add(_timing1['slot_4_starting_time']);
            slot.add(_timing1['slot_4_ending_time']);
            slot.add(_timing1['slot_5_starting_time']);
            slot.add(_timing1['slot_5_ending_time']);
            slot.add(_timing1['slot_6_starting_time']);
            slot.add(_timing1['slot_6_ending_time']);
            if (t == 0 || t == 2 || t == 4 || t == 6 || t == 8 || t == 10) {
              slot[t] = "${endingTime.hour}:${endingTime.minute}";
              appointmentStartTime = startingTime.period == DayPeriod.am
                  ? "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} AM"
                  : "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} PM";
              appointmentEndTime = endingTime.period == DayPeriod.am
                  ? "${endingTime.hour}:${endingTime.minute} AM"
                  : "${endingTime.hour}:${endingTime.minute} PM";
              slotNumber = _slotNumber(t);
              slotValue = "${startingTime.hour}:${startingTime.minute}";
              updatedSlotValue = "${endingTime.hour}:${endingTime.minute}";

            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  _slot == t ? Color(0xff1C396D) : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$_startingTime" /* to $_endingTime "*/,
                style: contentStyle.copyWith(
                  color: _slot == t ? Colors.white : Color(0xff1C396D),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  appointEndSide(TimeOfDay? endingTime, TimeOfDay? totalTime, int t) {
    if(endingTime != null && totalTime != null){
      var xTime = DateTime(0, 0, 0, endingTime.hour, endingTime.minute);
      var yTime = DateTime(0, 0, 0, totalTime.hour, totalTime.minute);
      Duration subtract = xTime.difference(yTime);

      //int totalMinutes = ending_time.minute + total_time.minute; // subtract minutes
      //int subtract_hour = (ending_time.hour-total_time.hour-(totalMinutes/60)).toInt();
      //int subtractMinute = 60 - ((totalMinutes)-((totalMinutes ~/ 60)*60));

      int subtractMinute = subtract.inMinutes - (subtract.inHours * 60);

      TimeOfDay startingTime =
          TimeOfDay(hour: subtract.inHours, minute: subtractMinute);

      TimeOfDay normalTime =
          startingTime.replacing(hour: startingTime.hourOfPeriod);

      String _startingTime = startingTime.period == DayPeriod.am
          ? "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} AM"
          : "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} PM";

      String _endingTime = endingTime.period == DayPeriod.am
          ? "${endingTime.hour}:${endingTime.minute} AM"
          : "${endingTime.hour}:${endingTime.minute} PM";
      return InkWell(
        onTap: () {
          setState(() {
            _slot = t;
            slot.clear();
            slot.add(_timing1['slot_1_starting_time']);
            slot.add(_timing1['slot_1_ending_time']);
            slot.add(_timing1['slot_2_starting_time']);
            slot.add(_timing1['slot_2_ending_time']);
            slot.add(_timing1['slot_3_starting_time']);
            slot.add(_timing1['slot_3_ending_time']);
            slot.add(_timing1['slot_4_starting_time']);
            slot.add(_timing1['slot_4_ending_time']);
            slot.add(_timing1['slot_5_starting_time']);
            slot.add(_timing1['slot_5_ending_time']);
            slot.add(_timing1['slot_6_starting_time']);
            slot.add(_timing1['slot_6_ending_time']);
            if (t == 1 || t == 3 || t == 5 || t == 7 || t == 9 || t == 11) {
              slot[t] = "${startingTime.hour}:${startingTime.minute}";
              appointmentStartTime = startingTime.period == DayPeriod.am
                  ? "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} AM"
                  : "${normalTime.hour == 0 ? 12 : normalTime.hour}:${startingTime.minute} PM";
              appointmentEndTime = endingTime.period == DayPeriod.am
                  ? "${endingTime.hour}:${endingTime.minute} AM"
                  : "${endingTime.hour}:${endingTime.minute} PM";
              slotNumber = _slotNumber(t);
              slotValue = "${endingTime.hour}:${endingTime.minute}";
              updatedSlotValue = "${startingTime.hour}:${startingTime.minute}";
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  _slot == t ? Color(0xff1C396D) : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$_startingTime" /* to $_endingTime "*/,
                style: contentStyle.copyWith(
                  color: _slot == t ? Colors.white : Color(0xff1C396D),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  dateWidget(String day, String date, int d,bool x) {

    return InkWell(
      onTap: () {
        _default =false;
        if(widget.totalHr == null || widget.totalMin == null){
          _errorMessageDialog(context, "Add services to check appointments");
        }
        else {
          setState(() {
            //y = d;
            _date = d;
            _time = false;
            _closeDay =false;
            _loading = true ;
            print("loading");
            getSheduleData(d);
            //_loading = false ;
          });
        }
      },
      child: Container(
        height: 68,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color:
            _date == d || x? Color(0xff1C396D) : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: contentStyle.copyWith(
                  color: _date == d || x ? Colors.white : Color(0xff1C396D),
                  fontSize: 23),
            ),
            Text(
              date,
              style: contentStyle.copyWith(
                  color: _date == d || x? Colors.white : Color(0xff1C396D),
                  fontSize: 18),
            )
          ],
        ),
      ),
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


  stringToTime(String slotTime){
    return slotTime=="null"?null:TimeOfDay(
        hour: int.parse(slotTime.split(":")[0]),
        minute: int.parse(slotTime.split(":")[1]));
  }

  appointmentPermit(TimeOfDay? slotStartTime,TimeOfDay? slotEndTime,TimeOfDay totalTime){
    if(slotStartTime==null || slotEndTime==null || totalTime==null) {
      return false;
    }
    else{
      return
        ((slotEndTime.hour.toDouble() +
            slotEndTime.minute
                .toDouble() /
                60.0) -
            (slotStartTime.hour
                .toDouble() +
                slotStartTime.minute
                    .toDouble() /
                    60.0)) >
            (totalTime.hour.toDouble() +
                totalTime.minute.toDouble() /
                    60.0)? true:false;
    }
  }

  Container timeWidget(String time, bool isActive) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: (isActive) ? Color(0xff1C396D) : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: contentStyle.copyWith(
              color: (isActive) ? Colors.white : Color(0xff1C396D),
            ),
          ),
        ],
      ),
    );
  }

  _slotNumber(int x){

    if (x==0){
      return 'slot_1_starting_time';
    }
    if (x==1){
      return 'slot_1_ending_time';
    }
    if (x==2){
      return 'slot_2_starting_time';
    }
    if (x==3){
      return 'slot_2_ending_time';
    }
    if (x==4){
      return 'slot_3_starting_time';
    }
    if (x==5){
      return 'slot_3_ending_time';
    }
    if (x==6){
      return 'slot_4_starting_time';
    }
    if (x==7){
      return 'slot_4_ending_time';
    }
    if (x==8){
      return 'slot_5_starting_time';
    }
    if (x==9){
      return 'slot_5_ending_time';
    }
    if (x==10){
      return 'slot_6_starting_time';
    }
    if (x==11){
      return 'slot_1_ending_time';
    }
  }


}
