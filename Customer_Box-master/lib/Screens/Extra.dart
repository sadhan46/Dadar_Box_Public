import 'package:dadarbox/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Extra extends StatefulWidget {
  const Extra({Key? key}) : super(key: key);

  @override
  _ExtraState createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gifts & Accessories',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: primaryColor),),
            SizedBox(height: 10,),
            Flexible(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width*0.5,
                    childAspectRatio: 16/12,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemBuilder: (context, index) {
                  return
                    InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Image.asset('assets/Creditcard.png'),
                          ),
                          SizedBox(height: 4,),
                          Text('  Ashish Stores',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),)
                        ],
                      ),
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: AspectRatio(
                              aspectRatio: 9/16,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: primaryColor
                                ),
                              ),
                            ),
                          )

                      ),
                    );
                },
                itemCount: 4,
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      )
    );
  }
}
