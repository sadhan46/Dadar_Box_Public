
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadarbox/Screens/Home.dart';
import 'package:dadarbox/Screens/NewHome.dart';
import 'package:dadarbox/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddProfile extends StatefulWidget {

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {

  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final _globalKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController dOB = TextEditingController();
  TextEditingController pinCode = TextEditingController();

  DateTime date = DateTime.now();
  DateTime memberSince= DateTime.now();


  Widget buildLastNameTF(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        validator: (value) {
          if (value ==null || value.isEmpty) {
            return "Enter $label";
          }
          if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Enter alphabets only";
          }
          if (value.length > 10) {
            return "Enter less than 10 characters";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "$label",
          counterText: '',
        ),
        maxLines: 1,
        maxLength: 10,
      ),
    );
  }

  Widget buildFirstNameTF(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter $label";
          }
          if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Enter alphabets only";
          }
          if (value.length > 10) {
            return "Enter less than 10 characters";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "$label",
          counterText: '',
        ),
        maxLines: 1,
        maxLength: 10,
      ),
    );
  }

  Widget buildAddressTF(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
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
        ),
        maxLines: 2,
      ),
    );
  }

  Widget buildEmailIdTF(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(

        controller: controller,
        validator: (value) {
          if (value ==null || value.isEmpty) {
            return "Enter $label";
          }
          return null;
        },
        onTap: () async {
          // Below line stops keyboard from appearing
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        decoration: InputDecoration(

            labelText: "$label",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: user!.email!,
            hintStyle: TextStyle(
                color: Colors.black
            )
        ),
        maxLines: 1,
      ),
    );
  }

  Widget buildPinCodeTF(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        validator: (value) {
          if (value ==null || value.isEmpty) {
            return "Enter $label";
          }
          if (value.length < 6) {
            return "Enter 6 digit Pincode";
          }
          if (value.contains('-')) {
            return "Enter numbers only";
          }
          if (value.contains(',')) {
            return "Enter numbers only";
          }
          if (value.contains('.')) {
            return "Enter numbers only";
          }
          if (value.contains(' ')) {
            return "Enter numbers only";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "$label",
          counterText: '',
        ),
        maxLines: 1,
        maxLength: 6,
      ),
    );
  }

  Widget buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
          controller: dOB,
          validator: (value){
            if (value ==null || value.isEmpty) {
              return "Enter Date Of Birth";
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Date Of Birth",
          ),
          maxLines: 1,
          onTap: () async {
            // Below line stops keyboard from appearing
            FocusScope.of(context).requestFocus(new FocusNode());
            // Show Date Picker Here
            await _selectDate(context);
            dOB.text = DateFormat('dd - MM - yyyy').format(date);
            //setState(() {});
          }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1950),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      print('hello $picked');
      setState(() {
        date = picked;
      });
    }
  }

  void updateDisplayName() async {
    user!.updateDisplayName('${firstName.text} ${lastName.text}')
        .then((value) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => NewHome(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Profile',style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,fontSize: 28,
            textStyle: TextStyle(color: Colors.white))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                  radius: 70,
                  //foregroundColor: primaryColor,
                  backgroundColor: primaryColor,
                  child: Icon(CupertinoIcons.person,size: 100,)
              ),
              SizedBox(height: 20),
              buildFirstNameTF(firstName, "First Name"),
              SizedBox(height: 20),
              buildLastNameTF(lastName, "Last Name"),
              SizedBox(height: 20),
              buildEmailIdTF(email, "Email ID"),
              SizedBox(height: 20),
              buildDateOfBirthField(),
              SizedBox(height: 20),
              buildAddressTF(address, 'Address'),
              SizedBox(height: 20),
              buildPinCodeTF(pinCode, "Area Pincode")
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          email.text=user!.email!;
          if(_globalKey.currentState!.validate()){
            db.collection('Customer Profile').add({
              'customerId': user!.uid,
              'First Name': firstName.text,
              'Last Name': lastName.text,
              'Email': email.text,
              'Member Since': DateFormat('dd - MM - yyyy').format(memberSince),
              'DOB': dOB.text,
              'Address': address.text,
              'Pincode': pinCode.text
            }).whenComplete(() => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => NewHome(),
                  ),
                ));
          }
        },
        child: const Icon(Icons.thumb_up_alt_rounded),
      ),
    );
  }


}
