import 'package:flutter/material.dart';
import 'dart:async'; // Needed for Timer
import 'package:google_fonts/google_fonts.dart';
import 'package:newnew/services/card.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  Timer? _timer;
  String? clockInTime;
  String? clockOutTime;
  bool isClockedIn = false; // Track clock-in status
  int _selectedIndex = 0; // Track the current index of the bottom navigation

  List<displayCard> displays = [
    displayCard(visual: 'sss.png', title: 'SSS'),
    displayCard(visual: 'tax.png', title: 'Tax'),
    displayCard(visual: 'philhealth.png', title: 'Philhealth'),
  ];

  Widget cardTemplate(display) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/${display.visual}'),
              width: 50,
              height: 50,
            ),
            SizedBox(height: 3),
            FittedBox(
              child: Text(
                display.title,
                style: TextStyle(fontSize: 20), // Base font size
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleClock() {
    final now = DateTime.now();
    setState(() {
      if (!isClockedIn) {
        // Clock In
        clockInTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
      } else {
        // Clock Out
        clockOutTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
      }
      isClockedIn = !isClockedIn; // Toggle clock-in status
    });
  }

  @override
  void initState() {
    super.initState();
    startClock(); // Start the clock when the widget is initialized
  }

  void startClock() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        data['time'] = _getTimeString(); // Update the time
      });
    });
  }

  String _getTimeString() {
    return DateTime.now().toLocal().toString().split(' ')[1].substring(0, 8);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)?.settings.arguments;
    if (routeData != null && routeData is Map && data.isEmpty) {
      data = routeData;
    }

    data['time'] = data['time'] ?? _getTimeString();
    Color bgColor = data['isDayTime'] ? Colors.blue[300]! : Colors.indigo[900]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(5, 40, 5, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Babae Girl',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Head Marketing Queen',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(185, 207, 207, 207),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Today:',
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 20),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${data['time'] ?? _getTimeString()}',
                                  style: GoogleFonts.oswald(
                                    textStyle: const TextStyle(
                                        letterSpacing: .5, fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                dynamic result = await Navigator.pushNamed(
                                    context, '/location');
                                setState(() {
                                  data = {
                                    'location': result['location'],
                                    'flag': result['flag'],
                                    'time': result['time'],
                                    'isDayTime': result['isDayTime']
                                  };
                                });
                              },
                              icon: Icon(Icons.location_on),
                            )
                          ],
                        ),
                      ),
                      // CLOCK IN | CLOCK OUT
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Clock In',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'Courier',
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  clockInTime != null ? '$clockInTime' : '--',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            color: isClockedIn ? Colors.green : Colors.red,
                            size: 90,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Clock Out',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                                Text(
                                  clockOutTime != null
                                      ? ' $clockOutTime'
                                      : ' --',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // CLOCK BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200]),
                              onPressed: toggleClock,
                              child: Text(
                                isClockedIn ? 'Clock Out' : 'Clock In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isClockedIn
                                        ? Colors.red
                                        : Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // TIMECARD BUTTON
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Timecard',
                                      style: TextStyle(color: Colors.black))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: const Color.fromARGB(
                    137, 158, 158, 158), // Set your desired color here
                height: 4, // Set the height of the colored box
                child: SizedBox.expand(), // This expands to fill the container
              ),
              SizedBox(height: 10),
              //ANNOUNCEMENT
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(185, 207, 207, 207),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.notification,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Announcement",
                            style: TextStyle(letterSpacing: 3, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(
                          137, 158, 158, 158), // Set your desired color here
                      height: 1, // Set the height of the colored box
                      child: SizedBox
                          .expand(), // This expands to fill the container
                    ),
                    //ANNOUNCEMENT CONTENT
                    Container(
                      height: 30,
                      child: SizedBox.expand(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: const Color.fromARGB(
                    137, 158, 158, 158), // Set your desired color here
                height: 4, // Set the height of the colored box
                child: SizedBox.expand(), // This expands to fill the container
              ),
            ],
          ),
        ),
      ),
    );
  }
}
