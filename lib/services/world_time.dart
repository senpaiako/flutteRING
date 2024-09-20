import 'package:http/http.dart' as http; // Alias http to avoid conflicts
import 'dart:convert'; // For jsonDecode
import 'package:intl/intl.dart';

class WorldTime {
  late String location; //location name for the UI
  late String time; //the time in that location
  late String flag; //url to an asset flag icon
  late String url; //url for api
  late bool isDayTime; //true or false for day or not

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    // Convert the URL string to a Uri object using Uri.parse()
    http.Response response =
        await http.get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));

    // Decode the response body from JSON
    Map data = jsonDecode(response.body);
    //get properties from data
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);

    //create DateTime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    //set the time property
    isDayTime = now.hour > 6 && now.hour < 18 ? true : false;
    time = DateFormat.jm().format(now);
  }
}
