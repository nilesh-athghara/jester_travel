import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SecondScreen extends StatefulWidget {
  final String data;

  SecondScreen(this.data);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String customerId='';
  String readableDepartureTimeForDestination='';
  String readableDepartureTimeForReturn='';
  String departureCityInfoForDestination='';
  String departureAirportInfoForDestination='';
  String departureTimeForDestination='';
  String departureCityInfoForReturn='';
  String departureAirportInfoForReturn='';
  String departureTimeForReturn='';
  String awayTimeForDestination='';
  String awayTimeForReturn='';
  Map approvedItenary;
  String hotel='';
  String car='';
  String url='';

  @override
  void initState() {
    super.initState();
    customerId = widget.data;
    print('customer id' + widget.data.toString());
    url = 'http://www.jestertraveldemo.com/api/get-itinerary/$customerId';
    getDataApi();
  }

  String convert(int n) {
    int day = int.parse(((n / (24 * 3600)).floor()).toString());

    n = n % (24 * 3600);
    int hour = int.parse(((n / 3600).floor()).toString());

    n %= 3600;
    int minutes = int.parse(((n / 60).floor()).toString());

    n %= 60;
    int seconds = n;
    return " ${day.toString()} day ${hour.toString()} hour ${minutes.toString()} minutes away ";
  }

  Future<Map> getDataApi() async {
    DateTime current = DateTime.now();
    await http.get(url).then((data) {
      Map<String, dynamic> map = json.decode(data.body);
      for (int i = 0; i < map['Itineraries'].length; i++) {
        if (map['Itineraries'][i]['Status'] == 'Accepted') {
          approvedItenary = map['Itineraries'][i];
        }
      }
      for (int i = 0; i < map['HotelItineraries'].length; i++) {
        if (map['HotelItineraries'][i]['Status'] == 'Accepted') {
          hotel = map['HotelItineraries'][i]['hotelName'];
        }
      }
      for (int i = 0; i < map['CarItineraries'].length; i++) {
        if (map['CarItineraries'][i]['Status'] == 'Accepted') {
          car = map['CarItineraries'][i]['carName'];
        }
      }
      if(approvedItenary!=null)
        {
          departureCityInfoForReturn =
          approvedItenary['ReturnFlightData'][0]['DepartureCityInfo']['name'];
          departureAirportInfoForReturn = approvedItenary['ReturnFlightData'][0]
          ['DepartureAirportInfo']['code'];
          departureCityInfoForDestination = approvedItenary['DestinationFlightData']
          [0]['DepartureCityInfo']['name'];
          departureAirportInfoForDestination =
          approvedItenary['DestinationFlightData'][0]['DepartureAirportInfo']
          ['code'];
          departureTimeForReturn =
          approvedItenary['ReturnFlightData'][0]['DateOfTakeoff'];
          departureTimeForDestination =
          approvedItenary['DestinationFlightData'][0]['DateOfTakeoff'];
          readableDepartureTimeForDestination = DateFormat.yMMMMd("en_US")
              .add_jm()
              .format(DateTime.parse(
              approvedItenary['DestinationFlightData'][0]['DateOfTakeoff']));
          readableDepartureTimeForReturn = DateFormat.yMMMMd("en_US").format(
              DateTime.parse(
                  approvedItenary['ReturnFlightData'][0]['DateOfTakeoff']));
          int beforeForDestination =
              (DateTime.parse("$departureTimeForDestination"))
                  .difference(current)
                  .inSeconds;
          awayTimeForDestination = (beforeForDestination > 0)
              ? convert(beforeForDestination)
              : 'already passed';
          int beforeForReturn = (DateTime.parse("$departureTimeForReturn"))
              .difference(current)
              .inSeconds;
          awayTimeForReturn =
          (beforeForReturn > 0) ? convert(beforeForReturn) : 'already passed';
        }
    });

    return {
      'destinationFlight': {
        'leavingAirport': departureAirportInfoForDestination,
        'leavingCity': departureCityInfoForDestination,
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jester Travel",
            style: TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: getDataApi(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("snapshot data" + snapshot.data.toString());
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.only(left: 20, right: 20),
              children: <Widget>[
                SizedBox(height: 10),
                  Text(
                    "Destination Flight",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Leaving city :",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      Text(snapshot.data['destinationFlight']['leavingCity']),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Leaving Airport :",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          snapshot.data['destinationFlight']['leavingAirport']),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          'Customer will leave on : $readableDepartureTimeForDestination  which is $awayTimeForDestination'),
                    ],
                  ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  "Stay Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Hotel Name :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(hotel),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  "Car Details ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('Car Name :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(car),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Return Flight",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Leaving city:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(departureCityInfoForReturn),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("Leaving Airport:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(departureAirportInfoForReturn),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        'Customer will leave on :$readableDepartureTimeForReturn which is $awayTimeForReturn'),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                )
              ],
            );
          } else {
            return Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },
      ),
    );
  }
}
