import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Pay extends StatefulWidget {
  final String image;
  final String businessName;
  final String firstName;
  final String lastName;

  const Pay({Key? key,required this.image,required this.businessName,required this.firstName,required this.lastName}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {


  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final storage=FirebaseStorage.instance;

  final _globalKey = GlobalKey<FormState>();
  TextEditingController pay = TextEditingController();
  var imageURL='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    businessImage();
  }

  Future<void> businessImage() async{
    var url = await storage
        .ref()
        .child('Logo')
        .child('${'souffle'}')
        .getDownloadURL();
    setState(() {
      imageURL = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageURL == ''
                ? Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    //padding: EdgeInsets.all(10.0),
                    height: 65,
                    width: 95,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageURL), fit: BoxFit.cover),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                  ),
            /*Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/google.png',
                    ),
                  ),
                ),
              ),*/
              SizedBox(height: 13,),
              Text("Paying to ${widget.businessName}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,fontSize: 22,
                      textStyle: TextStyle(color: Colors.black54))),
              //buildPayTF(pay, 'Pay'),
              SizedBox(height: 10,),
              Form(key:_globalKey,child: _buildPayTF())
            ],
          ),
        )
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: () async{
          if(_globalKey.currentState!.validate()){
          try {
            var response = await db
                .collection('Cash Drop')
                .where('Business Name', isEqualTo : widget.businessName)
                .where('uid' , isEqualTo : user!.uid)
                .limit(1)
                .get();
            if (response.docs.length > 0) {
              print('==============${response.docs.length}');
              print('==============${response.docs[0].id}');
              int discount = (10 * int.parse(pay.text)) ~/ 100;
              if (int.parse(response.docs[0]['Reward']) > discount) {
                print('=======inside if ======if=========');
                int decreasedCashDrop =
                    int.parse(response.docs[0]['Reward']) - discount;
                int lockedCashDrop =
                    int.parse(response.docs[0]['Locked']) + discount;
                int newPayment = int.parse(pay.text) - discount;

                await db
                    .collection('Cash Drop').doc(response.docs[0].id)
                    .update({
                      'uid': user!.uid,
                      'Business Name': widget.businessName,
                      'Reward': decreasedCashDrop.toString(),
                      'Locked': lockedCashDrop.toString(),
                      'createdAt': DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
                    })
                    .then((value) => db.collection('Payments').add({
                          'uid': user!.uid,
                          'Business Name': widget.businessName,

                          'First Name': widget.firstName,
                          'Last Name': widget.lastName,
                          'Status': 'Payed',
                          'Pay': newPayment.toString(),
                          'Time':DateFormat('dd MMM yyyy, hh:mm aaa').format(DateTime.now()),
                          'createdAt': DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
                        }))
                    .then((value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                        (route) => false));
                /*              await db.collection('Payments').add({
                  'uid' : user!.uid,
                  'Business Name' : widget.businessName,
                  'First Name':widget.firstName,
                  'Last Name':widget.lastName,

                  'Status' : 'Payed',
                  'Pay' : newPayment.toString(),
                  'createdAt' : ServerValue.timestamp,
                });
*/
              }
              else if (int.parse(response.docs[0]['Reward']) < discount && int.parse(response.docs[0]['Reward']) > 0) {
                print('=========inside if else============');
                int newPayment = int.parse(pay.text) - int.parse(response.docs[0]['Reward']);
                int cashDrop=int.parse(response.docs[0]['Locked']);
                int lockedCashDrop=0;

                await db.collection('Cash Drop').doc(response.docs[0].id)
                    .update({
                  'uid': user!.uid,
                  'Business Name': widget.businessName,

                  'Reward': cashDrop.toString(),
                  'Locked': lockedCashDrop.toString(),
                  'createdAt': DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
                }).then((value) =>  db.collection('Payments').add({
                  'uid' : user!.uid,
                  'Business Name' : widget.businessName,
                  'First Name':widget.firstName,
                  'Last Name':widget.lastName,

                  'Status' : 'Payed',
                  'Pay' : newPayment.toString(),
                  'Time':DateFormat('dd MMM yyyy, hh:mm aaa').format(DateTime.now()),
                  'createdAt' : DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
                })).then((value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                        (route) => false));

                /*await db.collection('Payments').add({
                  'uid' : user!.uid,
                  'Business Name' : widget.businessName,
                  'First Name':widget.firstName,
                  'Last Name':widget.lastName,

                  'Status' : 'Payed',
                  'Pay' : newPayment.toString(),
                  'createdAt' : ServerValue.timestamp,
                });*/
              }
              else {
                print('=========inside if else if else============');
                int cashDrop = (50 * int.parse(pay.text)) ~/ 100;
                int lockedCashDrop=0;
                await db.collection('Cash Drop').doc(response.docs[0].id)
                    .update({
                  'uid': user!.uid,
                  'Business Name': widget.businessName,

                  'Reward': cashDrop.toString(),
                  'Locked': lockedCashDrop.toString(),
                  'createdAt': DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
                }).then((value) => db.collection('Payments').add({
                  'uid' : user!.uid,
                  'Business Name' : widget.businessName,
                  'First Name':widget.firstName,
                  'Last Name':widget.lastName,

                  'Status' : 'Payed',
                  'Pay' : pay.text,
                  'Time':DateFormat('dd MMM yyyy, hh:mm aaa').format(DateTime.now()),
                  'createdAt' : DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
                })).then((value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                        (route) => false));
                /*
              await db.collection('Payments').add({
                'uid' : user!.uid,
                'Business Name' : widget.businessName,
                'First Name':widget.firstName,
                'Last Name':widget.lastName,

                'Status' : 'Payed',
                'Pay' : pay.text,
                'createdAt' : ServerValue.timestamp,
              });

               */
              }
            }
            else {
              print('=========inside else============');
              int cashDrop = (50 * int.parse(pay.text)) ~/ 100;
              int lockedCashDrop=0;
              await db.collection('Cash Drop').add({
                'uid': user!.uid,
                'Business Name': widget.businessName,

                'Reward': cashDrop.toString(),
                'Locked': lockedCashDrop.toString(),
                'createdAt':DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
              }).then((value) => db.collection('Payments').add({
                'uid' : user!.uid,
                'Business Name' : widget.businessName,
                'First Name':widget.firstName,
                'Last Name':widget.lastName,

                'Status' : 'Payed',
                'Pay' : pay.text,
                'Time':DateFormat('dd MMM yyyy, hh:mm aaa').format(DateTime.now()),
                'createdAt' : DateFormat('dd MM yyyy, kk:mm aaa').format(DateTime.now()),
              })).then((value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                      (route) => false));
              /*
              await db.collection('Payments').add({
                'uid' : user!.uid,
                'Business Name' : widget.businessName,
                'First Name':widget.firstName,
                'Last Name':widget.lastName,

                'Status' : 'Payed',
                'Pay' : pay.text,
                'createdAt' : ServerValue.timestamp,
              });

               */
            }

          } on FirebaseException catch (e) {
            print(e);
          } catch (error) {
            print(error);
          }
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
/*
  Widget buildPayTF(
      TextEditingController controller, String label) {
    return Container(

      child: TextFormField(
        style: TextStyle(
            color: Colors.black54,
            fontFamily: 'OpenSans',
            fontSize: 50,
            height: 1.5
        ),
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        validator: (value) {
          if (value ==null || value.isEmpty) {
            return "Enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "$label",
            prefix: Text("₹ ",
            style: TextStyle(color: Colors.black54,fontSize: 35)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          filled: true,
            isDense: true

        ),
        maxLines: 1,
      ),
    );
  }*/

  Widget _buildPayTF() {
    return Container(
      alignment: Alignment.center,
      height: 80.0,
      width: 150,
      child: TextFormField(
        autofocus: true,
        controller: pay,
        validator: (value) {
          if (value==null || value.isEmpty) {
            return showMessage("Enter amount");
          }
          if (value=='0') {
            return showMessage("Enter amount");
          }
          if (value.contains('-')) {
            return showMessage("Enter numbers only");
          }
          if (value.contains(',')) {
            return showMessage("Enter numbers only");
          }
          if (value.contains('.')) {
            return showMessage("Enter numbers only");
          }
          if (value.contains(' ')) {
            return showMessage("Enter numbers only");
          }
          return null;
    },
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black54,
          fontFamily: 'OpenSans',
              fontSize: 50,
              height: 1.5
        ),
        decoration: InputDecoration(

          //filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          isDense: true,                      // Added this
          contentPadding: EdgeInsets.symmetric(horizontal: 14.0),
          prefix: Text("₹ ",
              style: TextStyle(color: Colors.black54,fontSize: 32.5)),

          hintText: '0',
          hintStyle: TextStyle(
            color: Colors.black54
          ),
        ),
      ),
    );
  }

  showMessage(String message) {
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

}
