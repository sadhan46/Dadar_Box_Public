import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Clip extends StatefulWidget {
  final String clip;
  const Clip({Key? key,required this.clip}) : super(key: key);

  @override
  _ClipState createState() => _ClipState();
}

class _ClipState extends State<Clip> {

  late VideoPlayerController videoPlayerController;

  bool _play=true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController= VideoPlayerController.network(
      '${widget.clip}',
    );

    videoPlayerController.addListener(() {
      setState(() {});
    });
    videoPlayerController.play();
    videoPlayerController.setLooping(true); //loop through video
    videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          height: 500,
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: VideoPlayer(videoPlayerController)
      ),

      onTap: (){
        if(_play == true){
          videoPlayerController.pause();
          _play = false;
          return;
        }
        if(_play == false){
          videoPlayerController.play();
          _play = true;
          return;
        }
      },
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
