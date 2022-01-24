import 'dart:ui';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xff3b5998);
Color liteNavyColor = Color(0xff3b5998);
Color backgroundColor = Color(0xfff2f5ff);
Color darkNavyBlue = Color(0xff1C396D);
Color textBoxColor = Color(0xffcfd4e5);
TextStyle xyz = TextStyle();


final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: primaryColor,
    minimumSize: Size(225, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    )
);

final ButtonStyle businessButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: primaryColor,
    minimumSize: Size(125, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    )
);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
