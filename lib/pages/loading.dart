import 'package:flutter/material.dart';
import 'package:newnew/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

//HEREE!!
class _LoadingState extends State<Loading> {
  String time = 'loading';

  void setupWorldTime() async {
    WorldTime lezgo = WorldTime(
        location: 'Manila', flag: 'Philippines.png', url: 'Asia/Manila');
    await lezgo.getTime();
    setState(() {
      time = lezgo.time;
    });
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': lezgo.location,
      'flag': lezgo.flag,
      'time': lezgo.time,
      'isDayTime': lezgo.isDayTime
    });
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 118, 202, 241),
      body: Center(
          child: SpinKitFoldingCube(
        color: Colors.white,
        size: 50.0,
      )),
    );
  }
}
