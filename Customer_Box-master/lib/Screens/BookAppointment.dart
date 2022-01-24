
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Model/ListofService.dart';
import 'package:dadarbox/Model/ServiceModel.dart';
import 'package:dadarbox/Screens/CustomerInfo.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookAppointment extends StatefulWidget {
  final String businessName;
  final String businessCategory;

  const BookAppointment({Key? key,required this.businessName,required this.businessCategory}) : super(key: key);
  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {


  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Services listModel = Services();

  List<AddServiceModel> _service=[];
  List<AddServiceModel> _cart = [];

  //List<bool> addproduct =[] ;
  //List<int> counter =[];
  //ProductListModel cartModel = ProductListModel();
  List<Map<dynamic, dynamic>> list = [];
  //ProductListModel cartProducts =ProductListModel();
  Widget page = CircularProgressIndicator();

  DateTime date = DateTime.now();

  double sum = 0;
  bool services = true;
  bool loading = false;
  bool data = false;

  var service;
  var _slot;
  bool _time=false;
  List<String> names=[];
  List<String> min=[];
  List<String> hr=[];
  List<String> _hr=["y","x"];

  List<Map<String,dynamic>>? xyz=[
    {
      'name': '',
      'hr': '',
      'min': '',
      'cost': '',
      'Pincode': ''
    }
  ];

  num totalHr = 0;
  num totalMin = 0;

  TextStyle headingStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff1C396D));
  TextStyle contentStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'sfpro');

  @override
  void initState() {
    super.initState();
    //cartProducts.cart_=List<ProductModel>();
    //cartModel.data=<ProductModel>[];

    fetchServicesData();
    //getAllData();
    // _addproduct();
  }

  void fetchData() async {
    loading = true;

  }

  Future<void> fetchServicesData() async {
    // print("user id ${authController.userId}");
    try {
      print('==========fetchingServiceData');
      var response = await db
          .collection('Services')
          .where('businessName', isEqualTo: widget.businessName)
          .get()
          .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              //listModel = Services.fromJson(doc);

              AddServiceModel addServiceModel =AddServiceModel(
                businessName: doc["businessName"],
                  name: doc["name"],
                  hr: doc["hr"],
                  min: doc["min"],
                  cost: doc["cost"],
                addService: doc["addService"],
                counter: doc["counter"]

              );
              _service.add(addServiceModel);
              /*listModel.data?.add(addServiceModel);
              print('================ADDSERVICEModel~~~~~~${addServiceModel.name}');
              print('=======~~naachooo~~~~~~~${doc["name"]}');
              names.add(doc["name"]);
              hr.add(doc["hr"]);
              min.add(doc["min"]);*/
            });
          });
      print('=========fetchedServiceData$names');
      print('=========fetchedServiceData$hr');

      print('=======@@@@@ SERVICE Names @@${_service[0].name}');
      print('=======@@@@ SERVICE Names @@@${_service[1].name}');

      print('=========fetchedServiceData$min');
      print("===lets naachoo==${_service}");

      var _response = await db
          .collection('Services')
          .where('businessName', isEqualTo: widget.businessName)
          .get();

      if (_response.docs.length > 0) {
        setState(() {
          //listModel = Services.fromJson(response.docs);
          //print('========================~~~~~~~~~listModel');
          list = _response.docs.map((doc) => doc.data() ).toList();
          //listModel = Services.fromJson(list.);
          service = _response;
          print('============LIst====$list');

          data = true;
        });
      }
      else{
        setState(() {
          services = false;
          data = false;
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<List<Type>> getAllData() async {
    print("Active Users");
    var val = await db
        .collection('Services')
        .where('Business Name', isEqualTo: user!.displayName)
        .get();
    var documents = val.docs;
    print("Documents ${documents.length}");
    if (documents.length > 0) {
      try {
        print("Active ${documents.length}");
        return documents.map((docs) {
          //Service bookingList = Service.fromJson(Map<String, dynamic>.from(docs.data));

          return Service;
        }).toList();
      } catch (e) {
        print("Exception $e");
        return [];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double _height1 = _height * 0.5;
    return
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar:  AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("Select services",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,fontSize: 29,
                  textStyle: TextStyle(color: Colors.white)),),
            backgroundColor: primaryColor,
          ),
          body:/* TabBarView(
            children: [*/
              data
                  ?
              Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            color: primaryColor.withOpacity(0.30),
                            child: Center(
                                child: Text('Tap on item to Select.', style: TextStyle(color: primaryColor, fontSize: 18,),)
                            )
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                if(index == _service.length ){
                                  return Container(height : _height1 * 0.18);
                                }

                                else
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                                    child: InkWell(
                                        child: ListTile(
                                          title: Text(
                                            "${_service[index].name}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              _service[index].hr != "0"
                                                  ?
                                              Text(
                                                "${_service[index]
                                                    .hr}Hr ${_service[index]
                                                    .min}min",
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              )
                                                  :
                                              Text(
                                                "${_service[index].min}min",
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              )
                                              ,
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .end,
                                                children: [

                                                  Row(
                                                    children: [

                                                      Container(
                                                        padding: EdgeInsets
                                                            .only(top: 3.0),
                                                        child: Text("₹",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                                decoration: TextDecoration
                                                                    .none)),
                                                      ),
                                                      Text(" ${_service[index]
                                                          .cost}",
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color: Colors
                                                                  .black,
                                                              fontWeight: FontWeight
                                                                  .w400,
                                                              decoration: TextDecoration
                                                                  .none)),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          trailing:
                                          _service[index].addService
                                              ? Icon(Icons.check_circle_rounded,
                                            color: Color(0xff1C396D), size: 30,)
                                              : Icon(
                                            Icons.brightness_1_outlined,
                                            size: 30,),
                                        ),
                                        onTap: () {
                                          if (_service[index].addService ==
                                              false) {
                                            print(0);
                                            sum = sum +
                                                (_service[index].counter *
                                                    double.parse(
                                                        _service[index].cost));
                                            print(1);
                                            totalHr = totalHr +
                                                (_service[index].counter *
                                                    int.parse(
                                                        _service[index].hr));
                                            print(2);
                                            totalMin = totalMin +
                                                (_service[index].counter *
                                                    int.parse(
                                                        _service[index].min));

                                            _cart.add(_service[index]);
                                            print(
                                                '==============================$_cart');
                                            setState(() {
                                              _service[index].addService = true;
                                            });
                                          }

                                          else {
                                            setState(() {
                                              _cart.remove(_service[index]);

                                              sum = sum -
                                                  (_service[index].counter *
                                                      double.parse(
                                                          _service[index]
                                                              .cost));
                                              totalHr = totalHr -
                                                  (_service[index].counter *
                                                      int.parse(
                                                          _service[index].hr));
                                              totalMin = totalMin -
                                                  (_service[index].counter *
                                                      int.parse(
                                                          _service[index].min));
                                              _service[index].addService =
                                              false;
                                            });
                                          }
                                        }
                                    ),
                                  );

                                },
                              itemCount:_service.length !=0 ?_service.length + 1 : 0,
                              shrinkWrap: true,
                            ),


                          ),
                        ),
                      ],
                    ),
                  ),
                      _cart.isEmpty
                          ? SizedBox()
                          : Positioned(
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CustomerInfo(
                                            businessName: widget.businessName,
                                            businessCategory:widget.businessCategory,
                                            cart: _cart,
                                            totalCost: '$sum',
                                            totalHr: totalHr.toInt(),
                                            totalMin: totalMin.toInt()),
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
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(top: 3.0),
                                            child: Text("₹",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    decoration:
                                                        TextDecoration.none)),
                                          ),
                                          Text(" $sum",
                                              style: TextStyle(
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Continue  ",
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      TextDecoration.none)),
                                          Icon(Icons.arrow_forward_rounded)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                    ],
              )
                  :
              Container(
                child: Center(
                  child: services ? page : Text("No services added yet"),),
              ),
