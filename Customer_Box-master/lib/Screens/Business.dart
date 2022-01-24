
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Business extends StatefulWidget {
  final String businessName;
  final String firstName;
  final String lastName;
  final String reward;
  final String locked;

  const Business({Key? key,required this.businessName,required this.reward,required this.locked,required this.firstName,required this.lastName}) : super(key: key);

  @override
  _BusinessState createState() => _BusinessState();
}

class _BusinessState extends State<Business> {


  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool data = false;
  bool noPayments=false;
  var payment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('------init----state---');
    getPaymentData();
    print('------init----state---');

  }

  Future<void> getPaymentData() async {
    // print("user id ${authController.userId}");
    try {
      var response = await db
          .collection('Payments')
          .where('Business Name', isEqualTo: widget.businessName)
          .where('uid', isEqualTo: user!.uid)
          .get();

      print(response.docs.length);
      print('------data------');
      print(response);
      if (response.docs.length > 0) {
        setState(() {
          payment = response;
          data = true;
        });
      }
      else{
        setState(() {
          noPayments=true;
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: new PreferredSize(
            child: new Container(
                color: primaryColor,
                padding: const EdgeInsets.all(1.0),
                ),
            preferredSize: const Size.fromHeight(0.0)),
        toolbarHeight: 85,
        backgroundColor: primaryColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: primaryColor, width: 1)),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            //Icon(Icons.arrow_back_rounded,size: 45,color: Colors.white,),
            Container(
              padding: EdgeInsets.all(0),
              height: 32,
              width: 32,
              child: Image.asset('assets/back.png',height: 24,width: 32,),
            ),
            Text("${widget.businessName}",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,fontSize: 29,
                  textStyle: TextStyle(color: Colors.white)),),
            //IconButton(onPressed: (){}, icon: Icon(Icons.qr_code_scanner_outlined,color: primaryColor,size: 30,)),
            Container(
              height: 33,
              width: 33,
              child: Image.asset('assets/info.png',height: 33,width: 33,),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            height: 120,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      children: [
                        Text("₹",style: TextStyle(fontSize: 42.5,color: Colors.white,fontWeight: FontWeight.w400),),
                        SizedBox(width: 2,),
                        Text("${widget.reward }",style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,fontSize: 40.5,
                            textStyle: TextStyle(color: Colors.white))),
                      ],
                    ),
                    Text("Cashback",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,fontSize: 29.5,
                            textStyle: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:Color(0xff6881B5)
                    ),
                    child: Image.asset('assets/lock.png',height: 65,width: 65,),
                  ),
                )
              ],
            )
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: ElevatedButton(
                    style: businessButtonStyle,
                    onPressed: () {},
                    child: Center(
                      child: Text('Pay',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,fontSize: 16,
                              textStyle: TextStyle(color: Colors.white))),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: ElevatedButton(
                    style: businessButtonStyle,
                    onPressed: () {  },
                    child: Center(
                      child: Text('Catalog',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,fontSize: 16,
                              textStyle: TextStyle(color: Colors.white))),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Payments",style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,fontSize: 26.5,
                textStyle: TextStyle(color: primaryColor))),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25)
            ),
            padding: EdgeInsets.only(left:20,right:20),
            height: 526,
            child: data?ListView.builder(
              itemBuilder: (context, index) {
                return payCard(payment.docs[index]['Pay'],payment.docs[index]['Time'],payment.docs[index]['Status']);
              },
              itemCount: payment.docs.length,
              shrinkWrap: true,
            ):Center(child: noPayments?
            Text('No Payments Made Yet',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    textStyle:
                    TextStyle(color: primaryColor))):CircularProgressIndicator(),),
          ),

        ],
      ),
    );
  }
  Widget payCard(String pay,String date,String status){
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 35.0,top: 25,right: 35,bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 43,
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("₹",style:TextStyle(color: primaryColor,fontSize: 40,fontWeight: FontWeight.w400)),
                    SizedBox(width: 2,),
                    Text("$pay",style: TextStyle(color: primaryColor,fontWeight: FontWeight.w400,fontSize: 38,)),
                  ],
                ),
              ),
              Text("$date",style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,fontSize: 19,
                  textStyle: TextStyle(color: primaryColor))),
              SizedBox(height: 4,),
              payCardStatus('$status')
            ],
          ),
        ),
      ),
    );
  }

  Widget payCardStatus(String status) {
    return status == 'Request'
        ? statusNotDecided()
        : status == 'Payed'
            ? statusDecided("Payed", primaryColor, primaryColor, Colors.white)
            : statusDecided(
                "Declined", primaryColor, Colors.white, primaryColor);
  }

  Widget statusDecided(String status,Color border,Color fill,Color textColor) {
    return Container(
      width: 250,
      height: 40,
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color:  border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$status",style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,fontSize: 29,
          textStyle: TextStyle(color: textColor)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget statusNotDecided(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: primaryColor,
                  minimumSize: Size(125, 36),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  side: BorderSide(color: primaryColor),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  )
              ),
              onPressed: () { },
              child: Center(
                child: Text('Decline',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,fontSize: 22,
                        textStyle: TextStyle(color: primaryColor))),
              ),
            ),
          ),
        ),
        Container(
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: primaryColor,
                  minimumSize: Size(125, 36),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  )
              ),
              onPressed: () { },
              child: Center(
                child: Text('Pay',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,fontSize: 22,
                        textStyle: TextStyle(color: Colors.white))),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
