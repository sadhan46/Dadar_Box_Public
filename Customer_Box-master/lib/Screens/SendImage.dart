import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class SendImage extends StatefulWidget {
  final String chatRoom;
  final bool firstMessage;

  const SendImage({Key? key,required this.chatRoom,required this.firstMessage}) : super(key: key);

  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {


  User? user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.reference();

  TextEditingController messageEditingController = new TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile ;

  bool sending = false;

  addImage() async{

    if (_imageFile != null) {
      sending = true;

      int time = DateTime.now().millisecondsSinceEpoch;

      final storage = FirebaseStorage.instance.ref().child('Chat Images').child('${widget.chatRoom}_$time');
      final result = await storage.putFile(File(_imageFile!.path));
      final imageURL = await result.ref.getDownloadURL();

      Map<String, dynamic> chatMessageMap = {
        "sendBy": user!.uid,
        "message": messageEditingController.text,
        "image": imageURL,
        'time': time,
      };

      if(widget.firstMessage == true) {
        print('firstmessage true hai ');
        await database.child('Chats').update(
            {
              //'Customers/${user!.uid}/${widget.businessName}_${user!.uid}/customer_Activity': time,
              'Customers/${user!.uid}/${widget.chatRoom}_${user!.uid}/last_Activity': time,

              //'Businesses/${widget.businessName}/${widget.businessName}_${user!.uid}/customer_Activity': time,
              'Businesses/${widget.chatRoom}/${widget.chatRoom}_${user!.uid}/last_Activity': time,
            });
      }

      if(widget.firstMessage == false ) {
        print('firstmessage false hai ');
        await database.child('Chats').update(
            {
              'Customers/${user!.uid}/${widget.chatRoom}_${user!.uid}/customer_Name': user!.displayName,
              'Customers/${user!.uid}/${widget.chatRoom}_${user!.uid}/business_Name': widget.chatRoom,
              'Customers/${user!.uid}/${widget.chatRoom}_${user!.uid}/customer_Activity': time,
              'Customers/${user!.uid}/${widget.chatRoom}_${user!.uid}/last_Activity': time,

              'Businesses/${widget.chatRoom}/${widget.chatRoom}_${user!.uid}/customer_Name': user!.displayName,
              'Businesses/${widget.chatRoom}/${widget.chatRoom}_${user!.uid}/business_Name': widget.chatRoom,
              'Businesses/${widget.chatRoom}/${widget.chatRoom}_${user!.uid}/customer_Activity': time,
              'Businesses/${widget.chatRoom}/${widget.chatRoom}_${user!.uid}/last_Activity': time,
            });
      }

      await database.child('Chatrooms/${widget.chatRoom}').push().set(chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        sending = true;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectImage();
  }

  void selectImage() async{
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget _image(){
    return Expanded(
        child: InkWell(
          child: Container(
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.1),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(_imageFile!.path)),
                    fit: BoxFit.cover,
                  ))),
          onTap: () async {
            final pickedFile = await _picker.pickImage(
                source: ImageSource.gallery, imageQuality: 10);
            setState(() {
              _imageFile = pickedFile;
            });
          },
        ));
  }

  Widget _noImage() {
    return Expanded(
        child: Container(
          height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.1),
          color: Colors.black87,

        ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            _imageFile == null ? _noImage() : _image(),
            Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        if(sending == false){
                          addImage();
                        }
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/send.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}