/*
              Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                                    child: ListTile(
                                      title: Text(
                                        _cart[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          _cart[index].hr != "0"
                                              ?
                                          Text(
                                            "${_cart[index].hr}Hr ${_cart[index].min}min",
                                            style: TextStyle(fontSize: 16,fontWeight:FontWeight.w300,color: Colors.black),
                                          )
                                              :
                                          Text(
                                            "${_cart[index].min}min",
                                            style: TextStyle(fontSize: 16,fontWeight:FontWeight.w300,color: Colors.black),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(top: 3.0),
                                                    child: Text("₹",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            decoration: TextDecoration.none)),
                                                  ),
                                                  Text(" ${_cart[index].cost}",
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          decoration: TextDecoration.none)),
                                                ],
                                              ),
                                              ],
                                          )
                                        ],
                                      ),
                                      trailing: Icon(Icons.check_circle_rounded,color: Color(0xff1C396D),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      sum = sum - ((_cart[index].counter) * double.parse(_cart[index].cost));
                                      totalHr = totalHr - (_cart[index].counter * int.parse(_cart[index].hr));
                                      totalMin= totalMin - (_cart[index].counter * int.parse(_cart[index].min));

                                      _cart[index].addService = false;
                                      _cart.remove(_cart[index]);
                                      //listModel.data.
                                    });
                                  },
                                );
                              },
                              itemCount: _cart.length,
                              shrinkWrap: true,
                            ))
                      ],
                    ),
                  ),
                  _cart.isEmpty ?
                  SizedBox()
                      : Positioned(
                        bottom: 7,
                        left: 13,
                        height: _height1 * 0.13,
                        width: (_width) - 26,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CustomerInfo(username: 'cgvd', cart: _cart, totalCost: '$sum',
                                    totalHr: totalHr.toInt(), totalMin: totalMin.toInt()),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xff1C396D)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),

                          // height:_height1*0.13,
                          //width: _width-100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                  Text(" $sum",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Continue  ",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none)),
                                  Icon(Icons.arrow_forward_rounded)
                                ],
                              ),
                            ],
                          ),
                        ),
                  )
                ],
              )
            ],*/
          ),
        //),
      );
  }
}

class Service {
  String? BusinessName;
  String? min;
  String? hr;
  String? name;
  String? cost;
  bool? addProduct;
  int? counter;

  Service(
      {required this.BusinessName,
        required this.min,
        required this.hr,
        required this.name,
        required this.cost,
        required this.addProduct,
        required this.counter});

  Service.fromJson(Map<String, dynamic> json) {
    BusinessName = json['Business Name'];
    min = json['min'];
    hr = json['hr'];
    name = json['name'];
    cost = json['cost'];
    addProduct = json['addProduct'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Business Name'] = this.BusinessName;
    data['min'] = this.min;
    data['hr'] = this.hr;
    data['name'] = this.name;
    data['cost'] = this.cost;
    data['addProduct'] = this.addProduct;
    data['counter'] = this.counter;
    return data;
  }
}