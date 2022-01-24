
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  profile(String uid) {
    return FirebaseFirestore.instance
        .collection('Customer Profile')
        .where('uid',isEqualTo: uid)
        .get();
  }
}