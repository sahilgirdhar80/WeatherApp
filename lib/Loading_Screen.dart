import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Constants.dart';

import 'city_screen.dart';

const apikey = "a90a7acf1ebbb217155c1b6f80fb2db1";
String? weatherIcon;
String? weatherMessage;
double? temp;
int? temperature;
String? cityname;
dynamic decodeddata;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String locationMessage = 'Press the button to get location';
  double? longitude;
  double? latitude;

  void getLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();

      setState(() {
        longitude = position?.longitude;
        latitude = position?.latitude;
        locationMessage =
            'Location: ${position?.latitude}, ${position?.longitude}';
      });

      if (longitude != null && latitude != null) {
        getData().then((decodeddata) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LocationPage(decodeddata: decodeddata);
          }));
        });
      }
    } catch (e) {
      setState(() {
        locationMessage = 'Error: $e';
      });
    }
  }

  Future<dynamic> getData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey&units=metric'));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodeddata = jsonDecode(data);
        return decodeddata;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class LocationPage extends StatefulWidget {
  final decodeddata;

  const LocationPage({Key? key, required this.decodeddata}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? weatherIcon;
  String? weatherMessage;
  double? temp;
  int? temperature;
  String? cityname;

  @override
  void initState() {
    super.initState();
    updateData(widget.decodeddata);
  }

  void updateData(dynamic data) {
    weatherIcon = getWeatherIcon(data['weather'][0]['id']);
    weatherMessage = getMessage(data['main']['temp']);
    temp = data['main']['temp'];
    temperature = temp!.toInt();
    cityname = data['name']; // Convert double to int
    print(cityname);
    print(temperature);
  }

  void updateCity(String newCity) async {
    setState(() {
      cityname = newCity;
    });
    dynamic newData = await getData(newCity);
    updateData(newData);
  }

  Future<dynamic> getData(String city) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apikey&units=metric'));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodeddata = jsonDecode(data);
        return decodeddata;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop)),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        setState(() {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return LoadingScreen();
                          }));
                        });
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 50,
                      )),
                  FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CityScreen(onCityChanged: updateCity);
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.location_city,
                        size: 50,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  children: [
                    Text(
                      '$temperature°', // Print temperature as int
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '$weatherMessage in $cityname',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              )
            ])),
      ),
    );
  }
}
