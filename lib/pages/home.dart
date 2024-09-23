import 'package:flutter/material.dart';
import 'dart:async'; // Needed for Timer
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.lightBlueAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
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
                          color: Color.fromARGB(255, 236, 143, 76),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
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
                            Icons.access_time_filled,
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
                              onPressed: toggleClock,
                              child: Text(
                                isClockedIn ? 'Clock Out' : 'Clock In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isClockedIn
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // TIMECARD BUTTON
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 236, 143, 76),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Time Card',
                                      style: TextStyle(color: Colors.black))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gavel,
                            size: 30, color: Color.fromARGB(255, 17, 76, 124)),
                        SizedBox(width: 10),
                        Text(
                          'Government',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.black, // Dark color for the icon
            ),
            label: 'Self Service',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logo.png',
              width: 27,
              height: 27,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.black, // Dark color for the icon
            ),
            label: 'Profile Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(
            255, 17, 180, 221), // Dark color for selected item
        unselectedItemColor: Colors.black, // Color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
